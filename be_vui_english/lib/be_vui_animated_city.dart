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
                  color:Color(0xFF4D4A82))))),
        ]);
      }))),
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
