import QtQuick 2.5

/**
  * Can't create RingButton with large phi, because there is no easy way to propagate mouse hover events
  */
Canvas {
    id: canvas

    signal clicked

    property int ringRadius: 100
    property int ringThickness: 20
    property int margin: 3
    property int thickness: 20
    property real phi: Math.PI / 6

    property int _radius: ringRadius + ringThickness / 2 + margin + thickness / 2
    property int _minx: (_radius - thickness / 2) * Math.cos(phi / 2)
    property int _maxy: (_radius + thickness / 2) * Math.sin(phi / 2)
    width: _radius + thickness / 2 - _minx
    height: 2 * _maxy
    baselineOffset: _maxy

    x: _minx + ringRadius + ringThickness / 2

    property color color: "#ddd"
    property color hoverColor: "#ccc"
    property bool _hovering: false
    on_HoveringChanged: canvas.requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.save()

        ctx.beginPath()
        ctx.clearRect(0, 0, canvas.width, canvas.height)
        ctx.translate(-canvas._minx, canvas._maxy)
        ctx.arc(0, 0, canvas._radius, -canvas.phi / 2, canvas.phi / 2, false)
        ctx.lineWidth = canvas.thickness
        ctx.strokeStyle = canvas._hovering ? canvas.hoverColor : canvas.color

        ctx.globalAlpha = 0.7
        ctx.stroke()

        ctx.restore()
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true

        onClicked:
                canvas.clicked()

        onEntered: canvas._hovering = true
        onExited: canvas._hovering = false
    }
}
