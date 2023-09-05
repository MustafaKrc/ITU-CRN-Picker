from datetime import datetime
import configparser
import json
from dataclasses import dataclass


from PySide6.QtQml import QmlElement, QmlSingleton
from PySide6.QtCore import QObject, Slot, Signal


@dataclass
class Schedule:

    def __init__(self,name = "Schedule", ECRN = [], SCRN = []):
        self.name = name
        self.ECRN = ECRN
        self.SCRN = SCRN


QML_IMPORT_NAME = "core.UserSchedules"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
@QmlSingleton
class UserSchedules(QObject):

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(UserSchedules,cls).__new__(cls)
            cls.instance.initialized = False
        return cls.instance


    def __init__(self, parent = None):
        if(self.initialized): return

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

        for x in json_file:
            self.schedules.append(Schedule(name = x,
                                        ECRN = json_file[x]['ECRN'],
                                        SCRN = json_file[x]['SCRN']))

    def __len__(self):
        return len(self.schedules)

    @Slot(str, result = int)
    def getIndex(self, name: str):
        for index, schedule in enumerate(self.schedules):
            if name == schedule.name:
                return index
        return -1

    @Slot(int, result = str)
    def getName(self,index: int):
        return self.schedules[index].name

    @Slot(int, result = list)
    def getECRNList(self, index):
        return self.schedules[index].ECRN

    @Slot(int, result = list)
    def getSCRNList(self, index):
        return self.schedules[index].SCRN


    @Slot(str, list, list, result = list)
    def addSchedule(self, name, ECRNList, SCRNList):

        for schedule in self.schedules:
            if name == schedule.name:
                return [False, "There exists another schedule with the same name."]

        self.schedules.append(Schedule(name, ECRNList, SCRNList))
        return [True, "Schedule is successfully added."]

    @Slot(str, str , list, list, result = list)
    def editSchedule(self, currentScheduleName, newName, newECRNList, newSCRNList):
        for schedule in self.schedules:
            if name == schedule.name:
                currentSchedule = schedule
        else:
            return [False, "Schedule is not found."]

        currentSchedule.name = newName
        currentSchedule.ECRN = newECRNList
        currentSchedule.SCRN = newSCRNList

        return [True, "Schedule is successfully edited."]

    @Slot(str, result = list)
    def deleteSchedule(self, scheduleName):
        index = 0
        for i, schedule in enumerate(self.schedules):
            if name == schedule.name:
                index = i
        else:
            return [False, "Schedule is not found."]

        self.schedules.pop(i)
        return [True, "Schedule is successfully removed."]




settingTexts = {
    "login": {
        "rememberMe": "Remember username and password on each login.",
        "keepMeSignedIn": "Automatically log into my account everytime i run application."
    },
    "request": {
        "requestInterval": "Amount of seconds between each post request to server.",
        "maxRequestCount": "Maximum amount of request to make. (Type -1 for unlimited)",


    },
    "token" : {
    },
    "schedule" : {
    }


}




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
            cls.instance = super(UserConfig,cls).__new__(cls)
            cls.instance.initialized = False
        return cls.instance

    def __init__(self, parent = None):
        if(self.initialized): return

        self.initialized = True

        super().__init__(parent)

        self.config = configparser.ConfigParser()
        self.config.read('config.ini')

        #username = getenv("ITUUserName")
        #password = getenv("ITUPassword")

        self.auth_token = None
        self.request_count = 0
        self.latest_response = dict()

    @Slot(str, str, result = str)
    def getSetting(self, section, setting):
        return self.config[section][setting]

    @Slot(str, str,result = str)
    def setSetting(self, setting, newValue):
        self.config[setting] = newValue

    @Slot(result = list)
    def saveConfig(self):
        try:
            with open('config.ini', 'w') as configfile:
                self.config.write(configfile)
                return [True, "Settings are successfully saved."]
        except Exception as e:
            return [False, f"An error occurred: {e}"]


