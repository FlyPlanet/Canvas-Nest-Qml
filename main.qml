import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Hello World")
    Canvas{
        id:canvas
        anchors.fill: parent
        property real lastX: 0
        property real lastY: 0

        onPaint: {
            var ctx=canvas.getContext("2d");

        }
        Timer{
            id:request_timer
            repeat: true
            interval: 1000
            triggeredOnStart: false

        }
        Component.onCompleted:request_timer.start()
        MouseArea{
            anchors.fill: parent
            onMouseXChanged: canvas.lastX=mouseX
            onMouseYChanged: canvas.lastY=mouseY
            onClicked:{
                canvas.init();
                console.log(config)
            }
        }
        function draw_canvas(context) {
            context.clearRect(0, 0, canvas_width, canvas_height);
            //随机的线条和当前位置联合数组
            var e, i, d, x_dist, y_dist, dist; //临时节点
            //遍历处理每一个点
            random_points.forEach(function(r, idx) {
              r.x += r.xa,
              r.y += r.ya, //移动
              r.xa *= r.x > canvas_width || r.x < 0 ? -1 : 1,
              r.ya *= r.y > canvas_height || r.y < 0 ? -1 : 1, //碰到边界，反向反弹
              context.fillRect(r.x - 0.5, r.y - 0.5, 1, 1); //绘制一个宽高为1的点
              //从下一个点开始
              for (i = idx + 1; i < all_array.length; i++) {
                e = all_array[i];
                // 当前点存在
                if (null !== e.x && null !== e.y) {
                  x_dist = r.x - e.x; //x轴距离 l
                  y_dist = r.y - e.y; //y轴距离 n
                  dist = x_dist * x_dist + y_dist * y_dist; //总距离, m

                  dist < e.max && (e === current_point && dist >= e.max / 2 && (r.x -= 0.03 * x_dist, r.y -= 0.03 * y_dist), //靠近的时候加速
                    d = (e.max - dist) / e.max,
                    context.beginPath(),
                    context.lineWidth = d / 2,
                    context.strokeStyle = "rgba(" + config.c + "," + (d + 0.2) + ")",
                    context.moveTo(r.x, r.y),
                    context.lineTo(e.x, e.y),
                    context.stroke());
                }
              }
            }), frame_func(draw_canvas);
          }
        function init(){
            var config=get_config_option();
        }
        function get_config_option(){
            return {l:-1,z:0.5,c:"0,0,0",n:99}
        }
    }
}
