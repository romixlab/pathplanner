#include "geopath.h"

#include <math.h>

#include <QDebug>

GeoPath::GeoPath(QObject *parent) : m_map(0), QObject(parent)
{

}

void GeoPath::setMap(QObject *qmlMap)
{
    m_map = qmlMap;
    QVariant t = QVariant::fromValue<QObject *>(this);
    QMetaObject::invokeMethod(m_map, "addPolyline", Q_ARG(QVariant, t));
}

void GeoPath::setPath(const QList<QGeoCoordinate> &path)
{
    QVariantList numbers;
    foreach(const QGeoCoordinate &c, path) {
        numbers.append(c.latitude());
        numbers.append(c.longitude());
    }
    QVariant t = QVariant::fromValue<QObject *>(this);
    QMetaObject::invokeMethod(m_map, "modifyPolyline",
                              Q_ARG(QVariant, t),
                              Q_ARG(QVariant, numbers),
                              Q_ARG(QVariant, "red"),
                              Q_ARG(QVariant, 1));
}

void GeoPath::setMetricPath(const QGeoCoordinate &origin, const QList<QPointF> &path)
{
    double arc = 111323.872; // m per degree
    QVariantList numbers;
    foreach(const QPointF &pt, path) {
        double dphi = pt.y() / arc;
        double dlambda = pt.x() / (arc * cos(origin.latitude() / 360.0 * 2 * M_PI));
        numbers << origin.latitude() + dphi
                << origin.longitude() + dlambda;
    }

    QVariant t = QVariant::fromValue<QObject *>(this);
    QMetaObject::invokeMethod(m_map, "modifyPolyline",
                              Q_ARG(QVariant, t),
                              Q_ARG(QVariant, numbers),
                              Q_ARG(QVariant, "red"),
                              Q_ARG(QVariant, 1));
}
