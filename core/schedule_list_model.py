# This Python file uses the following encoding: utf-8

from PySide6.QtCore import QAbstractListModel, Slot, Signal, Qt
from .user import UserSchedules


class ScheduleListModel(QAbstractListModel):
    NameRole = Qt.UserRole + 1
    ECRNRole = Qt.UserRole + 2
    SCRNRole = Qt.UserRole + 3

    _roles = {NameRole: b"scheduleName", ECRNRole: b"ECRN", SCRNRole: b"SCRN"}

    def __init__(self):
        super(ScheduleListModel, self).__init__()
        self._schedules = UserSchedules()

    def rowCount(self, parent=None, *args, **kwargs):
        return len(self._schedules)

    def data(self, QModelIndex, role=None):
        row = QModelIndex.row()

        if not QModelIndex.isValid() or row >= len(self._schedules):
            return None

        if role == self.NameRole:
            return self._schedules.getName(row)
        if role == self.ECRNRole:
            return self._schedules.getECRNList(row)
        if role == self.SCRNRole:
            return self._schedules.getSCRNList(row)

    def roleNames(self):
        return self._roles
