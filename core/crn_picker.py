import requests
from json import loads
from .user import UserConfig, UserSchedules
from PySide6.QtQml import QmlElement
from PySide6.QtCore import QObject, Slot, Signal, Property

QML_IMPORT_NAME = "core.CrnPicker"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
class CrnPicker(QObject):
    """Handles the post requests and responses

    Grabs these informations from UserConfig:
    - ECRN (list of crns to be picked)
    - SCRN (list of crns to be dropped)
    - Authorization token"""

    # Error codes from Kepler
    return_values = {
        "label": {
            "successResult": "The operation for the course with CRN {} has been successfully completed.",
            "errorResult": "No operation was completed in this process group.",
            "error": "An error occurred during the operation.",
            "VAL01": "The course with CRN {} cannot be added due to a problem.",
            "VAL02": "The course with CRN {} cannot be added due to 'Enrollment Time Hold'.",
            "VAL03": "The course with CRN {} could not be taken again because it was taken this semester.",
            "VAL04": "The course with CRN {} could not be taken because it was not included in the lesson plan.",
            "VAL05": "The course with CRN {} cannot be added as maximum number of credits allowed for this term is exceeded.",
            "VAL06": "The course with CRN {} cannot be added as the enrollment limit has been reached and there is no quota left.",
            "VAL07": "The course with CRN {} cannot be re-added because this course has been completed before with an AA grade.",
            "VAL08": "The course with CRN {} could not be taken because the your program is not among the programs that can take this course.",
            "VAL09": "The course with CRN {} cannot be added due to a time conflict with another course.",
            "VAL10": "No action has been taken because you are not registered to the course with CRN {} this semester.",
            "VAL11": "The course with CRN {} cannot not be added as its prerequisites are not met.",
            "VAL12": "The course with CRN {} is not offered in the respective semester.",
            "VAL13": "The course with CRN {} has been temporarily disabled.",
            "VAL14": "System is temporarily disabled.",
            "VAL15": "You can send maximum 12 CRN parameters.",
            "VAL16": "You currently have an ongoing transaction, try again later.",
            "VAL18": "The course with CRN {} could not be taken because 'Attribute Hold'.",
            "VAL19": "The course with CRN {}  could not be taken because it is an undergraduate course.",
            "VAL20": "You can leave only 1 course per semester.",
            "CRNListEmpty": "The course with CRN {} is not available during the course selection period.",
            "CRNNotFound": "The course with CRN {} is not available during the course selection period.",
            "ERRLoad": "This service is temporarily unavailable.",
        },
    }

    def __init__(self, parent=None):
        super().__init__(parent)

        self.payload = {
            "ECRN": [],
            "SCRN": [],
        }
        self.headers = {
            "authority": "kepler-beta.itu.edu.tr",
            "method": "POST",
            "path": "/api/ders-kayit/v21",
            "scheme": "https",
            "authorization": UserConfig().auth_token,
        }

        self._is_working = False


    # latestResponse qml property

    def getIsWorking(self):
        return self._is_working

    def setIsWorking(self, value):
        self._is_working = value
        self.isWorkingChanged.emit()

    @Signal
    def isWorkingChanged(self):
        pass

    isWorking = Property(bool, getIsWorking,
                          setIsWorking, notify=isWorkingChanged)

    @Slot()
    def startRequests(self):
        config = UserConfig()

        #config.latest_response.clear()
        #config.latestResponseChanged.emit()


        schedules = UserSchedules()
        current_schedule_name = config.getCurrentSchedule()
        current_schedule_index = schedules.getIndex(current_schedule_name)

        self.payload["ECRN"] = [str(schedule) for schedule in schedules.getECRNList(current_schedule_index)]
        self.payload["SCRN"] = [str(schedule) for schedule in schedules.getSCRNList(current_schedule_index)]

        self.setIsWorking(True)

    @Slot()
    def stopRequests(self):
        self.setIsWorking(False)

    @Slot()
    def sendRequest(self):
        """Sends request ford CRN picking/dropping.

        Grabs the latest auth token before sending the request.

        Returns the response."""

        config = UserConfig()

        if config.getMaxRequestCount() != -1 and config.getRequestCount() >= config.getMaxRequestCount():
            self.setIsWorking(False)
            return


        self.updateAuthToken()
        response = requests.post(
            "https://kepler-beta.itu.edu.tr/api/ders-kayit/v21",
            headers=self.headers,
            json=self.payload,
        )

        config.setRequestCount(config.getRequestCount() + 1)
        self.identifyResponse(response)

    def updateAuthToken(self):
        """Grabs the latest authorization token from the UserConfig"""
        self.headers["authorization"] = UserConfig().auth_token

    @Slot()
    def identifyResponse(self, response):
        """Identifies the response.

        If CRN operation was unsuccessfull:
        - Updates the reason in UserConfig.latest_response.

        If CRN operation was successfull:
        - Updates the UserConfig.latest_response as successfull.
        - Removes the CRN from the ECRN or SCRN list. (from the one that it belongs)"""
        response_content = response.json()

        for element in response_content["ecrnResultList"]:
            UserConfig().latest_response.update(
                {
                    element["crn"]: {
                        "type": "ECRN",
                        "statusCode": str(element["statusCode"]),
                        "message": f'The course with CRN { element["crn"]} has been successfully added.' if str(element["statusCode"]) == "0"
                                    else self.return_values["label"][element["resultCode"]].format(element["crn"]),
                    }
                }
            )
            if str(element["statusCode"]) == "0":
                self.payload["ECRN"].remove(element["crn"])

        for element in response_content["scrnResultList"]:
            UserConfig().latest_response.update(
                {
                    element["crn"]: {
                        "type": "SCRN",
                        "statusCode": str(element["statusCode"]),
                        "message": f'The course with CRN { element["crn"]} has been successfully dropped.' if str(element["statusCode"]) == "0"
                        else self.return_values["label"][element["resultCode"]].format(element["crn"]),
                    }
                }
            )
            if str(element["statusCode"]) == "0":
                self.payload["SCRN"].remove(element["crn"])

        UserConfig().latestResponseChanged.emit()

