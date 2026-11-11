import 'dart:math';
import 'cat_city.dart';
import 'be_vui_progress.dart';
import 'be_vui_3d_cat.dart';
import 'be_vui_game_hub.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BeVuiProgress.instance.load();
  runApp(const BeVuiEnglish());
}

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

const cream = Color(0xFFFFF9EF);
const ink = Color(0xFF263454);
const purple = Color(0xFF7957E8);
const pink = Color(0xFFFFDBE5);
const mint = Color(0xFFD6F6E8);
const peach = Color(0xFFFFE7CE);
const lavender = Color(0xFFE7E0FF);

class BeVuiEnglish extends StatelessWidget {
  const BeVuiEnglish({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Bé Vui English',
    theme: ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: cream,
      colorScheme: ColorScheme.fromSeed(seedColor: purple),
      fontFamily: 'Roboto',
      appBarTheme: const AppBarTheme(backgroundColor: cream, foregroundColor: ink),
    ),
    home: const BeVuiGameHub(),
  );
}

class TopicScreen extends StatelessWidget {
  const TopicScreen({super.key});
  static const tiles=[Color(0xFFFFE4EF),Color(0xFFDEF8EC),Color(0xFFE9E4FF),Color(0xFFFFEBCF),Color(0xFFDFF2FF)];
  @override
  Widget build(BuildContext context)=>Scaffold(
    backgroundColor:const Color(0xFFFFFBF4),
    body:SafeArea(child:CustomScrollView(slivers:[
      SliverToBoxAdapter(child:Padding(padding:const EdgeInsets.fromLTRB(20,18,20,8),
        child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
          const Row(children:[
            BeVui3DCat(size:54),
            SizedBox(width:12),
            Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
              Text('BÉ VUI ENGLISH',style:TextStyle(color:purple,fontSize:12,fontWeight:FontWeight.w900,letterSpacing:1.2)),
              Text('Chào mừng bé trở lại! ✨',style:TextStyle(color:ink,fontSize:18,fontWeight:FontWeight.w900)),
            ])),
            Icon(Icons.auto_awesome_rounded,color:purple,size:26),
          ]),
          const SizedBox(height:22),
          Container(width:double.infinity,
            decoration:BoxDecoration(
              gradient:const LinearGradient(colors:[Color(0xFF7352DE),Color(0xFFA777ED)]),
              borderRadius:BorderRadius.circular(30),
              boxShadow:const [BoxShadow(color:Color(0x337654D8),blurRadius:20,offset:Offset(0,9))]),
            child:ClipRRect(borderRadius:BorderRadius.circular(30),
              child:Stack(children:[
                Positioned(top:-42,right:-35,child:Container(width:170,height:170,
                  decoration:BoxDecoration(shape:BoxShape.circle,color:Colors.white.withValues(alpha:.10)))),
                Padding(padding:const EdgeInsets.fromLTRB(20,24,12,24),
                  child:Row(children:[
                    const Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                      Text('HÀNH TRÌNH TIẾNG ANH',style:TextStyle(color:Color(0xFFEFE6FF),fontSize:11,fontWeight:FontWeight.w900)),
                      SizedBox(height:9),
                      Text('Học vui mỗi ngày!',style:TextStyle(color:Colors.white,fontSize:25,fontWeight:FontWeight.w900,height:1.1)),
                      SizedBox(height:10),
                      Text('Khám phá thành phố cùng Mèo Bé Vui nhé!',style:TextStyle(color:Colors.white,fontSize:13,height:1.5)),
                    ])),
                    Container(width:118,height:138,
                      decoration:BoxDecoration(color:Colors.white.withValues(alpha:.16),borderRadius:BorderRadius.circular(25)),
                      child:const Center(child:BeVui3DCat(size:112))),
                  ])),
              ]))),
          const SizedBox(height:17),
          AnimatedBuilder(animation:BeVuiProgress.instance,builder:(context,_)=>Row(children:[
            Expanded(child:_stat('⭐','Ngôi sao',BeVuiProgress.instance.stars.toString(),const Color(0xFFFFF1D3))),
            const SizedBox(width:12),
            Expanded(child:_stat('🏆','Bài đã học',BeVuiProgress.instance.completedLessons.toString(),const Color(0xFFE7F7EF))),
          ])),
          const SizedBox(height:17),
          Material(color:const Color(0xFFFFA64E),borderRadius:BorderRadius.circular(22),
            child:InkWell(borderRadius:BorderRadius.circular(22),
              onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>const CatCityScreen())),
              child:const Padding(padding:EdgeInsets.symmetric(horizontal:17,vertical:18),
                child:Row(children:[
                  Icon(Icons.location_city_rounded,color:Colors.white,size:30),
                  SizedBox(width:12),
                  Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                    Text('Vào thành phố Bé Vui',style:TextStyle(color:Colors.white,fontSize:17,fontWeight:FontWeight.w900)),
                    SizedBox(height:3),
                    Text('Khám phá • Học tập • Nhận sao',style:TextStyle(color:Colors.white,fontSize:12)),
                  ])),
                  Icon(Icons.arrow_forward_ios_rounded,color:Colors.white,size:18),
                ])))),
          const SizedBox(height:26),
          const Text('Khám phá bài học 📚',style:TextStyle(color:ink,fontSize:23,fontWeight:FontWeight.w900)),
          const SizedBox(height:5),
          const Text('10 chủ đề thú vị đang chờ bé!',style:TextStyle(color:Color(0xFF737B92),fontSize:14)),
        ]))),
      SliverPadding(padding:const EdgeInsets.fromLTRB(18,14,18,32),
        sliver:SliverGrid.builder(itemCount:topics.length,
          gridDelegate:const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount:2,crossAxisSpacing:13,mainAxisSpacing:13,childAspectRatio:.92),
          itemBuilder:(context,i)=>Material(color:tiles[i%tiles.length],borderRadius:BorderRadius.circular(24),
            child:InkWell(borderRadius:BorderRadius.circular(24),
              onTap:()=>Navigator.push(context,MaterialPageRoute(builder:(_)=>LessonScreen(topic:topics[i]))),
              child:Padding(padding:const EdgeInsets.all(13),
                child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
                  Row(children:[
                    Container(padding:const EdgeInsets.symmetric(horizontal:9,vertical:5),
                      decoration:BoxDecoration(color:Colors.white.withValues(alpha:.8),borderRadius:BorderRadius.circular(12)),
                      child:Text((i+1).toString().padLeft(2,'0'),style:const TextStyle(color:purple,fontSize:11,fontWeight:FontWeight.w900))),
                    const Spacer(),
                    const Icon(Icons.north_east_rounded,color:purple,size:19),
                  ]),
                  Expanded(child:Center(child:Text(topics[i].emoji,style:const TextStyle(fontSize:56)))),
                  Text(topics[i].title,maxLines:1,overflow:TextOverflow.ellipsis,
                    style:const TextStyle(color:ink,fontSize:17,fontWeight:FontWeight.w900)),
                  const SizedBox(height:5),
                  const Text('10 từ • Nghe & chọn',maxLines:1,overflow:TextOverflow.ellipsis,
                    style:TextStyle(color:Color(0xFF656D83),fontSize:11,fontWeight:FontWeight.w600)),
                ]))))),
      ),
    ])),
  );
  Widget _stat(String emoji,String label,String value,Color color)=>Container(
    padding:const EdgeInsets.symmetric(horizontal:13,vertical:14),
    decoration:BoxDecoration(color:color,borderRadius:BorderRadius.circular(21)),
    child:Row(children:[
      Text(emoji,style:const TextStyle(fontSize:26)),
      const SizedBox(width:9),
      Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,children:[
        Text(value,style:const TextStyle(color:ink,fontSize:21,fontWeight:FontWeight.w900)),
        Text(label,style:const TextStyle(color:Color(0xFF667087),fontSize:11,fontWeight:FontWeight.w700)),
      ])),
    ]));
}

