from pathlib import Path
from PySide6.QtCore import QObject, Slot

import os

class RootPathProvider(QObject):
    @Slot(result=str)
    def getRootPath(self):
        return Path(os.getcwd()).as_uri()