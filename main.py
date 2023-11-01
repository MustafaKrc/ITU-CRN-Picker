# This Python file uses the following encoding: utf-8
import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, qmlRegisterType

#from core.itu_login import ItuLogin

from core.user import UserConfig, UserSchedules
from core.itu_login import ItuLogin
from core.crn_picker import CrnPicker
from core.internet_checker import InternetConnectionChecker
from core.schedule_list_model import ScheduleListModel


if __name__ == "__main__":
    app = QGuiApplication(sys.argv)

    engine = QQmlApplicationEngine()

    userSchedulesModel = ScheduleListModel()
    engine.rootContext().setContextProperty("userSchedulesModel", userSchedulesModel)


    #qmlRegisterType(ItuLogin, 'ItuLogin', 1, 0, 'ItuLogin')

    #engine.rootContext().setContextProperty("ItuLogin", ItuLogin())

    qml_file = Path(__file__).resolve().parent / "ui/qml/main.qml"
    engine.load(qml_file)
    if not engine.rootObjects():
        sys.exit(-1)
    sys.exit(app.exec())
