import requests
import time
import sched
import threading
from PySide6.QtQml import QmlElement, QmlSingleton
from PySide6.QtCore import QObject, Slot, Signal, Property

QML_IMPORT_NAME = "core.InternetChecker"
QML_IMPORT_MAJOR_VERSION = 1
QML_IMPORT_MINOR_VERSION = 0

@QmlElement
@QmlSingleton
class InternetConnectionChecker(QObject):
    def __init__(self, parent=None):
        super().__init__(parent)

        self._hasInternetConnection = True
        self.interval = 5  # Check every 5 seconds
        self.s = sched.scheduler(time.time, time.sleep)
        self.check_thread = None

    def check_internet_connection(self):
        try:
            response = requests.get("https://www.google.com", timeout=5)
            if response.status_code == 200:
                self.setHasInternetConnection(True)
            else:
                self.setHasInternetConnection(False)
        except requests.ConnectionError:
            self.setHasInternetConnection(False)

        self.s.enter(self.interval, 1, self.check_internet_connection)
        self.s.run()
        

    @Slot()
    def startSchedule(self):
        if self.check_thread is None or not self.check_thread.is_alive():
            self.check_thread = threading.Thread(target=self.check_internet_connection)
            self.check_thread.daemon = True  # Thread will exit when the main program exits
            self.check_thread.start()
            
    def isOnline(self):
        return self._hasInternetConnection

    # hasInternetConnection qml property

    def getHasInternetConnection(self):
        return self._hasInternetConnection

    def setHasInternetConnection(self, value):
        if self._hasInternetConnection == value:
            return

        self._hasInternetConnection = value
        self.hasInternetConnectionChanged.emit()

    @Signal
    def hasInternetConnectionChanged(self):
        pass

    hasInternetConnection = Property(bool, getHasInternetConnection,
                                      setHasInternetConnection, notify=hasInternetConnectionChanged)
