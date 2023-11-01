import configparser
import json
from dotenv import load_dotenv, set_key
from os.path import join, dirname
from os import getenv
from dataclasses import dataclass

from PySide6.QtQml import QmlElement, QmlSingleton
from PySide6.QtCore import QObject, Slot, Signal, Property


@dataclass
class Schedule:
    """Dataclass for schedules."""

    def __init__(self, name="Schedule", ECRN=[], SCRN=[]):
        self.name = name
        self.ECRN = ECRN
        self.SCRN = SCRN

    @staticmethod
    def isValidCRNList(crnList):
        """Checks if the given CRN list is valid or not."""
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
    """Class for user schedules.
    
    All the schedules are stored in a JSON file.
    
    Attributes:
        schedules: list of Schedule objects

    Methods:
        getIndex: Returns the index of the schedule with the given name
        getName: Returns the name of the schedule with the given index
        getECRNList: Returns the ECRN list of the schedule with the given index
        getSCRNList: Returns the SCRN list of the schedule with the given index
        addSchedule: Adds a new schedule
        editSchedule: Edits the schedule with the given index
        deleteSchedule: Deletes the schedule with the given index
        saveSchedules: Saves the schedules to the JSON file
    
    """

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
            json_file = {}
            with open("schedules.json", 'w') as file:
                json.dump(json_file, file)
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
        """Adds a new schedule."""

        if name == "":
            return [False, "Schedule must have a name"]

        for schedule in self.schedules:
            if name == schedule.name:
                return [False, "There exists another schedule with the same name"]
            
        if not Schedule.isValidCRNList(ECRNList):
            return [False, "There is an error with picked CRN list"]

        if not Schedule.isValidCRNList(SCRNList):
            return [False, "There is an error with dropped CRN list"]

        self.schedules.append(Schedule(name, ECRNList, SCRNList))
        self.saveSchedules()
        return [True, "Schedule is successfully added"]

    @Slot(int, str, list, list, result=list)
    def editSchedule(self, scheduleIndex, newName, newECRNList, newSCRNList):
        """Edits the schedule with the given index."""

        currentSchedule = self.schedules[scheduleIndex]

        if newName == "":
            return [False, "Schedule must have a name"]

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
        """Deletes the schedule with the given index."""

        self.schedules.pop(scheduleIndex)
        self.saveSchedules()
        return [True, "Schedule is successfully removed."]

    def saveSchedules(self):
        """Saves the schedules to the JSON file."""

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
    """Class for user config.
    
    All the settings are stored in a INI file.
    
    Attributes:
        _username: ITU username
        _password: ITU password
        last_username: last ITU username (used for remember me and keep me signed in)
        last_password: last ITU password (used for remember me and keep me signed in)
        full_name: full name of the user
        auth_token: authorization token
        request_count: number of requests made
        latest_response: latest response from the server
        _rememberMe: True if remember me is checked, False otherwise
        _keepMeSignedIn: True if keep me signed in is checked, False otherwise
        _requestInterval: interval between the requests
        _maxRequestCount: maximum number of requests
        _token_refresh_interval: interval between the token refreshes
        _version: version of the application
        _currentSchedule: name of the current schedule
        
        Methods:
        create_default_config: Creates the default configuration file
        
        """

    DEFAULT_CONFIG = {
        "login": {
            "remember_me": "True",
            "keep_me_signed_in": "False"
        },
        "request": {
            "request_interval": "5",
            "max_request_count": "-1",
            "request_starting_date": "None",
            "request_ending_date": "None"
        },
        "token": {
            "token_refresh_interval": "3600"
        },
        "schedule": {
            "current_schedule": ""
        },
        "about": {
            "version": "0.1"
        }
    }


    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(UserConfig, cls).__new__(cls)
            cls.instance.initialized = False
        return cls.instance

    def __init__(self, parent=None):
        if (self.initialized):
            return

        self.initialized = True
        self.dotenv_path = join(dirname(dirname(__file__)), ".env")
        super().__init__(parent)

        try: 
            self.config = configparser.ConfigParser()
            with open('config.ini') as f:
                self.config.read_file(f)
            
        except FileNotFoundError:
            # If the file doesn't exist, create it with default values
            self.create_default_config()
        except Exception as e:
            print(f"An error occured: {e}")

        
        try:
            load_dotenv(self.dotenv_path)
            # doesnt matter if file doesnt exists. 
            # default value is empty string
        except Exception as e:
            print(f"An error occured: {e}")

        self._username = getenv("ITUusername")
        self._password = getenv("ITUpassword")

        self._username = self._username if self._username != "" else None
        self._password = self._password if self._password != "" else None
        
        self.last_username = self._username
        self.last_password = self._password

        self.full_name = ""

        self.auth_token = None
        self.request_count = 0


        self.latest_response = dict()

        self._rememberMe = self.config["login"]["remember_me"].lower() == "true"
        self._keepMeSignedIn = self.config["login"]["keep_me_signed_in"].lower() == "true"
        self._requestInterval = float(self.config["request"]["request_interval"])
        self._maxRequestCount = int(self.config["request"]["max_request_count"])
        self._token_refresh_interval = int(self.config["token"]["token_refresh_interval"])
        self._version = self.DEFAULT_CONFIG["about"]["version"] # version is present in default config
        self.config["about"]["version"] = self._version # set version to default value
        self._currentSchedule = self.config["schedule"]["current_schedule"]

    def create_default_config(self):
        """Creates the default configuration file if .ini file doesn't exist.

        The default configuration is stored in DEFAULT_CONFIG attribute.
        """

        self.config = configparser.ConfigParser()
        for section, options in self.DEFAULT_CONFIG.items():
            self.config.add_section(section)
            for option, value in options.items():
                self.config.set(section, option, value)

        # Save the default configuration to the file
        try:
            with open('config.ini', 'w') as configfile:
                self.config.write(configfile)
                self.configChanged.emit()
        except Exception as e:
            print(f"An error occurred: {e}")

    @Slot(str, str, result=str)
    def getSetting(self, section, setting):
        """Returns the value of the given setting in the given section."""

        # this function will not provide binding in qml
        return self.config[section][setting]

    def saveConfig(self):
        """Saves the configuration to the file."""
        
        try:
            with open('config.ini', 'w') as configfile:
                self.config.write(configfile)
                self.configChanged.emit()
        except Exception as e:
            return [False, f"An error occurred: {e}"]

        return [True, "Settings are successfully saved."]
    
    # fullName qml property

    def getFullName(self):
        return self.full_name
    
    def setFullName(self, value):
        self.full_name = value
        self.fullNameChanged.emit()

    @Signal
    def fullNameChanged(self):
        pass
    
    fullName = Property(str, getFullName, 
                        setFullName, notify=fullNameChanged)
    
    # username qml property

    def getUsername(self):
        return self._username

    def setUsername(self, value):
        self._username = value
        set_key(self.dotenv_path,"ITUusername",value)
        self.usernameChanged.emit()

    @Signal
    def usernameChanged(self):
        pass

    username = Property(str, getUsername,
                          setUsername, notify=usernameChanged)

    # password qml property

    def getPassword(self):
        return self._password

    def setPassword(self, value):
        self._password = value
        set_key(self.dotenv_path,"ITUpassword",value)
        self.passwordChanged.emit()

    @Signal
    def passwordChanged(self):
        pass

    password = Property(str, getPassword,
                          setPassword, notify=passwordChanged)

    # latestResponse qml property

    def getLatestResponse(self):
        return self.latest_response

    def setLatestResponse(self, value):
        self.latest_response = value
        self.latestResponseChanged.emit()

    @Signal
    def latestResponseChanged(self):
        pass

    latestResponse = Property(dict, getLatestResponse,
                          setLatestResponse, notify=latestResponseChanged)
        
    # currentSchedule qml property
    
    def getCurrentSchedule(self):
        return self._currentSchedule

    def setCurrentSchedule(self, value):
        self._currentSchedule = value
        self.config["schedule"]["current_schedule"] = str(value)
        self.currentScheduleChanged.emit()
        self.saveConfig()

    @Signal
    def currentScheduleChanged(self):
        pass

    currentSchedule = Property(str, getCurrentSchedule,
                          setCurrentSchedule, notify=currentScheduleChanged)
    
    # version qml property

    def getVersion(self):
        return self._version
    
    version = Property(str, getVersion,constant=True)
    
    # rememberMe qml property

    def getRememberMe(self):
        return self._rememberMe

    def setRememberMe(self, value):
        self._rememberMe = value
        if value:
            if self.last_username is not None and self.last_password is not None:
                self.setUsername(self.last_username)
                self.setPassword(self.last_password)
        if not value:
            self.setUsername("")
            self.setPassword("")
            self.setKeepMeSignedIn(False)
        self.config["login"]["remember_me"] = str(value)
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
        if value:
            self.setRememberMe(True)
        self.config["login"]["keep_me_signed_in"] = str(value)
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
        self.config["request"]["request_interval"] = str(value)
        self.requestIntervalChanged.emit()
        self.saveConfig()

    @Signal
    def requestIntervalChanged(self):
        pass

    requestInterval = Property(float, getRequestInterval,
                              setRequestInterval, notify=requestIntervalChanged)
    
    # maxRequestCount qml property
    
    def getMaxRequestCount(self):
        return self._maxRequestCount

    def setMaxRequestCount(self, value):
        self._maxRequestCount = value
        self.config["request"]["max_request_count"] = str(value)
        self.maxRequestCountChanged.emit()
        self.saveConfig()
        
    @Signal
    def maxRequestCountChanged(self):
        pass

    maxRequestCount = Property(int, getMaxRequestCount,
                              setMaxRequestCount, notify=maxRequestCountChanged)

    # requestCount qml property
    
    def getRequestCount(self):
        return self.request_count

    def setRequestCount(self, value):
        self.request_count = value
        self.requestCountChanged.emit()
        
    @Signal
    def requestCountChanged(self):
        pass

    requestCount = Property(int, getRequestCount,
                              setRequestCount, notify=requestCountChanged)
    
    # requestCount qml property
    
    def getTokenRefreshInterval(self):
        return self._token_refresh_interval

    def setTokenRefreshInterval(self, value):
        self._token_refresh_interval = value
        self.config["token"]["token_refresh_interval"] = str(value)
        self.tokenRefreshIntervalChanged.emit()
        self.saveConfig()
        
    @Signal
    def tokenRefreshIntervalChanged(self):
        pass

    tokenRefreshInterval = Property(int, getTokenRefreshInterval,
                              setTokenRefreshInterval, notify=tokenRefreshIntervalChanged)

