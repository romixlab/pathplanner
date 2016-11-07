import QtQuick 2.5

Canvas {
    id: canvas

    property real ringRotation: 0
    property real degreePerPixel: 0.5

    property int radius: 100
    property int thickness: 20
    width: radius * 2 + thickness; height: radius * 2 + thickness

    property color color: "#ddd"
    property color hoverColor: "#ccc"

    property bool hovering: false
    property bool rotating: false
    onHoveringChanged: canvas.requestPaint()
    onRotatingChanged: canvas.requestPaint()

    property bool centerButtonHovering: false
    property bool dragging: false
    onCenterButtonHoveringChanged: canvas.requestPaint()

    onPaint: {
        var ctx = getContext("2d")
        ctx.save()
        ctx.clearRect(0, 0, canvas.width, canvas.height)

        var centerX = canvas.width / 2
        var centerY = canvas.height / 2

        ctx.beginPath()
        ctx.arc(centerX, centerY, canvas.radius, 0, 2 * Math.PI, false)
        ctx.lineWidth = canvas.thickness
        ctx.strokeStyle = (canvas.hovering | canvas.rotating) ? hoverColor : color
        //ctx.globalAlpha = 0.9
        ctx.stroke()

        ctx.beginPath()
        ctx.arc(centerX, centerY, 10, 0, 2 * Math.PI, false)
        ctx.fillStyle = centerButtonHovering ? hoverColor : color
        ctx.fill()

        ctx.restore()
    }



    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true

        function isInsideOfTheRing(x, y, r1, r2) {
            var a = (x - canvas.width / 2)
            var b = (y - canvas.height / 2)
            var d = a * a + b * b;
            return d >= Math.pow(r1, 2) &&
                    d <= Math.pow(r2, 2)
        }

        property int lastX
        property int lastY

        onPositionChanged: {
            var dx = mouse.x - lastX
            var dy = mouse.y - lastY
            if (canvas.rotating) {
                var dr = dy * canvas.degreePerPixel
                canvas.ringRotation += mouse.x >= canvas.width / 2 ? dr : -dr

            }

            canvas.hovering = isInsideOfTheRing(mouse.x, mouse.y,
                                                canvas.radius - canvas.thickness / 2,
                                                canvas.radius + canvas.thickness / 2)

            canvas.centerButtonHovering = isInsideOfTheRing(mouse.x, mouse.y, 0, 10)


            lastX = mouse.x
            lastY = mouse.y
        }
        onPressed: {
            lastX = mouse.x
            lastY = mouse.y

            canvas.hovering = isInsideOfTheRing(mouse.x, mouse.y,
                                                canvas.radius - canvas.thickness / 2,
                                                canvas.radius + canvas.thickness / 2)

        }
        onReleased:  {
            canvas.rotating = false
            canvas.dragging = false
        }
        onExited: canvas.hovering = false
    }

    MouseArea {
        property int lastX
        property int lastY

        onPositionChanged: {
            var dx = mouse.x - lastX
            var dy = mouse.y - lastY

            canvas.x += dx
            canvas.y += dy

            lastX = mouse.x
            lastY = mouse.y
        }

        onPressed: {
            console.log("move")
            lastX = mouse.x
            lastY = mouse.y
        }

        onReleased: {
            x = canvas.x + canvas.width / 2
            y = canvas.y + canvas.height / 2
        }

        Component.onCompleted: {
            parent = canvas.parent
            x = canvas.x + canvas.width / 2
            y = canvas.y + canvas.height / 2
            width = 20
            height = 20
        }
    }

}
