"Entry point for ITU CRN Picking app"

from .user import UserConfig
from .crn_picker import CrnPicker
from .itu_login import ItuLogin
from .console import Console

import sched
from time import sleep
from datetime import datetime, timedelta
from sys import exit


class App:
    """This is the main class for the app.

    Initializing this will automatically get your information from .env file.

    run() method must be called in order to start the program cycle."""

    def __init__(self):
        self.logger = ItuLogin()
        self.crn_picker = CrnPicker()
        self.console = Console()
        self.scheduler = sched.scheduler(datetime.now, self.__sleepApp)
        self.max_allowed_requests = UserConfig.max_post_request

    def startSendingRequests(self):
        """Starts the periodic task of sending requests."""
        self.periodicTask(
            timedelta(seconds=UserConfig.request_frequency),
            1,
            self.crn_picker.sendRequest,
        )

    def closeApp(self, message=""):
        """Closes the app and prints the given prompt, also shows the operation summary."""
        print("\n")
        print("{} Closing the app!".format(message))
        print("Operation history is as down below.")
        self.console.printCrnInfo()
        exit(0)

    def __sleepApp(self, delay: timedelta):
        sleep(0) if delay == 0 else sleep(delay.total_seconds())

    def isTasksCompleted(self):
        """Returns True if no crn operation left for the post request."""
        return len(UserConfig.ECRN) + len(UserConfig.SCRN) == 0

    def isMaxRequestCountFullfilled(self):
        """Returns true if maximum allowed post request is reached."""
        return UserConfig.request_count >= UserConfig.max_post_request

    def periodicTask(self, interval, priority, action):
        """This executes the given action after {interval} seconds. Also schedules itself to {interval} seconds later.

        This will create a recursion that happens every {interval} seconds"""
        if self.isMaxRequestCountFullfilled():
            self.scheduler.enter(
                timedelta(seconds=0),
                1,
                self.closeApp,
                (),
                {"message": "Max post request count is fullfilled."},
            )
        if self.isTasksCompleted():
            self.scheduler.enter(
                timedelta(seconds=0),
                1,
                self.closeApp,
                (),
                {"message": "All CRN operations are successfully done."},
            )

        self.scheduler.enter(
            interval, 1, self.periodicTask, (interval, priority, action)
        )
        self.scheduler.enter(interval, priority, action)

    def run(self):
        """Logs into account grabbed from .env

        Sets schedules according to UserConfig

        Starts the app."""

        self.logger.login()
        if not self.logger.isLoggedIn():
            print()
            print("Wrong passowrd or username")
            self.closeApp()

        self.scheduler.enterabs(UserConfig.starting_date, 1, self.startSendingRequests)

        self.periodicTask(
            timedelta(seconds=UserConfig.refreshTokenFrequency),
            2,
            self.logger.getNewAuthToken,
        )

        self.periodicTask(
            timedelta(seconds=UserConfig.screen_update_frequency),
            3,
            self.console.updateScreen,
        )

        self.scheduler.enterabs(
            UserConfig.ending_date,
            4,
            self.closeApp,
            (),
            {"message": "Ending date is reached."},
        )

        self.scheduler.run()
