# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication, QIcon
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType

#from core.itu_login import ItuLogin

from core.user import UserConfig, UserSchedules
from core.itu_login import ItuLogin
from core.crn_picker import CrnPicker
from core.internet_checker import InternetConnectionChecker
from core.schedule_list_model import ScheduleListModel
from core.utils import RootPathProvider

from os.path import abspath, join


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()

    userSchedulesModel = ScheduleListModel()
    engine.rootContext().setContextProperty("userSchedulesModel", userSchedulesModel)


    # Get the path to the temporary folder created by PyInstaller
    if getattr(sys, 'frozen', False) and hasattr(sys, '_MEIPASS'):
        # PyInstaller bundles files, use the temporary folder
        base_path = sys._MEIPASS
    else:
        # Use the regular file path
        base_path = abspath(".")

    # Set the application icon
    icon_path = join(base_path, 'ui', 'images', 'icon.png')
    app_icon = QIcon(icon_path)
    app.setWindowIcon(app_icon)

    #qmlRegisterType(ItuLogin, 'ItuLogin', 1, 0, 'ItuLogin')

    #engine.rootContext().setContextProperty("ItuLogin", ItuLogin())
    rootPathProvider = RootPathProvider()
    engine.rootContext().setContextProperty("rootPathProvider", rootPathProvider)   

    qml_file = Path(__file__).resolve().parent / "ui/qml/main.qml"
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
