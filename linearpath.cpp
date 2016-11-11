#include "linearpath.h"

#include <QDebug>

class LinearPathPrivate
{
public:
    void generateTurn(QList<QPointF> &path, QPointF from, QPointF to, bool right);
};

LinearPath::LinearPath(QObject *parent) : GeoPath(parent)
{

}

void LinearPath::generate()
{
    Q_D(LinearPath);

    QList<QPointF> path;
    double width = 100;
    double height = 100;
    double instrumentWidth = 5;

    for (double y = 0; y <= height; y += 2 * instrumentWidth) {
        QPointF leftBottom(  instrumentWidth / 2,         y );
        QPointF rightBottom( width - instrumentWidth / 2, y );
        QPointF rightTop(    width - instrumentWidth / 2, y + instrumentWidth );
        QPointF leftTop(     instrumentWidth / 2,         y + instrumentWidth );

        path << leftBottom << rightBottom;
        d->generateTurn(path, rightBottom, rightTop, true);
        path << rightTop << leftTop;
    }

    setMetricPath(QGeoCoordinate(55.74650626688504, 37.86000174612559), path);
}

void LinearPathPrivate::generateTurn(QList<QPointF> &path, QPointF from, QPointF to, bool right)
{
    if (to.x() != from.x()) {
        qDebug() << "Wrong parameters passed to generateTurn()";
        return;
    }

    double radius = (to.y() - from.y()) / 2;

    for (double phi = -M_PI / 2; phi <= M_PI / 2; phi += M_PI / 20) {
        path << QPointF(from.x() + radius * cos(phi), from.y() + radius * sin(phi));
    }
}
