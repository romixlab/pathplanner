#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QSettings>
#include <QQuickStyle>
#include <QQmlContext>

#include "geopath.h"
#include "linearpath.h"

int main(int argc, char *argv[])
{
    QGuiApplication::setApplicationName("PathPlanner");
    QGuiApplication::setOrganizationName("MarsWorks");
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    QSettings settings;
    QString style = QQuickStyle::name();
    if (!style.isEmpty())
        settings.setValue("style", style);
    else
        QQuickStyle::setStyle(settings.value("style").toString());

    QQmlApplicationEngine engine;
    engine.load(QUrl("qrc:/main.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    //GeoPath p;
//    p.setMap(engine.rootObjects()[0]->findChild<QObject *>("qmlMap"));

//    QList<QGeoCoordinate> l;
//    l << QGeoCoordinate(55.74795553273474, 37.860303680900216)
//      << QGeoCoordinate(55.748722422094595, 37.86068991899836)
//      << QGeoCoordinate(55.751148237045754, 37.863859217170386);
//    p.setPath(l);

//    QList<QPointF> l;
//    l << QPointF(0, 0) << QPointF(100, 0) << QPointF(100, 100);
//    p.setMetricPath(QGeoCoordinate(55.74650626688504, 37.86000174612559), l);
    LinearPath p;
    p.setMap(engine.rootObjects()[0]->findChild<QObject *>("qmlMap"));
    p.generate();

    return app.exec();
}
