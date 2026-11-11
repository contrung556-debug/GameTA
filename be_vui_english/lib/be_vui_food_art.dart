import 'package:flutter/material.dart';

/// Original illustrated food icons rendered as vector art.
class BeVuiFoodArt extends StatelessWidget {
  final String food;
  const BeVuiFoodArt({super.key, required this.food});
  @override
  Widget build(BuildContext context) => SizedBox(
    width: 104,height: 86,
    child: CustomPaint(painter: _FoodPainter(food)),
  );
}
class _FoodPainter extends CustomPainter {
  final String food;
  _FoodPainter(this.food);
  final brush=Paint()..isAntiAlias=true;
  void oval(Canvas c,double x,double y,double w,double h,Color color) {
    brush.color=color;
    c.drawOval(Rect.fromCenter(center:Offset(x,y),width:w,height:h),brush);
  }
  void path(Canvas c,Path p,Color color) {
    brush.color=color;c.drawPath(p,brush);
  }
  void rect(Canvas c,double x,double y,double w,double h,Color color,double r) {
    brush.color=color;
    c.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(x,y,w,h),
      Radius.circular(r)),brush);
  }
  @override
  void paint(Canvas c,Size size) {
    c.save();c.scale(size.width/104,size.height/86);
    oval(c,52,77,67,9,const Color(0x225B4770));
    switch(food) {
      case 'apple':
        oval(c,41,43,39,49,const Color(0xFFED4355));
        oval(c,63,43,39,49,const Color(0xFFF65E65));
        oval(c,43,29,12,18,const Color(0x77FFD2C5));
        rect(c,50,9,5,15,const Color(0xFF76513B),2);
        oval(c,67,15,29,13,const Color(0xFF53BC6B));
        break;
      case 'banana':
        path(c,Path()..moveTo(14,22)..cubicTo(24,81,82,80,95,20)
          ..cubicTo(72,50,42,59,14,22)..close(),const Color(0xFFFFD24B));
        path(c,Path()..moveTo(22,30)..quadraticBezierTo(52,72,86,27)
          ..quadraticBezierTo(54,61,22,30)..close(),const Color(0xFFFFE88A));
        rect(c,11,17,9,10,const Color(0xFF8A6542),3);
        break;
      case 'carrot':
        path(c,Path()..moveTo(25,24)..quadraticBezierTo(57,8,80,32)
          ..lineTo(46,77)..close(),const Color(0xFFFF9742));
        path(c,Path()..moveTo(42,23)..quadraticBezierTo(12,7,24,2)
          ..quadraticBezierTo(45,3,51,22)..close(),const Color(0xFF40B968));
        path(c,Path()..moveTo(49,23)..quadraticBezierTo(48,1,68,1)
          ..quadraticBezierTo(68,16,57,27)..close(),const Color(0xFF249C5B));
        break;
      case 'fish':
        path(c,Path()..moveTo(75,42)..lineTo(98,20)
          ..lineTo(98,65)..close(),const Color(0xFF258FCD));
        oval(c,47,42,73,46,const Color(0xFF4BC8ED));
        path(c,Path()..moveTo(41,24)..lineTo(53,9)
          ..lineTo(66,24)..close(),const Color(0xFF329BD0));
        oval(c,26,35,10,10,Colors.white);
        oval(c,27,35,5,6,const Color(0xFF273C5B));
        break;
      case 'bread':
        rect(c,16,17,73,55,const Color(0xFFCF8C4C),20);
        rect(c,23,13,65,55,const Color(0xFFFFD58C),18);
        rect(c,30,23,50,39,const Color(0xFFFFE8B1),13);
        break;
      case 'milk':
        path(c,Path()..moveTo(30,17)..lineTo(74,17)
          ..lineTo(70,74)..lineTo(34,74)..close(),Colors.white);
        path(c,Path()..moveTo(30,17)..lineTo(43,5)
          ..lineTo(78,5)..lineTo(74,17)..close(),const Color(0xFF69A6F4));
        rect(c,35,31,35,24,const Color(0xFF71ABF4),6);
        oval(c,52,43,21,12,Colors.white);
        break;
      case 'grapes':
        rect(c,52,7,5,18,const Color(0xFF568B46),2);
        oval(c,64,17,26,12,const Color(0xFF5FBE67));
        for(final pt in [const Offset(36,30),const Offset(56,29),
          const Offset(75,30),const Offset(45,45),
          const Offset(65,45),const Offset(54,60)]) {
          oval(c,pt.dx,pt.dy,24,25,const Color(0xFF8754C7));
          oval(c,pt.dx-4,pt.dy-4,8,7,const Color(0xFFA881E0));
        }
        break;
      case 'pizza':
        path(c,Path()..moveTo(14,19)..quadraticBezierTo(52,5,92,19)
          ..lineTo(53,76)..close(),const Color(0xFFFFD362));
        oval(c,38,31,16,14,const Color(0xFFD95653));
        oval(c,67,31,16,14,const Color(0xFFD95653));
        oval(c,54,49,16,14,const Color(0xFFD95653));
        oval(c,43,45,10,6,const Color(0xFF50AA66));
        break;
    }
    c.restore();
  }
  @override
  bool shouldRepaint(covariant _FoodPainter old)=>old.food!=food;
}
