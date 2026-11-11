import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'be_vui_cat_portrait.dart';
import 'be_vui_city_art.dart';

/// Animated city with a walking mascot and a gentle camera-like pan.
class BeVuiAnimatedCity extends StatefulWidget {
  const BeVuiAnimatedCity({super.key});
  @override
  State<BeVuiAnimatedCity> createState()=>_BeVuiAnimatedCityState();
}
class _BeVuiAnimatedCityState extends State<BeVuiAnimatedCity>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  @override
  void initState(){
    super.initState();
    controller=AnimationController(vsync:this,
      duration:const Duration(seconds:9))..repeat(reverse:true);
  }
  @override
  void dispose(){controller.dispose();super.dispose();}
  @override
  Widget build(BuildContext context)=>AspectRatio(
    aspectRatio:1.38,
    child:ClipRRect(borderRadius:BorderRadius.circular(26),
      child:AnimatedBuilder(animation:controller,builder:(context,child){
        final t=controller.value;
        final walk=math.sin(t*math.pi*12);
        return Stack(fit:StackFit.expand,children:[
          // The existing original city artwork remains the backdrop.
          Transform.scale(scale:1.045,
            child:Transform.translate(
              offset:Offset((t-.5)*-12,0),
              child:const BeVuiCityArt())),
          Positioned(right:((1-t)*290)-80,bottom:29,
            child:const _MovingBus()),
          Positioned(left:t*220-55,bottom:16,
            child:const _MovingCar()),
          Positioned(left:12+t*35,top:10,
            child:Opacity(opacity:.75,
              child:const Icon(Icons.cloud_rounded,size:39,
                color:Colors.white))),
          Positioned(right:15+t*24,top:21,
            child:Opacity(opacity:.65,
              child:const Icon(Icons.cloud_rounded,size:29,
                color:Colors.white))),
          Positioned(left:0,right:0,bottom:2,
            child:IgnorePointer(child:CustomPaint(
              size:const Size(double.infinity,14),
              painter:_GroundShadowPainter()))),
          Positioned(
            left:18+t*74,
            bottom:9+walk.abs()*3,
            child:Transform.rotate(angle:walk*.045,
              child:const BeVuiCatPortrait(size:73))),
          Positioned(
            left:12+t*74,
            bottom:82,
            child:Opacity(opacity:.85,
              child:Container(
                padding:const EdgeInsets.symmetric(
                  horizontal:10,vertical:5),
                decoration:BoxDecoration(color:Colors.white,
                  borderRadius:BorderRadius.circular(16)),
                child:const Text('Hello! 👋',style:TextStyle(
                  fontSize:11,fontWeight:FontWeight.w800,
                  color:Color(0xFF4D4A82)))))),
        ]);
      })),
  );
}
class _GroundShadowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas,Size size){
    final paint=Paint()..color=const Color(0x120B3052);
    canvas.drawRect(Rect.fromLTWH(0,0,size.width,size.height),paint);
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _MovingBus extends StatelessWidget {
  const _MovingBus();
  @override
  Widget build(BuildContext context)=>SizedBox(
    width:76,height:43,
    child:CustomPaint(painter:_BusPainter()),
  );
}
class _BusPainter extends CustomPainter {
  @override
  void paint(Canvas c,Size size){
    final p=Paint()..isAntiAlias=true;
    void rr(Rect r,Color color,double radius){
      p.color=color;
      c.drawRRect(RRect.fromRectAndRadius(r,Radius.circular(radius)),p);
    }
    rr(const Rect.fromLTWH(2,6,72,30),const Color(0xFFFFBC45),8);
    rr(const Rect.fromLTWH(9,11,18,13),const Color(0xFFB6E8FC),3);
    rr(const Rect.fromLTWH(31,11,18,13),const Color(0xFFB6E8FC),3);
    rr(const Rect.fromLTWH(53,11,13,13),const Color(0xFFB6E8FC),3);
    for(final x in [18.0,59.0]){
      p.color=const Color(0xFF38435D);
      c.drawCircle(Offset(x,36),7,p);
      p.color=const Color(0xFFDDE3F4);
      c.drawCircle(Offset(x,36),3,p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}

class _MovingCar extends StatelessWidget {
  const _MovingCar();
  @override
  Widget build(BuildContext context)=>SizedBox(
    width:52,height:29,child:CustomPaint(painter:_CarPainter()));
}
class _CarPainter extends CustomPainter {
  @override
  void paint(Canvas c,Size size){
    final p=Paint()..isAntiAlias=true;
    void shape(Path path,Color color){p.color=color;c.drawPath(path,p);}
    shape(Path()..moveTo(4,13)..lineTo(12,13)..lineTo(20,3)
      ..lineTo(36,3)..lineTo(44,13)..lineTo(49,13)
      ..quadraticBezierTo(52,13,52,19)..lineTo(52,23)
      ..lineTo(0,23)..lineTo(0,18)
      ..quadraticBezierTo(0,13,4,13)..close(),
      const Color(0xFFFF668C));
    shape(Path()..moveTo(20,6)..lineTo(34,6)
      ..lineTo(40,13)..lineTo(14,13)..close(),
      const Color(0xFFBCEBFA));
    for(final x in [12.0,42.0]){
      p.color=const Color(0xFF374363);
      c.drawCircle(Offset(x,23),5,p);
      p.color=const Color(0xFFDDE7F4);
      c.drawCircle(Offset(x,23),2,p);
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
