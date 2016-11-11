#ifndef GEOPATH_H
#define GEOPATH_H

#include <QObject>
#include <QtPositioning/QGeoCoordinate>
#include <QPointF>

class GeoPath : public QObject
{
    Q_OBJECT
public:
    explicit GeoPath(QObject *parent = 0);

    Q_INVOKABLE void setMap(QObject *qmlMap);
    void setPath(const QList<QGeoCoordinate> &path);
    void setMetricPath(const QGeoCoordinate &origin, const QList<QPointF> &path);

signals:

public slots:

private:
    QObject *m_map;
};

#endif // GEOPATH_H
