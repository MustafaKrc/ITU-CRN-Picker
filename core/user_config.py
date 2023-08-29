from dotenv import load_dotenv
from os.path import join, dirname
from os import getenv
from datetime import datetime


class UserConfig:
    """Class for user settings and information.

    Grabs all the information from .env file

    Other classes can grab/write information."""

    dotenv_path = join(dirname(dirname(__file__)), ".env")
    load_dotenv(dotenv_path)

    username = getenv("ITUUserName")
    password = getenv("ITUPassword")

    __starting_date_str = getenv("StartingDate")
    starting_date = datetime.strptime(__starting_date_str, "%d.%m.%Y %H:%M:%S")

    __ending_date_str = getenv("EndingDate")
    ending_date = datetime.strptime(__ending_date_str, "%d.%m.%Y %H:%M:%S")

    request_frequency = float(getenv("Frequency"))
    request_frequency = max(1.1, request_frequency)

    max_post_request = float(getenv("MaxPostRequest"))
    max_post_request = float("inf") if max_post_request == -1 else max_post_request

    ECRN = list(map(str.strip, getenv("ECRN").split(",")))
    SCRN = list(map(str.strip, getenv("SCRN").split(",")))

    ECRN = [] if ECRN[0] == "" else ECRN
    SCRN = [] if SCRN[0] == "" else SCRN

    auth_token = None

    request_count = 0

    refreshTokenFrequency = 60 * 60  # 1 hour

    screen_update_frequency = 15

    latest_response = dict()
