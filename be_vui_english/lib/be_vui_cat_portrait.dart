import 'package:flutter/material.dart';

/// Original BeVui mascot illustration, drawn in Flutter at any resolution.
class BeVuiCatPortrait extends StatelessWidget {
  final double size;
  const BeVuiCatPortrait({super.key, this.size = 112});
  @override
  Widget build(BuildContext context) => SizedBox(
    width:size,height:size,child:CustomPaint(painter:_CatPortraitPainter()));
}
class _CatPortraitPainter extends CustomPainter {
  final brush=Paint()..isAntiAlias=true;
  void oval(Canvas c,double x,double y,double w,double h,Color color){
    brush.color=color;c.drawOval(Rect.fromCenter(
      center:Offset(x,y),width:w,height:h),brush);
  }
  void poly(Canvas c,List<Offset> points,Color color){
    brush.color=color;
    final p=Path()..moveTo(points.first.dx,points.first.dy);
    for(final point in points.skip(1)){p.lineTo(point.dx,point.dy);}
    p.close();c.drawPath(p,brush);
  }
  void line(Canvas c,Offset a,Offset b,Color color,double width){
    brush.color=color;brush.strokeWidth=width;
    brush.strokeCap=StrokeCap.round;brush.style=PaintingStyle.stroke;
    c.drawLine(a,b,brush);brush.style=PaintingStyle.fill;
  }
  @override
  void paint(Canvas c,Size size){
    c.save();c.scale(size.width/112,size.height/112);
    oval(c,56,105,82,10,const Color(0x2250608B));
    // Blue jacket and yellow scarf
    oval(c,56,96,57,49,const Color(0xFF398BE7));
    oval(c,56,87,28,19,const Color(0xFFFFD866));
    oval(c,27,96,18,20,const Color(0xFF9998AA));
    oval(c,85,96,18,20,const Color(0xFF9998AA));
    // Ears with a contrasting inner shape
    poly(c,[const Offset(15,42),const Offset(19,4),const Offset(47,26)],
      const Color(0xFF858599));
    poly(c,[const Offset(97,42),const Offset(93,4),const Offset(65,26)],
      const Color(0xFF858599));
    poly(c,[const Offset(24,30),const Offset(24,14),const Offset(39,28)],
      const Color(0xFFFFA3B8));
    poly(c,[const Offset(88,30),const Offset(88,14),const Offset(73,28)],
      const Color(0xFFFFA3B8));
    oval(c,56,51,88,75,const Color(0xFF9394A6));
    oval(c,56,70,62,39,const Color(0xFFF8F5F0));
    oval(c,37,47,24,31,Colors.white);
    oval(c,75,47,24,31,Colors.white);
    oval(c,39,47,13,22,const Color(0xFF4AB9A0));
    oval(c,73,47,13,22,const Color(0xFF4AB9A0));
    oval(c,41,45,7,14,const Color(0xFF233B5B));
    oval(c,71,45,7,14,const Color(0xFF233B5B));
    oval(c,43,41,5,6,Colors.white);
    oval(c,73,41,5,6,Colors.white);
    oval(c,56,66,15,11,const Color(0xFFF18D9D));
    line(c,const Offset(56,72),const Offset(56,78),
      const Color(0xFF70586A),2);
    line(c,const Offset(56,78),const Offset(64,81),
      const Color(0xFF70586A),2);
    line(c,const Offset(56,78),const Offset(48,81),
      const Color(0xFF70586A),2);
    for(final side in [-1.0,1.0]){
      for(final y in [66.0,73.0]){
        line(c,Offset(56+side*22,y),Offset(56+side*45,y-3),
          const Color(0xFFFDF9F5),2);
      }
    }
    // Character's distinctive graduation cap
    poly(c,[const Offset(24,20),const Offset(56,4),
      const Offset(89,20),const Offset(56,34)],const Color(0xFF2259C7));
    line(c,const Offset(35,25),const Offset(35,34),
      const Color(0xFFFFD45E),3);
    oval(c,35,37,7,10,const Color(0xFFFFD45E));
    c.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
