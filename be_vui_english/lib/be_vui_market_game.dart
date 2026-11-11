import 'dart:math';
import 'be_vui_food_art.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

/// Interactive market scene: original Flutter-drawn UI, no borrowed game assets.
class BeVuiMarketGame extends StatefulWidget {
  final VoidCallback onEarnStar;
  final bool restaurant;
  const BeVuiMarketGame({super.key, required this.onEarnStar, this.restaurant = false});
  @override
  State<BeVuiMarketGame> createState() => _BeVuiMarketGameState();
}
class _MarketItem {
  final String name, vi;
  final Color color;
  const _MarketItem(this.name, this.vi, this.color);
}
const _items = [
  _MarketItem('apple','Táo',Color(0xFFFFD9E2)),
  _MarketItem('banana','Chuối',Color(0xFFFFEDB0)),
  _MarketItem('carrot','Cà rốt',Color(0xFFFFD8B8)),
  _MarketItem('fish','Cá',Color(0xFFC9F4FC)),
  _MarketItem('bread','Bánh mì',Color(0xFFFFE4BD)),
  _MarketItem('milk','Sữa',Color(0xFFD9E8FF)),
  _MarketItem('grapes','Nho',Color(0xFFE8D9FF)),
  _MarketItem('pizza','Pizza',Color(0xFFFFDBCE)),
];
class _BeVuiMarketGameState extends State<BeVuiMarketGame> {
  final voice = FlutterTts();
  final random = Random();
  int round = 0;
  int score = 0;
  bool answered = false;
  String feedback = '';
  late List<_MarketItem> choices;
  late _MarketItem target;
  @override
  void initState() {
    super.initState();
    voice.setLanguage('en-US');
    voice.setSpeechRate(.42);
    _nextRound();
    WidgetsBinding.instance.addPostFrameCallback((_) { if (mounted) _speak(); });
  }
  @override
  void dispose() { voice.stop(); super.dispose(); }
  void _nextRound() {
    choices = [...(widget.restaurant ? _items.where((item) =>
      const ['pizza','fish','bread','milk','apple','banana'].contains(item.name)) : _items)]..shuffle(random);
    choices = choices.take(4).toList();
    target = choices[random.nextInt(choices.length)];
  }
  Future<void> _speak() async {
    await voice.stop();
    await voice.speak(widget.restaurant
      ? 'I would like the ${target.name}, please.'
      : 'Please find the ${target.name}.');
  }
  void _pick(_MarketItem item) {
    if (answered) return;
    if (item.name == target.name) {
      widget.onEarnStar();
      setState(() { answered = true; score++; feedback = 'Chính xác! +1 sao ⭐'; });
      voice.speak('Excellent! ${target.name}!');
    } else {
      setState(() => feedback = 'Thử lại nhé! 💗');
      voice.speak('Try again!');
    }
  }
  void _continue() {
    if (round == 4) {
      showDialog<void>(context:context,builder:(context)=>AlertDialog(
        title:Text(widget.restaurant
          ? '🎉 Mèo đã dùng bữa!' : '🎉 Hoàn thành chuyến đi chợ!'),
        content:Text('Bé đã nhận $score ngôi sao. Giỏi lắm!'),
        actions:[FilledButton(onPressed:(){
          Navigator.pop(context); Navigator.pop(context);
        },child:const Text('Về thành phố'))],
      ));
      return;
    }
    setState(() { round++; answered = false; feedback = ''; _nextRound(); });
    _speak();
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor:const Color(0xFFFFF8EF),
    appBar:AppBar(title:Text(widget.restaurant ? '🍽️ Nhà hàng Bé Vui' : '🛒 Chợ Bé Vui',style:const TextStyle(
      fontWeight:FontWeight.w900)),backgroundColor:const Color(0xFFFFF8EF)),
    body:SafeArea(child:LayoutBuilder(builder:(context,limits)=>
      ListView(padding:const EdgeInsets.all(16),children:[
        Row(children:[
          Expanded(child:ClipRRect(borderRadius:BorderRadius.circular(12),
            child:LinearProgressIndicator(value:(round+1)/5,minHeight:12,
              backgroundColor:const Color(0xFFFFDFB5),
              color:const Color(0xFFFFA72C)))),
          const SizedBox(width:12),
          Text('${round+1}/5',style:const TextStyle(fontWeight:FontWeight.w900)),
          const SizedBox(width:12),
          Text('⭐ $score',style:const TextStyle(fontWeight:FontWeight.w900)),
        ]),
        const SizedBox(height:16),
        Container(height:190,decoration:BoxDecoration(
          gradient:const LinearGradient(colors:[
            Color(0xFF92DFFF),Color(0xFFD4F6E1)]),
          borderRadius:BorderRadius.circular(28)),
          child:Stack(children:[
            Positioned(left:0,right:0,bottom:0,child:Container(height:48,
              decoration:const BoxDecoration(color:Color(0xFF87D87B),
                borderRadius:BorderRadius.vertical(bottom:Radius.circular(28))))),
            const Positioned(top:8,left:12,child:Text('☀️',
              style:TextStyle(fontSize:37))),
            Positioned(top:35,right:10,child:Text(widget.restaurant ? '🍽️' : '🏪',
              style:const TextStyle(fontSize:112))),
            const Positioned(bottom:8,left:15,child:Text('🐱',
              style:TextStyle(fontSize:100))),
            Positioned(top:15,left:90,right:75,child:Container(
              padding:const EdgeInsets.all(10),
              decoration:BoxDecoration(color:Colors.white,
                borderRadius:BorderRadius.circular(20)),
              child:Text(widget.restaurant ? 'Let’s order food!' : 'Let’s go shopping!',
                textAlign:TextAlign.center,
                style:TextStyle(fontSize:15,fontWeight:FontWeight.w900,
                  color:Color(0xFF3B4675))))),
          ])),
        const SizedBox(height:16),
        Container(padding:const EdgeInsets.all(17),
          decoration:BoxDecoration(color:Colors.white,
            borderRadius:BorderRadius.circular(24),
            boxShadow:const [BoxShadow(color:Color(0x1B5E559A),
              blurRadius:16,offset:Offset(0,6))]),
          child:Column(children:[
            Text(widget.restaurant ? 'Mèo muốn gọi món nào?' : 'Mèo muốn mua món nào?',
              style:TextStyle(fontSize:17,fontWeight:FontWeight.w800)),
            const SizedBox(height:8),
            Text(widget.restaurant ? 'I want ${target.name}, please!' : 'Find the ${target.name}!',
              textAlign:TextAlign.center,
              style:const TextStyle(fontSize:27,fontWeight:FontWeight.w900,
                color:Color(0xFF6545C4))),
            const SizedBox(height:8),
            FilledButton.icon(onPressed:_speak,
              icon:const Icon(Icons.volume_up_rounded),
              label:const Text('Nghe mèo nói')),
          ])),
        const SizedBox(height:16),
        GridView.builder(shrinkWrap:true,
          physics:const NeverScrollableScrollPhysics(),
          itemCount:choices.length,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:2,crossAxisSpacing:12,mainAxisSpacing:12,
            childAspectRatio:1.17),
          itemBuilder:(context,index){
            final item=choices[index];
            final correct=answered&&item.name==target.name;
            return Material(color:correct?const Color(0xFFBBF0D1):item.color,
              borderRadius:BorderRadius.circular(24),
              child:InkWell(onTap:()=>_pick(item),
                borderRadius:BorderRadius.circular(24),
                child:Column(mainAxisAlignment:MainAxisAlignment.center,
                  children:[
                    BeVuiFoodArt(food:item.name),
                    Text(item.name,style:const TextStyle(
                      fontSize:19,fontWeight:FontWeight.w900,
                      color:Color(0xFF29375B))),
                    Text(item.vi,style:const TextStyle(
                      fontSize:13,color:Color(0xFF626D80))),
                    if(correct)const Icon(Icons.check_circle,
                      color:Color(0xFF19865B)),
                  ])));
          }),
        const SizedBox(height:14),
        Center(child:Text(feedback,style:const TextStyle(
          fontSize:18,fontWeight:FontWeight.w900,
          color:Color(0xFF6545C4)))),
        const SizedBox(height:12),
        SizedBox(height:56,child:FilledButton(
          onPressed:answered?_continue:null,
          style:FilledButton.styleFrom(backgroundColor:const Color(0xFFFF9E36)),
          child:Text(round==4?'Hoàn thành 🎉':'Tiếp tục ➜',
            style:const TextStyle(fontSize:18,fontWeight:FontWeight.w900)))),
      ]))),
  );
}
