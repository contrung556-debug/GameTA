import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Isometric, 3D-styled city artwork with extruded buildings, lit roofs,
/// sidewalks, trees and street details. All art is offline and resolution-independent.
class BeVuiIsometricCity extends StatelessWidget {
  const BeVuiIsometricCity({super.key});
  @override
  Widget build(BuildContext context)=>const CustomPaint(
    painter:_IsometricCityPainter(),child:SizedBox.expand());
}
class _IsometricCityPainter extends CustomPainter {
  const _IsometricCityPainter();
  static const dark=Color(0xFF3C5175);
  void poly(Canvas c,List<Offset> points,Color color){
    final path=Path()..moveTo(points.first.dx,points.first.dy);
    for(final point in points.skip(1)){path.lineTo(point.dx,point.dy);}
    path.close();c.drawPath(path,Paint()..color=color..isAntiAlias=true);
  }
  void rounded(Canvas c,Rect rect,Color color,double radius){
    c.drawRRect(RRect.fromRectAndRadius(rect,Radius.circular(radius)),
      Paint()..color=color..isAntiAlias=true);
  }
  void oval(Canvas c,Offset center,double rx,double ry,Color color){
    c.drawOval(Rect.fromCenter(center:center,width:rx*2,height:ry*2),
      Paint()..color=color..isAntiAlias=true);
  }
  void label(Canvas c,String text,Offset point,{double fontSize=10}){
    final tp=TextPainter(text:TextSpan(text:text,style:TextStyle(
      color:dark,fontSize:fontSize,fontWeight:FontWeight.w900)),
      textDirection:TextDirection.ltr)..layout(maxWidth:145);
    tp.paint(c,point);
  }
  void building(Canvas c,{required double x,required double y,
    required double w,required double h,required Color front,
    required Color side,required Color roof,required String name,
    required String symbol}){
    const depth=16.0;
    // Soft ground contact shadow.
    oval(c,Offset(x+w/2+7,y+h+5),w*.63,10,const Color(0x30304A69));
    poly(c,[Offset(x+w,y+10),Offset(x+w+depth,y-2),
      Offset(x+w+depth,y+h-11),Offset(x+w,y+h)],side);
    rounded(c,Rect.fromLTWH(x,y+10,w,h-10),front,5);
    poly(c,[Offset(x-3,y+10),Offset(x+depth,y-9),
      Offset(x+w+depth,y-9),Offset(x+w+depth,y-2),
      Offset(x+w,y+12),Offset(x,y+12)],roof);
    poly(c,[Offset(x+w,y+12),Offset(x+w+depth,y-2),
      Offset(x+w+depth,y+6),Offset(x+w,y+21)],side);
    // Windows with white upper-edge reflection.
    for(var row=0;row<2;row++){
      for(var col=0;col<3;col++){
        final wx=x+9+col*(w-17)/3;
        final wy=y+23+row*23;
        rounded(c,Rect.fromLTWH(wx,wy,14,15),const Color(0xFF6DCDEB),3);
        rounded(c,Rect.fromLTWH(wx+2,wy+2,10,4),
          const Color(0xFFC7F5FF),2);
      }
    }
    rounded(c,Rect.fromLTWH(x+w/2-11,y+h-24,22,24),
      const Color(0xFF687C9D),4);
    rounded(c,Rect.fromLTWH(x-4,y+h-1,w+8,7),
      const Color(0xFFFDF4DF),4);
    rounded(c,Rect.fromLTWH(x+8,y-7,w-4,18),Colors.white,8);
    label(c,symbol+' '+name,Offset(x+12,y-5),9);
  }
  void tree(Canvas c,double x,double y,double scale){
    c.save();c.translate(x,y);c.scale(scale);
    oval(c,const Offset(4,10),18,5,const Color(0x25516C78));
    rounded(c,const Rect.fromLTWH(-3,-13,7,27),
      const Color(0xFF9E7250),3);
    oval(c,const Offset(0,-20),20,19,const Color(0xFF1B986B));
    oval(c,const Offset(-8,-27),15,15,const Color(0xFF4CD68B));
    oval(c,const Offset(8,-32),13,13,const Color(0xFF86E8A1));
    c.restore();
  }
  void car(Canvas c,double x,double y,Color color){
    oval(c,Offset(x+24,y+19),28,5,const Color(0x33526A8B));
    rounded(c,Rect.fromLTWH(x,y,48,17),color,6);
    poly(c,[Offset(x+9,y),Offset(x+17,y-11),
      Offset(x+33,y-11),Offset(x+40,y)],color);
    rounded(c,Rect.fromLTWH(x+18,y-8,13,7),
      const Color(0xFFB9F2FF),2);
    for(final dx in [9.0,39.0]){
      oval(c,Offset(x+dx,y+17),5,5,const Color(0xFF33425F));
      oval(c,Offset(x+dx,y+17),2,2,Colors.white);
    }
  }
  @override
  void paint(Canvas canvas,Size size){
    canvas.save();
    canvas.scale(size.width/400,size.height/290);
    final bg=Rect.fromLTWH(0,0,400,290);
    canvas.drawRect(bg,Paint()..shader=const LinearGradient(
      begin:Alignment.topCenter,end:Alignment.bottomCenter,
      colors:[Color(0xFF93DAFF),Color(0xFFE3F9EE),Color(0xFFAEEDB2)])
      .createShader(bg));
    // Distant rounded hills and clouds.
    oval(canvas,const Offset(45,112),125,47,const Color(0xFF9DDFBF));
    oval(canvas,const Offset(348,119),154,53,const Color(0xFF86D9B1));
    for(final cloud in [const Offset(40,30),const Offset(186,18),const Offset(317,38)]){
      oval(canvas,cloud,25,8,Colors.white70);
      oval(canvas,cloud+const Offset(-8,-5),14,11,Colors.white70);
    }
    oval(canvas,const Offset(357,30),19,19,const Color(0xFFFFE78C));
    rounded(canvas,const Rect.fromLTWH(0,119,400,171),
      const Color(0xFF86D69B),0);
    // Perspective-like layered roads and paved plaza.
    poly(canvas,[const Offset(0,202),const Offset(400,202),
      const Offset(400,266),const Offset(0,266)],const Color(0xFF7188A8));
    poly(canvas,[const Offset(0,198),const Offset(400,198),
      const Offset(400,206),const Offset(0,206)],const Color(0xFFE9E9DF));
    poly(canvas,[const Offset(0,266),const Offset(400,266),
      const Offset(400,275),const Offset(0,275)],const Color(0xFFE7E7DB));
    for(var i=0;i<9;i++){
      rounded(canvas,Rect.fromLTWH(i*49+9,232,25,3),
        const Color(0xFFF9F2D1),2);
    }
    poly(canvas,[const Offset(145,153),const Offset(257,153),
      const Offset(288,197),const Offset(119,197)],
      const Color(0xFFE6D6B7));
    // Buildings arranged to match tappable hotspots in CatCityScreen.
    building(canvas,x:32,y:77,w:84,h:96,
      front:const Color(0xFFFFD588),side:const Color(0xFFE8A56E),
      roof:const Color(0xFFF47786),name:'SCHOOL',symbol:'');
    building(canvas,x:153,y:77,w:82,h:96,
      front:const Color(0xFFB8EBFF),side:const Color(0xFF73B7E2),
      roof:const Color(0xFF5498E5),name:'HOSPITAL',symbol:'+');
    building(canvas,x:275,y:77,w:89,h:96,
      front:const Color(0xFFE4CCFF),side:const Color(0xFFA48DD5),
      roof:const Color(0xFF9A73DE),name:'SHOP',symbol:'');
    // Foreground stalls use lower roofs, keeping the road visible.
    building(canvas,x:18,y:177,w:83,h:46,
      front:const Color(0xFFFFB6C9),side:const Color(0xFFD97A9B),
      roof:const Color(0xFFFF6E9B),name:'MARKET',symbol:'');
    building(canvas,x:285,y:176,w:84,h:47,
      front:const Color(0xFFFFDCA6),side:const Color(0xFFE2A267),
      roof:const Color(0xFFFF9A60),name:'FOOD',symbol:'');
    // Plaza fountain.
    oval(canvas,const Offset(199,194),42,13,const Color(0xFFE8F4FF));
    oval(canvas,const Offset(199,190),34,9,const Color(0xFF4DBDEB));
    oval(canvas,const Offset(199,188),23,6,const Color(0xFFA7F0FF));
    rounded(canvas,const Rect.fromLTWH(195,166,8,24),
      const Color(0xFF8DDFFF),4);
    oval(canvas,const Offset(199,166),10,5,const Color(0xFFC6F6FF));
    for(final t in [
      const Offset(11,143),const Offset(128,164),
      const Offset(256,166),const Offset(383,148)]){
      tree(canvas,t.dx,t.dy,.68);
    }
    // Extra greenery and cheerful vehicles.
    car(canvas,117,253,const Color(0xFFFF779B));
    car(canvas,312,250,const Color(0xFFFFD15D));
    rounded(canvas,const Rect.fromLTWH(9,9,150,29),
      const Color(0xFF7354CF),15);
    final title=TextPainter(text:const TextSpan(text:'BÉ VUI CITY ✨',
      style:TextStyle(color:Colors.white,fontSize:17,
        fontWeight:FontWeight.w900)),textDirection:TextDirection.ltr)..layout();
    title.paint(canvas,const Offset(19,14));
    // Decorative light sparkles.
    for(final pt in [const Offset(267,30),const Offset(17,75),
      const Offset(382,68)]){
      final p=Paint()..color=Colors.white.withValues(alpha:.8)
        ..strokeWidth=2..strokeCap=StrokeCap.round;
      canvas.drawLine(pt+const Offset(-5,0),pt+const Offset(5,0),p);
      canvas.drawLine(pt+const Offset(0,-5),pt+const Offset(0,5),p);
    }
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
