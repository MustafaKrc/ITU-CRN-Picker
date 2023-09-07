from datetime import datetime
import configparser
import json
from dataclasses import dataclass


from PySide6.QtQml import QmlElement, QmlSingleton
from PySide6.QtCore import QObject, Slot, Signal, Property


@dataclass
class Schedule:

    def __init__(self, name="Schedule", ECRN=[], SCRN=[]):
        self.name = name
        self.ECRN = ECRN
        self.SCRN = SCRN

    @staticmethod
    def isValidCRNList(crnList):

        for crn in crnList:
            if not crn.isdigit():  # isdigit will reject negative numbers
                return False

        return True


QML_IMPORT_NAME = "core.UserSchedules"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
@QmlSingleton
class UserSchedules(QObject):

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(UserSchedules, cls).__new__(cls)
            cls.instance.initialized = False
        return cls.instance

    def __init__(self, parent=None):
        if (self.initialized):
            return

        self.initialized = True
        super().__init__(parent)

        self.schedules = []

        try:
            # Open the JSON file for reading
            with open("schedules.json", 'r') as file:
                # Parse the JSON data
                json_file = json.load(file)
        except FileNotFoundError:
            print("File not found: schedules.json")
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")
        except Exception as e:
            print(f"An error occurred: {e}")

        for scheduleName in json_file:
            self.schedules.append(Schedule(name=scheduleName,
                                           ECRN=json_file[scheduleName]['ECRN'],
                                           SCRN=json_file[scheduleName]['SCRN']))

    def __len__(self):
        return len(self.schedules)

    @Slot(str, result=int)
    def getIndex(self, name: str):
        for index, schedule in enumerate(self.schedules):
            if name == schedule.name:
                return index
        return -1

    @Slot(int, result=str)
    def getName(self, index: int):
        return self.schedules[index].name

    @Slot(int, result=list)
    def getECRNList(self, index):
        return self.schedules[index].ECRN

    @Slot(int, result=list)
    def getSCRNList(self, index):
        return self.schedules[index].SCRN

    @Slot(str, list, list, result=list)
    def addSchedule(self, name, ECRNList, SCRNList):

        for schedule in self.schedules:
            if name == schedule.name:
                return [False, "There exists another schedule with the same name."]

        self.schedules.append(Schedule(name, ECRNList, SCRNList))
        return [True, "Schedule is successfully added."]

    @Slot(int, str, list, list, result=list)
    def editSchedule(self, scheduleIndex, newName, newECRNList, newSCRNList):

        currentSchedule = self.schedules[scheduleIndex]

        for index, schedule in enumerate(self.schedules):
            if schedule.name == newName and index != scheduleIndex:
                return [False, "There exist another schedule with same name"]

        if not Schedule.isValidCRNList(newECRNList):
            return [False, "There is an error with picked CRN list"]

        if not Schedule.isValidCRNList(newSCRNList):
            return [False, "There is an error with dropped CRN list"]

        currentSchedule.name = newName
        currentSchedule.ECRN = list(map(int, newECRNList))
        currentSchedule.SCRN = list(map(int, newSCRNList))

        self.saveSchedules()

        return [True, "Schedule is successfully edited."]

    @Slot(int, result=list)
    def deleteSchedule(self, scheduleIndex):

        self.schedules.pop(scheduleIndex)
        self.saveSchedules()
        return [True, "Schedule is successfully removed."]

    def saveSchedules(self):
        data = {}
        for schedule in self.schedules:
            data[schedule.name] = {
                "ECRN": schedule.ECRN,
                "SCRN": schedule.SCRN
            }

        jsonObject = json.dumps(data, indent=4)

        try:
            with open("schedules.json", "w") as file:
                file.write(jsonObject)
        except Exception as e:
            print(f"An error occurred: {e}")


QML_IMPORT_NAME = "core.UserConfig"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0


@QmlElement
@QmlSingleton
class UserConfig(QObject):
    """Class for user settings and information.

    Grabs all the information from .env file

    Other classes can grab/write information."""

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(UserConfig, cls).__new__(cls)
            cls.instance.initialized = False
        return cls.instance

    def __init__(self, parent=None):
        if (self.initialized):
            return

        self.initialized = True

        super().__init__(parent)

        self.config = configparser.ConfigParser()
        self.config.read('config.ini')

        # username = getenv("ITUUserName")
        # password = getenv("ITUPassword")

        self.auth_token = None
        self.request_count = 0
        self.latest_response = dict()

        self._rememberMe = self.config["login"]["rememberMe"].lower() == "true"
        self._keepMeSignedIn = self.config["login"]["keepMeSignedIn"].lower() == "true"
        self._requestInterval = self.config["request"]["requestInterval"]
        self._maxRequestCount = self.config["request"]["maxRequestCount"]
        self._version = self.config["about"]["version"]

    @Slot(str, str, result=str)
    def getSetting(self, section, setting):
        # this function will not provide binding in qml
        return self.config[section][setting]

    def saveConfig(self):
        try:
            with open('config.ini', 'w') as configfile:
                self.config.write(configfile)
                self.configChanged.emit()
        except Exception as e:
            return [False, f"An error occurred: {e}"]

        return [True, "Settings are successfully saved."]
    
    # version qml property

    def getVersion(self):
        return self._version
    
    version = Property(str, getVersion,constant=True)
    

    # rememberMe qml property

    def getRememberMe(self):
        return self._rememberMe

    def setRememberMe(self, value):
        self._rememberMe = value
        self.config["login"]["rememberMe"] = str(value)
        self.rememberMeChanged.emit()
        self.saveConfig()

    @Signal
    def rememberMeChanged(self):
        pass

    rememberMe = Property(bool, getRememberMe,
                          setRememberMe, notify=rememberMeChanged)
    
    # keepMeSignedIn qml property
    
    def getKeepMeSignedIn(self):
        return self._keepMeSignedIn

    def setKeepMeSignedIn(self, value):
        self._keepMeSignedIn = value
        self.config["login"]["keepMeSignedIn"] = str(value)
        self.keepMeSignedInChanged.emit()
        self.saveConfig()

    @Signal
    def keepMeSignedInChanged(self):
        pass
    keepMeSignedIn = Property(bool, getKeepMeSignedIn,
                              setKeepMeSignedIn, notify=keepMeSignedInChanged)
    
    # requestInterval qml property
    
    def getRequestInterval(self):
        return self._requestInterval

    def setRequestInterval(self, value):
        self._requestInterval = value
        self.config["request"]["requestInterval"] = value
        self.requestIntervalChanged.emit()
        self.saveConfig()

    @Signal
    def requestIntervalChanged(self):
        pass
    requestInterval = Property(str, getRequestInterval,
                              setRequestInterval, notify=requestIntervalChanged)
    
    # maxRequestCount qml property
    
    def getMaxRequestCount(self):
        return self._maxRequestCount

    def setMaxRequestCount(self, value):
        self._maxRequestCount = value
        self.config["request"]["maxRequestCount"] = value
        self.saveConfig()
        
    @Signal
    def maxRequestCountChanged(self):
        pass
    maxRequestCount = Property(str, getMaxRequestCount,
                              setMaxRequestCount, notify=maxRequestCountChanged)


