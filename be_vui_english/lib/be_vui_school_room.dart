import 'package:flutter/material.dart';
import 'be_vui_cat_portrait.dart';

/// A dedicated illustrated classroom before the existing English quiz.
class BeVuiSchoolRoom extends StatelessWidget {
  final VoidCallback onStartLesson;
  const BeVuiSchoolRoom({super.key,required this.onStartLesson});

  @override
  Widget build(BuildContext context)=>Scaffold(
    backgroundColor:const Color(0xFFFFF8E8),
    appBar:AppBar(title:const Text('🏫 Trường học Bé Vui')),
    body:SafeArea(child:ListView(padding:const EdgeInsets.all(16),children:[
      ClipRRect(borderRadius:BorderRadius.circular(26),
        child:AspectRatio(aspectRatio:1.1,
          child:CustomPaint(painter:_ClassroomPainter(),
            child:Stack(children:[
              const Positioned(left:18,bottom:27,
                child:BeVuiCatPortrait(size:118)),
              Positioned(right:14,bottom:22,
                child:Container(
                  padding:const EdgeInsets.all(12),
                  decoration:BoxDecoration(color:Colors.white,
                    borderRadius:BorderRadius.circular(18)),
                  child:const Column(mainAxisSize:MainAxisSize.min,children:[
                    Text('Hello, students!',
                      style:TextStyle(fontWeight:FontWeight.w900,
                        color:Color(0xFF334A70))),
                    SizedBox(height:3),
                    Text('Xin chào các em!',
                      style:TextStyle(fontSize:12)),
                  ]))),
            ])))),
      const SizedBox(height:20),
      const Text('Lớp học tiếng Anh cùng Mèo Bé Vui',
        textAlign:TextAlign.center,
        style:TextStyle(fontSize:21,fontWeight:FontWeight.w900,
          color:Color(0xFF384D77))),
      const SizedBox(height:9),
      const Text('Nghe câu tiếng Anh và chọn đáp án đúng để nhận sao.',
        textAlign:TextAlign.center),
      const SizedBox(height:22),
      FilledButton.icon(
        onPressed:onStartLesson,
        icon:const Icon(Icons.play_arrow_rounded),
        label:const Padding(padding:EdgeInsets.all(12),
          child:Text('Bắt đầu bài học',
            style:TextStyle(fontSize:18,fontWeight:FontWeight.w800)))),
    ])),
  );
}

class _ClassroomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas,Size size){
    canvas.save();
    canvas.scale(size.width/360,size.height/330);
    final p=Paint()..isAntiAlias=true;
    void rect(double x,double y,double w,double h,Color color,[double r=0]){
      p.color=color;
      canvas.drawRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(x,y,w,h),Radius.circular(r)),p);
    }
    rect(0,0,360,330,const Color(0xFFFFE9B7));
    rect(0,224,360,106,const Color(0xFFEFCBA0));
    rect(16,18,328,204,const Color(0xFFFFF4DA),18);
    // Window, curtains, sunlight.
    rect(22,40,78,106,const Color(0xFF8DD8F8),10);
    rect(59,40,5,106,Colors.white);
    rect(22,89,78,5,Colors.white);
    rect(18,35,13,115,const Color(0xFFFFA9A0),6);
    rect(92,35,13,115,const Color(0xFFFFA9A0),6);
    // Chalkboard, frame and colorful writing.
    rect(120,35,215,125,const Color(0xFFB67C49),13);
    rect(128,43,199,109,const Color(0xFF338978),8);
    final title=TextPainter(
      text:const TextSpan(text:'A  B  C',
        style:TextStyle(color:Colors.white,fontSize:31,
          fontWeight:FontWeight.w900,letterSpacing:4)),
      textDirection:TextDirection.ltr)..layout();
    title.paint(canvas,const Offset(148,63));
    final words=TextPainter(
      text:const TextSpan(text:'Apple  •  Book  •  Cat',
        style:TextStyle(color:Color(0xFFFFEBA5),fontSize:14,
          fontWeight:FontWeight.w700)),
      textDirection:TextDirection.ltr)..layout();
    words.paint(canvas,const Offset(143,111));
    // Desk, legs, chair and a stack of books.
    rect(132,232,208,16,const Color(0xFFC67B47),6);
    rect(145,246,13,73,const Color(0xFF9B613E),4);
    rect(316,246,13,73,const Color(0xFF9B613E),4);
    rect(250,213,56,19,const Color(0xFF649BE9),3);
    rect(256,202,51,11,const Color(0xFFFFC95E),3);
    rect(266,191,38,11,const Color(0xFFEE83A4),3);
    rect(110,270,70,14,const Color(0xFF83B1EC),7);
    rect(123,284,10,42,const Color(0xFF547CB5),3);
    rect(163,284,10,42,const Color(0xFF547CB5),3);
    canvas.restore();
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate)=>false;
}