class LessonScreen extends StatefulWidget {
  final Topic topic;
  const LessonScreen({super.key, required this.topic});
  @override
  State<LessonScreen> createState() => _LessonScreenState();
}

class _LessonScreenState extends State<LessonScreen> {
  final tts = FlutterTts();
  int index = 0, stars = 0;
  bool quiz = false, correct = false;
  List<String> choices = [];
  String word(String entry) => entry.split('|')[0];
  String picture(String entry) => entry.split('|')[1];

  @override
  void initState() {
    super.initState();
    tts.setLanguage('en-US');
    tts.setSpeechRate(0.42);
  }
  Future<void> speak(String text) async {
    await tts.stop();
    await tts.speak(text);
  }
  void beginQuiz() {
    final target = widget.topic.words[index];
    final others = widget.topic.words.where((w) => w != target).toList()
      ..shuffle(Random());
    setState(() {
      quiz = true;
      correct = false;
      choices = [target, ...others.take(2)]..shuffle(Random());
    });
    speak('Find the ${word(target)}');
  }
  void choose(String selected) {
    if (correct) return;
    if (selected == widget.topic.words[index]) {
      setState(() { correct = true; stars++; });
      BeVuiProgress.instance.earnStars(1);
      speak('Great job!');
    } else {
      speak('Try again');
    }
  }
  void next() {
    if (index + 1 == widget.topic.words.length) {
      BeVuiProgress.instance.completeLesson();
      Navigator.pop(context);
      return;
    }
    setState(() { index++; quiz = false; correct = false; });
  }
  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final entry = widget.topic.words[index];
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.topic.title,
          style: const TextStyle(fontWeight: FontWeight.w900)),
        actions: [Padding(
          padding: const EdgeInsets.only(right: 18),
          child: Center(child: Text('⭐ $stars',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        )],
      ),
      body: SafeArea(child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 22),
        child: Column(children: [
          Row(children: [
            Text('Bài ${index + 1}/${widget.topic.words.length}',
              style: const TextStyle(color: ink, fontWeight: FontWeight.w800)),
            const Spacer(),
            Text(quiz ? '🎯 Thử tài' : '📖 Học từ mới',
              style: const TextStyle(color: purple, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 12),
          ClipRRect(borderRadius: BorderRadius.circular(12),
            child: LinearProgressIndicator(
              value: (index + 1) / widget.topic.words.length,
              minHeight: 10, backgroundColor: lavender,
              valueColor: const AlwaysStoppedAnimation(purple))),
          const SizedBox(height: 22),
          Expanded(child: Container(
            width: double.infinity,
            decoration: BoxDecoration(color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: const [BoxShadow(color: Color(0x0D3A2C69),
                blurRadius: 22, offset: Offset(0, 10))]),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: quiz
                ? Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text('Bé chọn hình đúng nhé! 🎯',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ink, fontSize: 22,
                        fontWeight: FontWeight.w900)),
                    const SizedBox(height: 16),
                    OutlinedButton.icon(
                      onPressed: () => speak('Find the ${word(entry)}'),
                      icon: const Icon(Icons.volume_up_rounded),
                      label: Text('Nghe: ${word(entry)}')),
                    const SizedBox(height: 12),
                    ...choices.map((s) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: SizedBox(width: double.infinity, height: 78,
                        child: FilledButton.tonal(
                          style: FilledButton.styleFrom(
                            backgroundColor: correct && s == entry ? mint : lavender,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20))),
                          onPressed: correct ? null : () => choose(s),
                          child: Text(picture(s),
                            style: const TextStyle(fontSize: 45))))),
                    ),
                    if (correct) const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text('🌟 Giỏi lắm!',
                        style: TextStyle(fontSize: 23, color: purple,
                          fontWeight: FontWeight.w900))),
                  ])
                : Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Container(
                      width: 210, height: 210,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFF2E5), shape: BoxShape.circle),
                      child: Text(picture(entry),
                        style: const TextStyle(fontSize: 110))),
                    const SizedBox(height: 25),
                    Text(word(entry),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: ink,
                        fontSize: 36, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 20),
                    FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: mint, foregroundColor: ink,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 16)),
                      onPressed: () => speak(word(entry)),
                      icon: const Icon(Icons.volume_up_rounded),
                      label: const Text('Nghe phát âm 🔊',
                        style: TextStyle(fontWeight: FontWeight.w800))),
                  ]),
            ),
          )),
          const SizedBox(height: 18),
          SizedBox(width: double.infinity, height: 62,
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: purple,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22))),
              onPressed: quiz ? (correct ? next : null) : beginQuiz,
              child: Text(quiz
                ? (index + 1 == widget.topic.words.length ? 'Hoàn thành 🎉' : 'Tiếp tục ➜')
                : 'Chơi thử nào! 🎮',
                style: const TextStyle(fontSize: 19,
                  fontWeight: FontWeight.w900))),
          ),
        ]),
      )),
    );
  }
}
