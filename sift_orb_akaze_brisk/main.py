import os
import sys
import style_rc

from pathlib import Path
from find_obj import compare
from urllib.parse import unquote, urlparse

from PySide6.QtCore import QObject, Slot, Signal
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QmlElement
from PySide6.QtQuickControls2 import QQuickStyle

# To be used on the @QmlElement decorator
# (QML_IMPORT_MINOR_VERSION is optional)
QML_IMPORT_NAME = "io.qt.textproperties"
QML_IMPORT_MAJOR_VERSION = 1


@QmlElement
class Bridge(QObject):

    @Slot(str)
    def setDetector(self, d):
        self.detector = d.lower()

    @Slot(str, str)
    def compareImages(self, firstImageUrl, secondImageUrl):
        firstImagePath = unquote(urlparse(firstImageUrl).path)
        secondImagePath = unquote(urlparse(secondImageUrl).path)
        self.showResult.emit(firstImagePath, secondImagePath,
                             compare(self.detector, firstImagePath, secondImagePath))

    detector = "sift"
    showResult = Signal(str, str, list)


if __name__ == '__main__':
    app = QGuiApplication(sys.argv)
    QQuickStyle.setStyle("Material")
    engine = QQmlApplicationEngine()

    # Get the path of the current directory, and then add the name
    # of the QML file, to load it.
    qml_file = Path(__file__).parent / "ui/view.qml"
    engine.load(qml_file)

    if not engine.rootObjects():
        sys.exit(-1)

    sys.exit(app.exec())