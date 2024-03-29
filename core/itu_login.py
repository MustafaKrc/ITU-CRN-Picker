from selenium import webdriver
from selenium.common.exceptions import NoSuchDriverException
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

import urllib.request
from os.path import join

import sched
from time import time, sleep

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QmlElement
from PySide6.QtCore import QObject, Slot, Signal

from .user import UserConfig
from .internet_checker import InternetConnectionChecker


QML_IMPORT_NAME = "core.ItuLogin"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
class ItuLogin(QObject):
    """Handles the logging into ITU systems.

    Simulates chrome web browser to grab the authorization token.
    Grabs the username and password from UserConfig
    This class will install chrome web driver for selenium when it is necessary.
    
    Attributes:
        driver: Selenium webdriver object
        connectionChecker: InternetConnectionChecker object
        driver_restore_scheduler: scheduler object to restore the driver when it is closed
        options: Selenium webdriver options
        __service: Selenium webdriver service

    Methods:
        login: Logs into ITU system
        logout: Logs out of ITU system
        setAuthToken: Sets the authorization token in UserConfig
        refreshAuthToken: Gets a new authorization token
        isLoggedIn: Checks if user is logged in ITU system
        getLoginInfo: Gets the user's name and photo
        tryRestoreConnection: Tries to restore the connection when it is lost
        close: Closes the webdriver

    """

    def __init__(self, parent = None):
        QObject.__init__(self, parent)

        self.connectionChecker = InternetConnectionChecker()
        self.connectionChecker.startSchedule()

        self.driver_restore_scheduler = sched.scheduler(time,sleep)

        self.options = Options()
        self.options.add_argument("headless")  # makes chrome invisible
        self.options.add_argument("--log-level=3")  # hides chrome error messages.

        self.__service = ChromeService()
        try:
            self.driver = webdriver.Chrome(service=self.__service, options= self.options)
        except NoSuchDriverException:
            self.driver = None
        
        # When the GUI is closed, close the webdriver
        windowInstance = QGuiApplication.instance()
        windowInstance.aboutToQuit.connect(self.close)
    
    def __del__(self):
            self.close()
            
    def tryRestoreConnection(self):
        """Tries to restore the connection when it is lost"""
        try:
            self.driver = webdriver.Chrome(service=self.__service, options= self.options)
        except NoSuchDriverException:
            self.driver = None
            self.driver_restore_scheduler.enter(5, 1, self.tryRestoreConnection, ())
            self.driver_restore_scheduler.run()

    
    @Slot()
    def close(self):
        """Closes the webdriver"""

        if self.driver is not None:
            self.driver.quit()  
            self.driver = None

    @Slot(str, str, result = list)
    def login(self, user_name, password):
        """Logs into ITU system"""
        
        if not self.connectionChecker.isOnline():
            return [False, "Error with internet connection"]


        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")

        user_xpath = '//*[@id="ContentPlaceHolder1_tbUserName"]'
        password_xpath = '//*[@id="ContentPlaceHolder1_tbPassword"]'
        user_name_input = self.driver.find_element(By.XPATH, user_xpath)
        password_input = self.driver.find_element(By.XPATH, password_xpath)

        user_name_input.send_keys(user_name)
        password_input.send_keys(password)

        self.driver.find_element(By.XPATH, '//*[@id="ContentPlaceHolder1_btnLogin"]').click()

        if(self.isLoggedIn()):
            self.setAuthToken()
            
            UserConfig().last_username = user_name
            UserConfig().last_password = password
            if UserConfig().rememberMe:
                UserConfig().setUsername(UserConfig().last_username)
                UserConfig().setPassword(UserConfig().last_password)

            self.getLoginInfo()
            return [True, "Successfully logged in!"]
        
        return [False, "Wrong username or password!"]
    
    @Slot(result = list)
    def logout(self):
        """Logs out of ITU system"""

        if not self.connectionChecker.isOnline():
            return [False, "Error with internet connection"]
        
        self.driver.get("https://girisv3.itu.edu.tr/Logout.aspx")
        
        if not self.isLoggedIn():
            UserConfig().auth_token = None
            return [True, "Successfully logged out!"]
        
        return [False, "Could not log out!"]
            

    def setAuthToken(self):
        """Gets new authorization token and sets it in UserConfig"""

        if not self.connectionChecker.isOnline():
            return
        
        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci/auth/jwt")

        element = self.driver.find_element(By.TAG_NAME, "body")
        token = "Bearer " + element.text

        UserConfig().auth_token = token

    @Slot()
    def refreshAuthToken(self):
        """Gets a new authorization token.

        Calls another method to grab the authorization token from website."""
        if not self.connectionChecker.isOnline():
            return
        
        if not self.isLoggedIn():
            return

        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")
        self.setAuthToken()

    @Slot(result = bool)
    def isLoggedIn(self):
        """Checks if user is logged in ITU system"""

        if not self.connectionChecker.isOnline():
            return False
        
        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")
        return self.driver.title == "Öğrenci Bilgi Sistemi"
    
    def getLoginInfo(self):
        """Gets the user's name and photo"""

        if not self.connectionChecker.isOnline():
            return

        try:
            # Find the img element with class 'media-object' and a title attribute
            self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci/")
            img_element = WebDriverWait(self.driver, 5).until(
                                        EC.visibility_of_element_located((By.CSS_SELECTOR, 'img.media-object[title]')))
            
            # Get the source (src) and title attributes of the img element
            img_src = img_element.get_attribute("src")
            img_info = img_element.get_attribute("title")

            UserConfig().setFullName(img_info)

            fullfilename = "user_photo.png"
            urllib.request.urlretrieve(img_src, fullfilename)


        except Exception as e:
            print("Element not found:", str(e))
