import os
from .user import UserConfig


class Console:
    """Handless the output of the app."""

    def __init__(self):
        # self.clearScreen() #this causes random bug
        pass

    def clearScreen(self):
        """Clears the screen of console

        Do not use this or otherwise unknown traceback erros will occur!
        """
        # os.system("cls" if os.name == "nt" else "clear")
        pass

    def updateScreen(self):
        """Prints the latest information about the app. These are:
        - How many times post request was send.
        - Current status of post requests."""
        print(2 * "\n")
        print(
            f"App is currently running, made {UserConfig.request_count} post requests so far!"
        )
        self.printCrnInfo()

    def printCrnInfo(self):
        """Prints the current status of CRNs."""
        for crn in UserConfig.latest_response:
            print(
                "{crn_code}: {state} {message}".format(
                    crn_code=crn,
                    state="✅"
                    if UserConfig.latest_response[crn]["statusCode"] == "0"
                    else "❌",
                    message=UserConfig.latest_response[crn]["message"],
                ),
            )
