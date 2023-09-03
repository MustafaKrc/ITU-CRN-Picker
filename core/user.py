from datetime import datetime
import configparser
import json
from dataclasses import dataclass


from PySide6.QtQml import QmlElement
from PySide6.QtCore import QObject, Slot, Signal


@dataclass
class Schedule:

    def __init__(self,name = "Schedule", ECRN = [], SCRN = []):
        self.name = name
        self.ECRN = ECRN
        self.SCRN = SCRN

class UserSchedules:

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(UserSchedules,cls).__new__(cls)
            cls.instance.initialized = False
        return cls.instance


    def __init__(self):
        if(self.initialized): return
        self.initialized = True
        self.schedules = []

        try:
            # Open the JSON file for reading
            with open("schedules.json", 'r') as file:
                # Parse the JSON data
                _json_file = json.load(file)
        except FileNotFoundError:
            print("File not found: schedules.json")
        except json.JSONDecodeError as e:
            print(f"Error decoding JSON: {e}")
        except Exception as e:
            print(f"An error occurred: {e}")

        for x in _json_file:
            self.schedules.append(Schedule(name = x,
                                        ECRN = _json_file[x]['ECRN'],
                                        SCRN = _json_file[x]['SCRN']))

    def getName(self,index):
        return self.schedules[index].name

    def getECRNList(self, index):
        return self.schedules[index].ECRN

    def getSCRNList(self, index):
        return self.schedules[index].SCRN

    def __len__(self):
        return len(self.schedules)




class UserConfig(QObject):
    """Class for user settings and information.

    Grabs all the information from .env file

    Other classes can grab/write information."""

    def __new__(cls):
        if not hasattr(cls, 'instance'):
            cls.instance = super(UserConfig,cls).__new__(cls)
            cls.instance.initialized = False
        return cls.instance

    def __init__(self):
        if(self.initialized): return
        self.initialized = True
        self.schedules = []

        config = configparser.ConfigParser()
        config.read('../config.ini')



        #username = getenv("ITUUserName")
        #password = getenv("ITUPassword")

        #__starting_date_str = getenv("StartingDate")
        #starting_date = datetime.strptime(__starting_date_str, "%d.%m.%Y %H:%M:%S")

        #__ending_date_str = getenv("EndingDate")
        #ending_date = datetime.strptime(__ending_date_str, "%d.%m.%Y %H:%M:%S")

        #request_frequency = float(getenv("Frequency"))
        #equest_frequency = max(1.1, request_frequency)

        #max_post_request = float(getenv("MaxPostRequest"))
        #max_post_request = float("inf") if max_post_request == -1 else max_post_request

        #ECRN = list(map(str.strip, getenv("ECRN").split(",")))
        #SCRN = list(map(str.strip, getenv("SCRN").split(",")))

        #ECRN = [] if ECRN[0] == "" else ECRN
        #SCRN = [] if SCRN[0] == "" else SCRN



        # currentScheduleIndex

        auth_token = None

        request_count = 0

        refreshTokenFrequency = 60 * 60  # 1 hour

        screen_update_frequency = 15

        latest_response = dict()

    def getSetting(self, setting: str):
        return self.config[setting]

    def getSchedule(self, scheduleName: str):
        return self.schedules
