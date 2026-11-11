import 'package:flutter/material.dart';
import 'cat_city.dart';
import 'be_vui_3d_cat.dart';
import 'be_vui_progress.dart';
import 'main.dart' show LessonScreen, topics;

/// Playable game hub inspired by the supplied colorful landscape mockups.
/// All menu buttons navigate to working activities; rewards use saved progress.
class BeVuiGameHub extends StatefulWidget {
  const BeVuiGameHub({super.key});
  @override
  State<BeVuiGameHub> createState()=>_BeVuiGameHubState();
}
class _BeVuiGameHubState extends State<BeVuiGameHub> {
  String filter='Tất cả';
  static const violet=Color(0xFF6037C8);
  static const navy=Color(0xFF2E2267);
  final filters=['Tất cả','Từ vựng','Nghe - Nói','Trò chơi'];
  @override
  Widget build(BuildContext context){
    final screen=MediaQuery.sizeOf(context);
    final wide=screen.width>=700;
    return Scaffold(
      backgroundColor:const Color(0xFFBDEFFF),
      body:SafeArea(child:LayoutBuilder(builder:(context,constraints){
        final items=List.generate(topics.length,(i)=>i)
          .where((i)=>filter=='Tất cả'||
            (filter=='Từ vựng'?i<6:filter=='Nghe - Nói'?i>=6:i.isEven))
          .toList();
        return Stack(children:[
          Positioned.fill(child:DecoratedBox(decoration:const BoxDecoration(
            gradient:LinearGradient(begin:Alignment.topCenter,
              end:Alignment.bottomCenter,colors:[
                Color(0xFF65C9FF),Color(0xFFCBF6FF),Color(0xFFAAECA8)])))),
          Positioned(top:20,right:10,child:Icon(Icons.cloud_rounded,
            size:110,color:Colors.white.withValues(alpha:.55))),
          Positioned(top:100,left:-25,child:Icon(Icons.cloud_rounded,
            size:100,color:Colors.white.withValues(alpha:.5))),
          CustomScrollView(slivers:[
            SliverToBoxAdapter(child:Padding(
              padding:EdgeInsets.symmetric(horizontal:wide?26:14,vertical:12),
              child:Column(children:[
                Row(children:[
                  Container(width:wide?94:68,height:wide?94:68,
                    decoration:BoxDecoration(color:Colors.white.withValues(alpha:.65),
                      border:Border.all(color:Colors.white,width:3),
                      borderRadius:BorderRadius.circular(24)),
                    child:BeVui3DCat(size:wide?84:60)),
                  const SizedBox(width:12),
                  Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Text('MÈO BÉ VUI',style:TextStyle(
                      fontSize:wide?31:22,fontWeight:FontWeight.w900,color:navy,
                      shadows:const [Shadow(color:Colors.white,blurRadius:8)])),
                    const Text('THẾ GIỚI TRÒ CHƠI TIẾNG ANH',
                      style:TextStyle(fontSize:11,color:violet,fontWeight:FontWeight.w900)),
                  ])),
                  AnimatedBuilder(animation:BeVuiProgress.instance,
                    builder:(context,_)=>_score('⭐',BeVuiProgress.instance.stars.toString())),
                  const SizedBox(width:8),
                  IconButton.filledTonal(onPressed:()=>_help(context),
                    icon:const Icon(Icons.settings_rounded,color:violet)),
                ]),
                const SizedBox(height:16),
                _glossyPanel(child:Padding(
                  padding:const EdgeInsets.symmetric(horizontal:16,vertical:13),
                  child:Row(children:[
                    const Icon(Icons.sports_esports_rounded,color:violet,size:30),
                    const SizedBox(width:10),
                    const Expanded(child:Text('Chơi mà học • Học mà vui!',
                      style:TextStyle(fontSize:19,fontWeight:FontWeight.w900,color:navy))),
                    const Text('🎮',style:TextStyle(fontSize:26)),
                  ]))),
                const SizedBox(height:14),
                SizedBox(height:48,child:ListView.separated(
                  scrollDirection:Axis.horizontal,itemCount:filters.length,
                  separatorBuilder:(_,__)=>const SizedBox(width:8),
                  itemBuilder:(context,i){
                    final active=filter==filters[i];
                    return InkWell(onTap:()=>setState(()=>filter=filters[i]),
                      borderRadius:BorderRadius.circular(24),
                      child:Container(padding:const EdgeInsets.symmetric(horizontal:16),
                        alignment:Alignment.center,
                        decoration:BoxDecoration(
                          gradient:active?const LinearGradient(colors:[
                            Color(0xFFFFE15E),Color(0xFFFFAB43)]):null,
                          color:active?null:Colors.white.withValues(alpha:.9),
                          border:Border.all(color:active?const Color(0xFFFFF5B8):Colors.white,width:2),
                          borderRadius:BorderRadius.circular(24),
                          boxShadow:const [BoxShadow(color:Color(0x226348AB),blurRadius:5,offset:Offset(0,3))]),
                        child:Text(filters[i],style:const TextStyle(
                          fontWeight:FontWeight.w900,color:navy))));
                  })),
                const SizedBox(height:14),
                _glossyPanel(child:InkWell(
                  borderRadius:BorderRadius.circular(26),
                  onTap:()=>Navigator.push(context,
                    MaterialPageRoute(builder:(_)=>const CatCityScreen())),
                  child:Padding(padding:const EdgeInsets.all(14),
                    child:Row(children:[
                      const BeVui3DCat(size:88),
                      const SizedBox(width:10),
                      const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                        Text('🏙️ KHÁM PHÁ THÀNH PHỐ',
                          style:TextStyle(color:navy,fontSize:18,fontWeight:FontWeight.w900)),
                        SizedBox(height:5),
                        Text('Trường học • Siêu thị • Nhà hàng',
                          style:TextStyle(color:violet,fontSize:12,fontWeight:FontWeight.w700)),
                      ])),
                      const Icon(Icons.play_circle_fill_rounded,
                        color:Color(0xFFFF973E),size:46),
                    ])))),
                const SizedBox(height:15),
                const Align(alignment:Alignment.centerLeft,
                  child:Text('🎯 CHỌN TRÒ CHƠI',style:TextStyle(
                    color:navy,fontSize:21,fontWeight:FontWeight.w900))),
                const SizedBox(height:8),
              ]))),
            SliverPadding(padding:EdgeInsets.fromLTRB(wide?26:14,0,wide?26:14,30),
              sliver:SliverLayoutBuilder(builder:(context,sliverConstraints){
                final width=sliverConstraints.crossAxisExtent;
                final columns=width>1000?4:width>620?3:2;
                return SliverGrid.builder(itemCount:items.length,
                  gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:columns,crossAxisSpacing:12,mainAxisSpacing:12,
                    childAspectRatio:wide?1.35:1.03),
                  itemBuilder:(context,index){
                    final i=items[index];
                    final colors=[
                      const Color(0xFFFFB8E2),const Color(0xFFFFE59C),
                      const Color(0xFFB6E5FF),const Color(0xFFBFF2C1),
                      const Color(0xFFD8BFFF)];
                    final color=colors[i%colors.length];
                    return Material(color:Colors.transparent,
                      child:InkWell(borderRadius:BorderRadius.circular(25),
                        onTap:()=>Navigator.push(context,MaterialPageRoute(
                          builder:(_)=>LessonScreen(topic:topics[i]))),
                        child:Container(
                          decoration:BoxDecoration(
                            gradient:LinearGradient(begin:Alignment.topLeft,
                              end:Alignment.bottomRight,
                              colors:[Colors.white,color]),
                            borderRadius:BorderRadius.circular(25),
                            border:Border.all(color:Colors.white,width:3),
                            boxShadow:const [BoxShadow(color:Color(0x336E56A6),
                              blurRadius:10,offset:Offset(0,6))]),
                          child:Padding(padding:const EdgeInsets.all(11),
                            child:Column(children:[
                              Row(children:[
                                Container(padding:const EdgeInsets.symmetric(
                                  horizontal:9,vertical:4),
                                  decoration:BoxDecoration(color:violet,
                                    borderRadius:BorderRadius.circular(12)),
                                  child:Text('${i+1}',style:const TextStyle(
                                    color:Colors.white,fontWeight:FontWeight.w900))),
                                const Spacer(),
                                const Icon(Icons.stars_rounded,color:Color(0xFFFFA92F)),
                              ]),
                              Expanded(child:Center(child:Text(topics[i].emoji,
                                style:TextStyle(fontSize:wide?58:50)))),
                              FittedBox(fit:BoxFit.scaleDown,
                                child:Text(topics[i].title,style:const TextStyle(
                                  color:navy,fontSize:18,fontWeight:FontWeight.w900))),
                              const SizedBox(height:4),
                              const Text('CHƠI NGAY ▶',style:TextStyle(
                                color:violet,fontSize:10,fontWeight:FontWeight.w900)),
                            ]))),
                      )));
                  });
              })),
          ]),
        ]);
      })),
    );
  }
  Widget _score(String emoji,String value)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:12,vertical:10),
    decoration:BoxDecoration(color:const Color(0xFF7452D5),
      borderRadius:BorderRadius.circular(25),
      border:Border.all(color:Colors.white,width:2)),
    child:Text('$emoji $value',style:const TextStyle(
      color:Colors.white,fontSize:17,fontWeight:FontWeight.w900)));
  Widget _glossyPanel({required Widget child})=>Container(
    decoration:BoxDecoration(
      gradient:const LinearGradient(colors:[
        Color(0xFFFDF6FF),Color(0xFFE8D6FF)]),
      border:Border.all(color:Colors.white,width:3),
      borderRadius:BorderRadius.circular(27),
      boxShadow:const [BoxShadow(color:Color(0x336F4DAD),
        blurRadius:11,offset:Offset(0,6))]),
    child:child);
  void _help(BuildContext context)=>showDialog<void>(
    context:context,builder:(context)=>AlertDialog(
      title:const Text('⚙️ Bé Vui English'),
      content:const Text('Chạm vào trò chơi để học từ vựng. '
        'Trả lời đúng để nhận sao. Tiến độ được lưu trên thiết bị.'),
      actions:[TextButton(onPressed:()=>Navigator.pop(context),
        child:const Text('Đã hiểu'))]));
}
