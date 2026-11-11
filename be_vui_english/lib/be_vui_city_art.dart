import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Original scalable vector art for the BeVui city prototype.
/// No third-party character images or emoji are used in this illustration.
class BeVuiCityArt extends StatelessWidget {
  const BeVuiCityArt({super.key});
  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: 1.28,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: CustomPaint(painter: _CityPainter()),
    ),
  );
}

class _CityPainter extends CustomPainter {
  final p = Paint()..isAntiAlias = true;
  void shape(Canvas c, Path path, Color color) {
    p.color = color; p.style = PaintingStyle.fill;
    c.drawPath(path, p);
  }
  void rect(Canvas c, Rect r, Color color, [double radius = 0]) {
    p.color = color; p.style = PaintingStyle.fill;
    c.drawRRect(RRect.fromRectAndRadius(r, Radius.circular(radius)), p);
  }
  void oval(Canvas c, Offset center, double rx, double ry, Color color) {
    p.color = color; p.style = PaintingStyle.fill;
    c.drawOval(Rect.fromCenter(center: center, width: rx * 2, height: ry * 2), p);
  }
  void line(Canvas c, Offset a, Offset b, Color color, double width) {
    p.color = color; p.strokeWidth = width; p.strokeCap = StrokeCap.round;
    p.style = PaintingStyle.stroke; c.drawLine(a,b,p); p.style = PaintingStyle.fill;
  }
  void text(Canvas c, String s, Offset at, double size, Color color,
      {FontWeight weight = FontWeight.w900}) {
    final painter = TextPainter(
      text: TextSpan(text:s,style:TextStyle(fontSize:size,color:color,
        fontWeight:weight, shadows:const [Shadow(color:Colors.white54,blurRadius:2)])),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(c, at);
  }
  void tree(Canvas c, double x, double y, double scale) {
    c.save(); c.translate(x,y); c.scale(scale);
    rect(c, const Rect.fromLTWH(-3, -5, 6, 25), const Color(0xFF9B613B),2);
    oval(c,const Offset(0,-15),18,19,const Color(0xFF2DB86E));
    oval(c,const Offset(-9,-21),12,13,const Color(0xFF5DDA72));
    oval(c,const Offset(8,-25),11,13,const Color(0xFF87ED7C));
    c.restore();
  }
  void building(Canvas c, double x, double y, double w, double h,
      Color front, Color roof, String label) {
    rect(c,Rect.fromLTWH(x+4,y+8,w,h),const Color(0x55454B70),9);
    rect(c,Rect.fromLTWH(x,y,w,h),front,8);
    final roofPath=Path()..moveTo(x-8,y+5)..lineTo(x+w/2,y-23)
      ..lineTo(x+w+8,y+5)..close();
    shape(c,roofPath,roof);
    line(c,Offset(x-7,y+5),Offset(x+w/2,y-23),Colors.white70,2);
    for(var i=0;i<3;i++) {
      final wx=x+11+i*(w-23)/3;
      rect(c,Rect.fromLTWH(wx,y+16,12,17),const Color(0xFF93DFF8),3);
      line(c,Offset(wx+6,y+16),Offset(wx+6,y+33),Colors.white,1.5);
    }
    rect(c,Rect.fromLTWH(x+w/2-11,y+h-30,22,30),const Color(0xFF8E5C69),5);
    rect(c,Rect.fromLTWH(x+4,y+h+5,w-8,22),const Color(0xFF543B9D),11);
    text(c,label,Offset(x+10,y+h+9),10,Colors.white);
  }
  void cat(Canvas c,double x,double y) {
    c.save();c.translate(x,y);
    oval(c,const Offset(0,37),35,8,const Color(0x44616B89));
    // curved striped tail
    p.color=const Color(0xFF8D8C9D);p.style=PaintingStyle.stroke;
    p.strokeWidth=13;p.strokeCap=StrokeCap.round;
    c.drawArc(const Rect.fromLTWH(24,3,34,39),-.6,3.4,false,p);
    p.style=PaintingStyle.fill;
    oval(c,const Offset(0,15),26,32,const Color(0xFF4C94EB));
    rect(c,const Rect.fromLTWH(-18,1,36,28),const Color(0xFFFFD773),12);
    oval(c,const Offset(-15,35),12,7,const Color(0xFFFCFAF5));
    oval(c,const Offset(15,35),12,7,const Color(0xFFFCFAF5));
    final left=Path()..moveTo(-31,-30)..lineTo(-30,-71)
      ..lineTo(-5,-49)..close();
    final right=Path()..moveTo(31,-30)..lineTo(30,-71)
      ..lineTo(5,-49)..close();
    shape(c,left,const Color(0xFF77778A));shape(c,right,const Color(0xFF77778A));
    shape(c,Path()..moveTo(-26,-43)..lineTo(-25,-61)..lineTo(-13,-47)..close(),
      const Color(0xFFFFA9B8));
    shape(c,Path()..moveTo(26,-43)..lineTo(25,-61)..lineTo(13,-47)..close(),
      const Color(0xFFFFA9B8));
    oval(c,const Offset(0,-31),39,35,const Color(0xFF91919E));
    oval(c,const Offset(0,-15),27,18,const Color(0xFFF9F8F3));
    oval(c,const Offset(-15,-33),12,15,Colors.white);
    oval(c,const Offset(15,-33),12,15,Colors.white);
    oval(c,const Offset(-13,-32),7,11,const Color(0xFF1C7EC1));
    oval(c,const Offset(13,-32),7,11,const Color(0xFF1C7EC1));
    oval(c,const Offset(-11,-36),3,4,Colors.white);
    oval(c,const Offset(15,-36),3,4,Colors.white);
    oval(c,const Offset(0,-17),7,5,const Color(0xFFEF8A91));
    line(c,const Offset(0,-12),const Offset(0,-7),const Color(0xFF705665),2);
    line(c,const Offset(0,-7),const Offset(8,-4),const Color(0xFF705665),2);
    line(c,const Offset(0,-7),const Offset(-8,-4),const Color(0xFF705665),2);
    for (final side in [-1.0,1.0]) {
      for(var i=0;i<2;i++) {
        line(c,Offset(side*22,-15+i*5),Offset(side*40,-19+i*7),
          const Color(0xFFFDF9F1),1.7);
      }
    }
    rect(c,const Rect.fromLTWH(-28,-78,56,8),const Color(0xFF245CC7),3);
    final hat=Path()..moveTo(-21,-77)..lineTo(-18,-91)
      ..lineTo(18,-91)..lineTo(21,-77)..close();
    shape(c,hat,const Color(0xFF2765DA));
    oval(c,const Offset(-24,10),9,12,const Color(0xFF9796A5));
    oval(c,const Offset(24,10),9,12,const Color(0xFF9796A5));
    c.restore();
  }
  @override
  void paint(Canvas canvas,Size size) {
    canvas.save();
    canvas.scale(size.width/400,size.height/315);
    final bg=Rect.fromLTWH(0,0,400,315);
    p.shader=const LinearGradient(begin:Alignment.topCenter,
      end:Alignment.bottomCenter,colors:[
        Color(0xFF72CEFF),Color(0xFFC2F5E5),Color(0xFF80D995)
      ]).createShader(bg);
    canvas.drawRect(bg,p);p.shader=null;
    oval(canvas,const Offset(339,35),23,23,const Color(0xFFFFE47A));
    for(var i=0;i<8;i++) {
      final a=i*math.pi/4;
      line(canvas,Offset(339+29*math.cos(a),35+29*math.sin(a)),
        Offset(339+36*math.cos(a),35+36*math.sin(a)),
        const Color(0xFFFFE47A),3);
    }
    for(final o in [const Offset(49,41),const Offset(160,25),const Offset(273,60)]) {
      oval(canvas,o,26,9,Colors.white70);
      oval(canvas,o+const Offset(-10,-5),16,11,Colors.white70);
    }
    rect(canvas,const Rect.fromLTWH(0,160,400,155),
      const Color(0xFF83D87C));
    // curved roads and crossing
    final road=Path()..moveTo(-25,244)..lineTo(425,244)
      ..lineTo(425,294)..lineTo(-25,294)..close();
    shape(canvas,road,const Color(0xFF788AA8));
    line(canvas,const Offset(0,267),const Offset(400,267),
      const Color(0xFFFFE6A4),3);
    for(var i=0;i<7;i++) {
      rect(canvas,Rect.fromLTWH(156+i*12,245,8,15),Colors.white,2);
    }
    tree(canvas,28,176,1.3);tree(canvas,372,179,1.2);
    tree(canvas,193,160,.75);tree(canvas,300,170,.8);
    building(canvas,48,91,85,80,const Color(0xFFFFD187),
      const Color(0xFFF47C73),'Trường học');
    building(canvas,159,91,86,80,const Color(0xFFA5E5FF),
      const Color(0xFF4C9CDE),'Bệnh viện');
    building(canvas,276,88,93,85,const Color(0xFFE5C5FF),
      const Color(0xFF9461D3),'Siêu thị');
    building(canvas,24,190,92,42,const Color(0xFFFFB1C2),
      const Color(0xFFED6592),'Chợ');
    building(canvas,278,189,92,43,const Color(0xFFFFD9A3),
      const Color(0xFFFF9A59),'Nhà hàng');
    // central fountain
    oval(canvas,const Offset(198,208),56,22,const Color(0xFFFDF8DD));
    oval(canvas,const Offset(198,204),47,16,const Color(0xFF47B8E9));
    oval(canvas,const Offset(198,204),30,10,const Color(0xFF8CE7FF));
    line(canvas,const Offset(198,199),const Offset(198,177),
      const Color(0xFFB9F3FF),6);
    oval(canvas,const Offset(198,175),11,8,const Color(0xFF6BCBFF));
    // bus
    rect(canvas,const Rect.fromLTWH(280,263,76,28),
      const Color(0xFFFFCB43),8);
    rect(canvas,const Rect.fromLTWH(288,267,54,11),
      const Color(0xFF8BD9FA),3);
    oval(canvas,const Offset(295,292),7,7,const Color(0xFF36455D));
    oval(canvas,const Offset(343,292),7,7,const Color(0xFF36455D));
    // cat in foreground
    cat(canvas,91,280);
    // floating title
    rect(canvas,const Rect.fromLTWH(8,7,179,36),
      const Color(0xFF6347C3),18);
    text(canvas,'BÉ VUI CITY',const Offset(21,13),22,Colors.white);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
