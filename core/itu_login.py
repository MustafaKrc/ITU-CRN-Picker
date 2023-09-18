from selenium import webdriver
from selenium.webdriver.common.by import By
from selenium.webdriver.chrome.service import Service as ChromeService
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC

import urllib.request
from os.path import join

from PySide6.QtQml import QmlElement
from PySide6.QtCore import QObject, Slot, Signal

from .user import UserConfig

QML_IMPORT_NAME = "core.ItuLogin"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
class ItuLogin(QObject):
    """Handles the logging into ITU systems.

    Simulates chrome web browser to grab the authorization token.

    Grabs the username and password from UserConfig

    This class will install chrome web driver for selenium when it is necessary."""

    def __init__(self, parent = None):
        QObject.__init__(self, parent)


        options = Options()
        options.add_argument("headless")  # makes chrome invisible
        options.add_argument("--log-level=3")  # hides chrome error messages.

        self.__service = ChromeService()
        self.driver = webdriver.Chrome(service=self.__service, options=options)

    
    @Slot()
    def close(self):
        self.driver.quit()

    @Slot(str, str, result = list)
    def login(self, user_name, password):
        """Logs into ITU system.

        After logging, calls another method to grab the authorization token from responses."""

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
        
        self.driver.get("https://girisv3.itu.edu.tr/Logout.aspx")
        
        if not self.isLoggedIn():
            UserConfig().auth_token = None
            return [True, "Successfully logged out!"]
        
        return [False, "Could not log out!"]
            

    def setAuthToken(self):
        """Grabs the authorization token from the given requests

        Also sets the authorization token in UserConfig"""
        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci/auth/jwt")

        element = self.driver.find_element(By.TAG_NAME, "body")
        token = "Bearer " + element.text

        UserConfig().auth_token = token

    @Slot()
    def refreshAuthToken(self):
        """Gets a new authorization token.

        Calls another method to grab the authorization token from responses."""
        if not self.isLoggedIn():
            return

        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")
        self.setAuthToken()

    @Slot(result = bool)
    def isLoggedIn(self):
        """Checks if user is logged in ITU system"""
        self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci")
        return self.driver.title == "Öğrenci Bilgi Sistemi"
    
    def getLoginInfo(self):

        try:
            # Find the img element with class 'media-object' and a title attribute
            self.driver.get("https://kepler-beta.itu.edu.tr/ogrenci/")
            img_element = WebDriverWait(self.driver, 5).until(
                                        EC.visibility_of_element_located((By.CSS_SELECTOR, 'img.media-object[title]')))
            
            # Get the source (src) and title attributes of the img element
            img_src = img_element.get_attribute("src")
            img_info = img_element.get_attribute("title")

            UserConfig().setFullName(img_info)

            fullfilename = join("./ui/images", "user_photo.png")
            urllib.request.urlretrieve(img_src, fullfilename)

            # Print the results
            #print("Image Source:", img_src)
            #print("Image Title:", img_title)

        except Exception as e:
            print("Element not found:", str(e))
