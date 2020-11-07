import QtQuick 2.0
import QtQuick.Window 2.12

Window {
    visible: true
    width: 640
    height: 480
    title: qsTr("Canvas-Nest in Qml")


    MouseArea{
        anchors.fill:parent
        onClicked: {


        }
    }

    Canvas{
        id:canvas
        anchors.fill: parent
        property real lastX: 0
        property real lastY: 0
        property bool firstinit: true
        property var arr: []
        property var config: []

        onPaint: {
            var ctx=canvas.getContext("2d");
            if (firstinit){
                firstinit=false;
                arr=init();
                config=get_config_option()

            }
            var current_point = {
                  x: null, //当前鼠标x
                  y: null, //当前鼠标y
                  max: 20000 // 圈半径的平方
                }


            draw_canvas(ctx,arr,arr.concat([current_point]),current_point);

        }
        Timer{
            id:request_timer
            repeat: true
            interval: 1
            triggeredOnStart: false
            onTriggered: {
                canvas.requestPaint();
            }

        }
        Component.onCompleted:request_timer.start()

        function draw_canvas(context,random_points,all_array,current_point) {
            context.clearRect(0, 0, canvas.width, canvas.height);
            //随机的线条和当前位置联合数组
            var e, i, d, x_dist, y_dist, dist; //临时节点
            //遍历处理每一个点
            random_points.forEach(function(r, idx) {
              r.x += r.xa;
              r.y += r.ya; //移动
              r.xa *= r.x > canvas.width || r.x < 0 ? -1 : 1;
              r.ya *= r.y > canvas.height || r.y < 0 ? -1 : 1; //碰到边界，反向反弹
              context.fillRect(r.x - 0.5, r.y - 0.5, 1, 1); //绘制一个宽高为1的点
              //从下一个点开始
              for (i = idx + 1; i < all_array.length; i++) {
                e = all_array[i];
                // 当前点存在
                if (null !== e.x && null !== e.y) {
                  x_dist = r.x - e.x; //x轴距离 l
                  y_dist = r.y - e.y; //y轴距离 n
                  dist = x_dist * x_dist + y_dist * y_dist; //总距离, m

                  dist < e.max && (e === current_point && dist >= e.max / 2 && (r.x -= 0.03 * x_dist, r.y -= 0.03 * y_dist),
                    d = (e.max - dist) / e.max,
                    context.beginPath(),
                    context.lineWidth = d / 2,
                    context.strokeStyle = "rgba(" + config.c + "," + (d + 0.2) + ")",
                    context.moveTo(r.x, r.y),
                    context.lineTo(e.x, e.y),
                    context.stroke());
                }
              }
            });
          }
        function init(){
            var config=get_config_option();
            for (var random_points=[],i=0;config.n>i;i++){
                var x= (random()) * canvas.width;
                var y= (random()) * canvas.height;
                var xa=2*random()-1;
                var ya=2*random()-1;
                random_points.push({x:x,y:y,xa:xa,ya:ya,max:6000});
            }
                return random_points;




        }
        function random(){
            return Math.random();
        }

        function get_config_option(){
            return {l:-1,z:0.5,c:"0,0,0",n:40}
        }
    }
}
