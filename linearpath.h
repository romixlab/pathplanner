#ifndef LINEARPATH_H
#define LINEARPATH_H

#include "geopath.h"

#include <QObject>

class LinearPathPrivate;
class LinearPath : public GeoPath
{
    Q_OBJECT

public:
    explicit LinearPath(QObject *parent = 0);

    float instrumentWidth() const;
    void setInstrumentWidth(float width);

    void minimumTurnRadius() const;
    void setMinimumTurnRadius(float minimumTurnRadius);

    float rotation() const;
    void setRotation(float rotation);

    QPointF rotationPoint() const;
    void setRotationPoint(QPointF rotationPoint);

    float width() const;
    void setWidth(float width);

    float height() const;
    void setHeight(float height);

    void generate();

signals:

public slots:

private:
    Q_DECLARE_PRIVATE(LinearPath)
};

#endif // LINEARPATH_H
