from seleniumwire import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service as ChromeService
from webdriver_manager.chrome import ChromeDriverManager
from .user_config import UserConfig


class ItuLogin:
    """Handles the logging into ITU systems.

    Simulates chrome web browser to grab the authorization token.

    Grabs the username and password from UserConfig

    This class will install chrome web driver for selenium when it is necessary."""

    def __init__(self):
        self.username = UserConfig.username
        self.password = UserConfig.password

        options = webdriver.ChromeOptions()
        options.add_argument("headless")  # makes chrome invisible
        options.add_argument("--log-level=3")  # hides chrome error messages.

        self.__service = ChromeService(executable_path=ChromeDriverManager().install())
        self.driver = webdriver.Chrome(service=self.__service, chrome_options=options)

    def login(self):
        """Logs into ITU system.

        After logging, calls another method to grab the authorization token from responses."""

        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")

        user_xpath = '//*[@id="ContentPlaceHolder1_tbUserName"]'
        password_xpath = '//*[@id="ContentPlaceHolder1_tbPassword"]'
        user = self.driver.find_element(By.XPATH, user_xpath)
        password = self.driver.find_element(By.XPATH, password_xpath)

        user.send_keys(self.username)
        password.send_keys(self.password)

        self.driver.find_element(
            By.XPATH, '//*[@id="ContentPlaceHolder1_btnLogin"]'
        ).click()
        self.setAuthToken(self.driver.requests)

    def setAuthToken(
        self, driver_requests
    ):  # driver_requests: list[webdriver.Chrome.requests]
        """Grabs the authorization token from the given requests

        Also sets the authorization token in UserConfig"""
        for request in driver_requests:
            if request.response and request.headers.get("authorization"):
                auth_token = request.headers["authorization"]
                if len(auth_token) > 32:  # some auth tokens are empty
                    UserConfig.auth_token = auth_token
                    break

    def getNewAuthToken(self):
        """Gets a new authorization token.

        Calls another method to grab the authorization token from responses."""
        if not self.isLoggedIn():
            self.login()

        # deleting previous request responses to grab the latest responses
        del self.driver.requests

        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")
        self.setAuthToken(self.driver.requests)

    def isLoggedIn(self):
        """Checks if user is logged in ITU system"""
        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")
        return self.driver.title == "Öğrenci Bilgi Sistemi"
