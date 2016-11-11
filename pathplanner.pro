TEMPLATE = app

QT += qml quickcontrols2 positioning
CONFIG += c++11

SOURCES += main.cpp \
    linearpath.cpp \
    geopath.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)

HEADERS += \
    linearpath.h \
    geopath.h
