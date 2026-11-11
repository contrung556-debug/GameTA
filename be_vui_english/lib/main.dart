import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() => runApp(const BeVuiEnglish());
class Topic {
  final String title, emoji;
  final List<String> words;
  const Topic(this.title, this.emoji, this.words);
}
const topics = <Topic>[
  Topic('Động vật','🐻',['Cat|🐱','Dog|🐶','Bird|🐦','Fish|🐟','Rabbit|🐰','Cow|🐮','Duck|🦆','Pig|🐷','Lion|🦁','Elephant|🐘']),
  Topic('Màu sắc','🌈',['Red|🔴','Blue|🔵','Green|🟢','Yellow|🟡','Orange|🟠','Purple|🟣','Black|⚫','White|⚪','Brown|🟤','Pink|🩷']),
  Topic('Trái cây','🍎',['Apple|🍎','Banana|🍌','Orange|🍊','Grapes|🍇','Watermelon|🍉','Strawberry|🍓','Pineapple|🍍','Peach|🍑','Pear|🍐','Mango|🥭']),
  Topic('Số đếm','🔢',['One|1️⃣','Two|2️⃣','Three|3️⃣','Four|4️⃣','Five|5️⃣','Six|6️⃣','Seven|7️⃣','Eight|8️⃣','Nine|9️⃣','Ten|🔟']),
  Topic('Gia đình','👨‍👩‍👧',['Mother|👩','Father|👨','Baby|👶','Sister|👧','Brother|👦','Grandmother|👵','Grandfather|👴','Family|👨‍👩‍👧‍👦','Girl|👧','Boy|👦']),
  Topic('Cơ thể','🖐️',['Head|🙂','Eye|👁️','Ear|👂','Nose|👃','Mouth|👄','Hand|✋','Foot|🦶','Leg|🦵','Tooth|🦷','Hair|💇']),
  Topic('Đồ chơi','🧸',['Ball|⚽','Teddy bear|🧸','Doll|🪆','Car|🚗','Train|🚂','Kite|🪁','Puzzle|🧩','Robot|🤖','Drum|🥁','Balloon|🎈']),
  Topic('Thức ăn','🥪',['Bread|🍞','Rice|🍚','Egg|🥚','Milk|🥛','Cheese|🧀','Cake|🍰','Soup|🍲','Pizza|🍕','Cookie|🍪','Carrot|🥕']),
  Topic('Phương tiện','🚗',['Car|🚗','Bus|🚌','Bike|🚲','Train|🚆','Plane|✈️','Boat|⛵','Ship|🚢','Taxi|🚕','Truck|🚚','Helicopter|🚁']),
  Topic('Trong nhà','🏠',['House|🏠','Door|🚪','Window|🪟','Bed|🛏️','Chair|🪑','Lamp|💡','Clock|🕒','Key|🔑','Book|📖','Television|📺'])
];
class BeVuiEnglish extends StatelessWidget {
  const BeVuiEnglish({super.key});
  @override Widget build(BuildContext context) => MaterialApp(
    title:'Bé Vui English',debugShowCheckedModeBanner:false,
    theme:ThemeData(colorScheme:ColorScheme.fromSeed(seedColor:const Color(0xff5cbdb3)),useMaterial3:true),
    home:const TopicScreen());
}
class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});
  @override Widget build(BuildContext context) => Scaffold(
    appBar:AppBar(title:const Text('🌟 Bé Vui English')),
    body:GridView.builder(padding:const EdgeInsets.all(16),itemCount:topics.length,
      gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount:2,mainAxisSpacing:12,crossAxisSpacing:12,childAspectRatio:1.12),
      itemBuilder:(context,i)=>Card(child:InkWell(
        onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>LessonScreen(topic:topics[i]))),
        child:Column(mainAxisAlignment:MainAxisAlignment.center,children:[
          Text(topics[i].emoji,style:const TextStyle(fontSize:44)),
          Text(topics[i].title,style:const TextStyle(fontSize:18,fontWeight:FontWeight.bold))
        ])))));
}
class LessonScreen extends StatefulWidget {
  final Topic topic;
  const LessonScreen({super.key,required this.topic});
  @override State<LessonScreen> createState()=>_LessonScreenState();
}
class _LessonScreenState extends State<LessonScreen> {
  final tts=FlutterTts();
  int index=0,stars=0;
  bool quiz=false,correct=false;
  List<String> choices=[];
  String word(String entry)=>entry.split('|')[0];
  String picture(String entry)=>entry.split('|')[1];
  @override void initState(){
    super.initState();
    tts.setLanguage('en-US');
    tts.setSpeechRate(0.42);
  }
  Future<void> speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }
  void beginQuiz(){
    final target=widget.topic.words[index];
    final others=widget.topic.words.where((w)=>w!=target).toList()..shuffle(Random());
    setState((){quiz=true;correct=false;choices=[target,...others.take(2)]..shuffle(Random());});
    speak('Find the ${word(target)}');
  }
  void choose(String selected){
    if(correct)return;
    if(selected==widget.topic.words[index]){
      setState((){correct=true;stars++;});
      speak('Great job!');
    }else{speak('Try again');}
  }
  void next(){
    if(index+1==widget.topic.words.length){Navigator.pop(context);return;}
    setState((){index++;quiz=false;correct=false;});
  }
  @override void dispose(){tts.stop();super.dispose();}
  @override Widget build(BuildContext context){
    final entry=widget.topic.words[index];
    return Scaffold(appBar:AppBar(title:Text(widget.topic.title)),
      body:SafeArea(child:Padding(padding:const EdgeInsets.all(18),child:Column(children:[
        LinearProgressIndicator(value:(index+1)/widget.topic.words.length),
        const SizedBox(height:16),
        Text('⭐ $stars   ${index+1}/${widget.topic.words.length}',style:const TextStyle(fontSize:20)),
        const Spacer(),
        if(!quiz)...[
          Text(picture(entry),style:const TextStyle(fontSize:110)),
          Text(word(entry),style:const TextStyle(fontSize:34,fontWeight:FontWeight.bold)),
          const SizedBox(height:20),
          FilledButton.icon(onPressed:()=>speak(word(entry)),icon:const Icon(Icons.volume_up),label:const Text('Nghe phát âm')),
        ]else...[
          const Text('Bé hãy chọn hình đúng!',style:TextStyle(fontSize:23)),
          OutlinedButton.icon(onPressed:()=>speak('Find the ${word(entry)}'),icon:const Icon(Icons.volume_up),label:const Text('Nghe lại')),
          ...choices.map((s)=>Padding(padding:const EdgeInsets.all(5),child:SizedBox(
            width:double.infinity,height:70,
            child:FilledButton.tonal(onPressed:correct?null:()=>choose(s),child:Text(picture(s),style:const TextStyle(fontSize:40))))),
          if(correct)const Text('🌟 Giỏi lắm!')
        ],
        const Spacer(),
        SizedBox(width:double.infinity,height:60,child:FilledButton(
          onPressed:quiz?(correct?next:null):beginQuiz,
          child:Text(quiz?'Tiếp tục':'Chơi thử 🎮')))
      ]))));
  }
}
