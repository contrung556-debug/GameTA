import 'dart:math' as math;
import 'package:flutter/material.dart';

/// A lightweight, offline, 3D-styled mascot scene built with Flutter canvas.
/// Uses layered gradients, lighting and depth; no external assets or engine.
class BeVui3DCat extends StatefulWidget {
  final double size;
  const BeVui3DCat({super.key,this.size=130});
  @override
  State<BeVui3DCat> createState()=>_BeVui3DCatState();
}
class _BeVui3DCatState extends State<BeVui3DCat>
    with SingleTickerProviderStateMixin {
  late final AnimationController motion=AnimationController(
    vsync:this,duration:const Duration(milliseconds:2600))
    ..repeat(reverse:true);
  @override
  void dispose(){motion.dispose();super.dispose();}
  @override
  Widget build(BuildContext context)=>SizedBox(width:widget.size,height:widget.size,
    child:AnimatedBuilder(animation:motion,builder:(context,_)=>CustomPaint(
      painter:_Cat3DPainter(motion.value))));
}
class _Cat3DPainter extends CustomPainter {
  final double t;
  _Cat3DPainter(this.t);
  Paint gradient(Rect r,Color light,Color dark)=>Paint()
    ..shader=LinearGradient(begin:Alignment.topLeft,end:Alignment.bottomRight,
      colors:[light,dark]).createShader(r);
  void ellipse(Canvas c,Rect r,Color light,Color dark){
    c.drawOval(r,gradient(r,light,dark));
  }
  void path(Canvas c,List<Offset> pts,Color a,Color b){
    final p=Path()..moveTo(pts.first.dx,pts.first.dy);
    for(final point in pts.skip(1)){p.lineTo(point.dx,point.dy);}
    p.close();
    c.drawPath(p,gradient(p.getBounds(),a,b));
  }
  @override
  void paint(Canvas c,Size size){
    c.save();
    c.scale(size.width/150,size.height/150);
    final bounce=math.sin(t*math.pi)*3;
    ellipse(c,const Rect.fromLTWH(26,130,98,12),
      const Color(0x557D66A4),const Color(0x007D66A4));
    c.translate(0,-bounce);
    // Tail behind the body.
    final tail=Path()..moveTo(108,113)
      ..cubicTo(151,114,145,68,119,79);
    c.drawPath(tail,Paint()..color=const Color(0xFF737C99)
      ..style=PaintingStyle.stroke..strokeWidth=13
      ..strokeCap=StrokeCap.round);
    // Rounded body and paws with soft light.
    ellipse(c,const Rect.fromLTWH(41,87,68,52),
      const Color(0xFF68B7FF),const Color(0xFF2865C7));
    ellipse(c,const Rect.fromLTWH(35,123,35,18),
      const Color(0xFFB9C0D2),const Color(0xFF707D9C));
    ellipse(c,const Rect.fromLTWH(80,123,35,18),
      const Color(0xFFB9C0D2),const Color(0xFF707D9C));
    // Ears cast a darker side for depth.
    path(c,[const Offset(29,62),const Offset(31,11),const Offset(66,32)],
      const Color(0xFFC7CEDD),const Color(0xFF727D99));
    path(c,[const Offset(121,62),const Offset(119,11),const Offset(84,32)],
      const Color(0xFFCED4E1),const Color(0xFF6D7895));
    path(c,[const Offset(39,45),const Offset(38,25),const Offset(55,39)],
      const Color(0xFFFFC2D4),const Color(0xFFEC829F));
    path(c,[const Offset(111,45),const Offset(112,25),const Offset(95,39)],
      const Color(0xFFFFC2D4),const Color(0xFFEC829F));
    // Head: highlight upper left and darker right edge.
    ellipse(c,const Rect.fromLTWH(18,29,114,98),
      const Color(0xFFD5DAE6),const Color(0xFF7A849F));
    ellipse(c,const Rect.fromLTWH(33,72,84,48),
      const Color(0xFFFFFFFF),const Color(0xFFE4E7F0));
    // Cheeks.
    ellipse(c,const Rect.fromLTWH(26,82,20,12),
      const Color(0xFFFFCDD9),const Color(0xFFF5A6BA));
    ellipse(c,const Rect.fromLTWH(104,82,20,12),
      const Color(0xFFFFCDD9),const Color(0xFFF5A6BA));
    for(final x in [48.0,87.0]){
      ellipse(c,Rect.fromLTWH(x-15,53,30,40),Colors.white,
        const Color(0xFFDDEAF4));
      ellipse(c,Rect.fromLTWH(x-9,60,18,28),
        const Color(0xFF67E1CB),const Color(0xFF168C94));
      ellipse(c,Rect.fromLTWH(x-5,65,10,19),
        const Color(0xFF324B66),const Color(0xFF182842));
      c.drawCircle(Offset(x+3,66),4,Paint()..color=Colors.white);
    }
    ellipse(c,const Rect.fromLTWH(66,94,18,12),
      const Color(0xFFFFB5C7),const Color(0xFFE56E92));
    final pen=Paint()..color=const Color(0xFF705E77)
      ..style=PaintingStyle.stroke..strokeWidth=2.4
      ..strokeCap=StrokeCap.round;
    c.drawLine(const Offset(75,105),const Offset(75,112),pen);
    c.drawArc(const Rect.fromLTWH(63,106,12,11),0,math.pi,false,pen);
    c.drawArc(const Rect.fromLTWH(75,106,12,11),0,math.pi,false,pen);
    for(final sign in [-1.0,1.0]){
      for(final y in [99.0,107.0]){
        c.drawLine(Offset(75+sign*26,y),
          Offset(75+sign*49,y-3),pen);
      }
    }
    // Graduation cap with a lit top face.
    path(c,[const Offset(27,32),const Offset(75,10),
      const Offset(124,32),const Offset(75,51)],
      const Color(0xFF69A4FF),const Color(0xFF214DAB));
    path(c,[const Offset(47,41),const Offset(75,53),
      const Offset(105,41),const Offset(103,52),
      const Offset(75,65),const Offset(48,52)],
      const Color(0xFF3269D5),const Color(0xFF163B91));
    c.drawLine(const Offset(109,39),const Offset(116,72),
      Paint()..color=const Color(0xFFFFDA61)..strokeWidth=3);
    ellipse(c,const Rect.fromLTWH(111,67,10,15),
      const Color(0xFFFFE79C),const Color(0xFFE9A931));
    c.restore();
  }
  @override
  bool shouldRepaint(covariant _Cat3DPainter old)=>old.t!=t;
}
