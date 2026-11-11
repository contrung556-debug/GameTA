import 'dart:math';
import 'be_vui_animated_city.dart';
import 'be_vui_3d_cat.dart';
import 'be_vui_school_room.dart';
import 'be_vui_progress.dart';
import 'be_vui_market_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

const _purple = Color(0xFF7957E8);
const _ink = Color(0xFF263454);

class CatCityScreen extends StatefulWidget {
  const CatCityScreen({super.key});
  @override
  State<CatCityScreen> createState() => _CatCityScreenState();
}

class _CatCityScreenState extends State<CatCityScreen> {
  final FlutterTts voice = FlutterTts();
  final progress = BeVuiProgress.instance;
  int hearts = 3;
  String? travelingTo;
  int tripNumber = 0;
  void travelTo(String title, List<CatQuestion> questions) {
    if (travelingTo != null) return;
    setState(() { travelingTo = title; tripNumber++; });
  }
  void arriveAt(String title, List<CatQuestion> questions) {
    if (!mounted || travelingTo != title) return;
    setState(() => travelingTo = null);
    if (title == 'Trường học') {
      openSchool();
    } else if (title == 'Chợ' || title == 'Siêu thị') {
      openMarket();
    } else if (title == 'Nhà hàng') {
      openRestaurant();
    } else {
      openMission(title, questions);
    }
  }
  @override
  void initState() {
    super.initState();
    progress.addListener(refreshProgress);
    progress.load();
    voice.setLanguage('en-US');
    voice.setSpeechRate(.42);
  }
  void refreshProgress() { if(mounted)setState(() {}); }
  void reward() { progress.earnStars(1); }
  @override
  void dispose() { progress.removeListener(refreshProgress); voice.stop(); super.dispose(); }
  Future<void> say(String text) async {
    await voice.stop();
    await voice.speak(text);
  }
  void openRestaurant() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
      BeVuiMarketGame(restaurant: true,
        onEarnStar: reward)));
  }
  void openSchool() {
    Navigator.of(context).push(MaterialPageRoute(builder: (schoolContext) =>
      BeVuiSchoolRoom(onStartLesson: () {
        Navigator.of(schoolContext).push(MaterialPageRoute(builder: (_) =>
          CatMissionScreen(title: 'Bài học ở trường',
            questions: challengeQuestions,
            onStar: reward)));
      })));
  }
  void openMarket() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
      BeVuiMarketGame(onEarnStar: reward)));
  }
  void openMission(String title, List<CatQuestion> questions) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
      CatMissionScreen(title: title, questions: questions,
        onStar: reward)));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('🐱 Thành phố Bé Vui',
      style: TextStyle(fontWeight: FontWeight.w900)), actions: [
      Center(child: Padding(padding: const EdgeInsets.only(right: 18),
        child: Text('⭐ ${progress.stars}', style: const TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold)))),
    ]),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Stack(children: [
        const BeVuiAnimatedCity(),
        Positioned.fill(child: LayoutBuilder(builder: (context, constraints) {
          Widget hotspot(double x, double y, String title,
              List<CatQuestion> questions) => Positioned(
            left: constraints.maxWidth * x - 20,
            top: constraints.maxHeight * y - 20,
            child: Semantics(label: 'Mở nhiệm vụ $title',
              button: true,
              child: Material(
                color: const Color(0xFF6E40CC),
                borderRadius: BorderRadius.circular(18),
                elevation: 7,
                shadowColor: const Color(0x886E40CC),
                child: InkWell(borderRadius: BorderRadius.circular(18),
                  onTap: () => travelTo(title, questions),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: Colors.white, width: 2)),
                    child: const Icon(Icons.play_arrow_rounded,
                      size: 21, color: Colors.white))))),
          );
          return Stack(children: [
            if (travelingTo != null)
              Positioned.fill(child: TweenAnimationBuilder<double>(
                key: ValueKey(tripNumber),
                tween: Tween(begin: 0, end: 1),
                duration: const Duration(milliseconds: 1200),
                curve: Curves.easeInOut,
                onEnd: () {
                  final destination = travelingTo;
                  if (destination == null) return;
                  final questions = switch (destination) {
                    'Trường học' => challengeQuestions,
                    'Bệnh viện' => bathQuestions,
                    'Siêu thị' || 'Chợ' => foodQuestions,
                    'Nhà hàng' => restaurantQuestions,
                    _ => challengeQuestions,
                  };
                  arriveAt(destination, questions);
                },
                builder: (context, progress, child) {
                  final target = switch (travelingTo) {
                    'Trường học' => const Offset(.23, .39),
                    'Bệnh viện' => const Offset(.50, .39),
                    'Siêu thị' => const Offset(.80, .38),
                    'Chợ' => const Offset(.18, .68),
                    'Nhà hàng' => const Offset(.81, .69),
                    _ => const Offset(.50, .50),
                  };
                  return Stack(children: [Positioned(
                    left: constraints.maxWidth * (.48 + (target.dx - .48) * progress) - 24,
                    top: constraints.maxHeight * (.82 + (target.dy - .82) * progress) - 24
                        - (progress * 12 * (1 - progress)),
                    child: IgnorePointer(child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: .9),
                        shape: BoxShape.circle),
                      child: const BeVui3DCat(size: 38)))),
                  ]);
                },
              )),
            hotspot(.23, .39, 'Trường học', challengeQuestions),
            hotspot(.50, .39, 'Bệnh viện', bathQuestions),
            hotspot(.80, .38, 'Siêu thị', foodQuestions),
            hotspot(.18, .68, 'Chợ', foodQuestions),
            hotspot(.81, .69, 'Nhà hàng', restaurantQuestions),
          ]);
        })),
      ]),
      const SizedBox(height: 8),
      const Text('👆 Chạm vào các điểm sáng trên bản đồ để vào địa điểm',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700,
          color: Color(0xFF58617E))),
      const SizedBox(height: 10),
      Container(padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(color: const Color(0xFFE8DFFF),
          borderRadius: BorderRadius.circular(22)),
        child: Row(children: [
          const Expanded(child: Text('🐾 Cùng Mèo Bé Vui khám phá thành phố!',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900,
              color: _ink))),
          IconButton.filled(onPressed: () => say('Hello! Let us explore the city!'),
            icon: const Icon(Icons.volume_up_rounded)),
        ])),
      Text('🏆 Đã hoàn thành: ${progress.completedLessons} bài học',
        style: const TextStyle(fontWeight: FontWeight.w800,color:_purple)),
      const SizedBox(height: 20),
      const Text('Chăm sóc mèo 💗', style: TextStyle(fontSize: 22,
        color: _ink, fontWeight: FontWeight.w900)),
      const SizedBox(height: 12),
      Row(children: [
        _care('🍽️', 'Cho ăn', 'I am hungry!', () => openMission('Cho mèo ăn', foodQuestions)),
        _care('🛁', 'Đi tắm', 'I need a bath!', () => openMission('Tắm cho mèo', bathQuestions)),
        _care('🛏️', 'Đi ngủ', 'I am sleepy!', () => openMission('Cho mèo ngủ', sleepQuestions)),
      ]),
      const SizedBox(height: 12),
      Row(children: [
        _care('🚽', 'Vệ sinh', 'Go to the toilet.', () => openMission('Đi vệ sinh', toiletQuestions)),
        _care('👕', 'Thay đồ', 'Put on a shirt.', () => openMission('Thay quần áo', clothesQuestions)),
        _care('🎯', 'Vượt màn', 'Let us play!', () => openMission('Thử thách tiếng Anh', challengeQuestions)),
      ]),
      const SizedBox(height: 25),
      const Text('Khám phá khu phố 🗺️', style: TextStyle(fontSize: 22,
        color: _ink, fontWeight: FontWeight.w900)),
      const SizedBox(height: 8),
      const Text('Chạm vào địa điểm để làm nhiệm vụ tiếng Anh.'),
      const SizedBox(height: 12),
      ...[
        ('🛒', 'Chợ & siêu thị', 'Market', foodQuestions, const Color(0xFFFFE6D0)),
        ('🍕', 'Nhà hàng', 'Restaurant', restaurantQuestions, const Color(0xFFFFDCE8)),
        ('🌳', 'Công viên', 'Park', parkQuestions, const Color(0xFFD9F5DF)),
        ('🚗', 'Đường phố', 'Street', transportQuestions, const Color(0xFFD8EDFF)),
        ('🏬', 'Trung tâm thương mại', 'Shopping mall', clothesQuestions, const Color(0xFFE9E0FF)),
        ('🎣', 'Hồ câu cá', 'Fishing pond', fishingQuestions, const Color(0xFFD7F7F9)),
        ('🏫', 'Trường học', 'School', challengeQuestions, const Color(0xFFFFF0C6)),
      ].map((item) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Material(color: item.$5, borderRadius: BorderRadius.circular(22),
          child: InkWell(borderRadius: BorderRadius.circular(22),
            onTap: () {
              if (item.$2 == 'Chợ & siêu thị') {
                openMarket();
              } else if (item.$2 == 'Nhà hàng') {
                openRestaurant();
              } else if (item.$2 == 'Trường học') {
                openSchool();
              } else {
                openMission(item.$2, item.$4);
              }
            },
            child: Padding(padding: const EdgeInsets.all(16),
              child: Row(children: [
                Text(item.$1, style: const TextStyle(fontSize: 43)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$2, style: const TextStyle(color: _ink,
                      fontSize: 18, fontWeight: FontWeight.w900)),
                    Text(item.$3, style: const TextStyle(color: Color(0xFF6B7186))),
                  ])),
                const Icon(Icons.arrow_forward_ios_rounded, color: _purple),
              ]))))),
      ),
    ]),
  );
  Widget _care(String emoji, String label, String english, VoidCallback tap) =>
    Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Material(color: Colors.white, borderRadius: BorderRadius.circular(20),
        child: InkWell(onTap: tap, borderRadius: BorderRadius.circular(20),
          child: Padding(padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 3),
            child: Column(children: [
              Text(emoji, style: const TextStyle(fontSize: 35)),
              const SizedBox(height: 5),
              Text(label, style: const TextStyle(fontWeight: FontWeight.w800,
                fontSize: 12, color: _ink)),
            ]))))));
}

class CatQuestion {
  final String prompt;
  final String answer;
  final List<String> options;
  const CatQuestion(this.prompt, this.answer, this.options);
}
const foodQuestions = [
  CatQuestion('I want fish!', '🐟 Fish', ['🐟 Fish', '🍎 Apple', '🥛 Milk', '🍌 Banana']),
  CatQuestion('I want milk!', '🥛 Milk', ['🍞 Bread', '🥛 Milk', '🍕 Pizza', '🍎 Apple']),
  CatQuestion('I want an apple!', '🍎 Apple', ['🍌 Banana', '🍇 Grapes', '🍎 Apple', '🥕 Carrot']),
];
const bathQuestions = [
  CatQuestion('Find the soap!', '🧼 Soap', ['🧼 Soap', '🧸 Teddy bear', '🍎 Apple', '👟 Shoes']),
  CatQuestion('Find the towel!', '🧻 Towel', ['🪑 Chair', '🧻 Towel', '🚗 Car', '🍌 Banana']),
];
const sleepQuestions = [
  CatQuestion('Find the bed!', '🛏️ Bed', ['🪑 Chair', '🚪 Door', '🛏️ Bed', '📚 Books']),
  CatQuestion('Turn off the light!', '💡 Light', ['🧸 Teddy bear', '💡 Light', '🍎 Apple', '👕 Shirt']),
];
const toiletQuestions = [
  CatQuestion('Find the toilet!', '🚽 Toilet', ['🛏️ Bed', '🚽 Toilet', '🛁 Bathtub', '🪑 Chair']),
  CatQuestion('Wash your hands!', '🧼 Soap', ['🧼 Soap', '🚌 Bus', '🍎 Apple', '🎩 Hat']),
];
const clothesQuestions = [
  CatQuestion('I want a shirt!', '👕 Shirt', ['👟 Shoes', '👕 Shirt', '👒 Hat', '👗 Dress']),
  CatQuestion('Find the shoes!', '👟 Shoes', ['👗 Dress', '👒 Hat', '👟 Shoes', '👕 Shirt']),
];
const restaurantQuestions = [
  CatQuestion('I want pizza!', '🍕 Pizza', ['🍕 Pizza', '🍌 Banana', '🥕 Carrot', '🍇 Grapes']),
  CatQuestion('I want bread!', '🍞 Bread', ['🥛 Milk', '🍎 Apple', '🍞 Bread', '🐟 Fish']),
];
const parkQuestions = [
  CatQuestion('Find the tree!', '🌳 Tree', ['🌷 Flower', '🌳 Tree', '🚗 Car', '🏠 House']),
  CatQuestion('Find the ball!', '⚽ Ball', ['🐟 Fish', '🍎 Apple', '⚽ Ball', '📚 Books']),
];
const transportQuestions = [
  CatQuestion('Find the bus!', '🚌 Bus', ['🚗 Car', '🚌 Bus', '🚲 Bike', '✈️ Plane']),
  CatQuestion('Find the car!', '🚗 Car', ['🚂 Train', '🚲 Bike', '🚗 Car', '⛵ Boat']),
];
const fishingQuestions = [
  CatQuestion('Find the fish!', '🐟 Fish', ['🦆 Duck', '🐟 Fish', '🐱 Cat', '🦋 Butterfly']),
  CatQuestion('Find the boat!', '⛵ Boat', ['🚗 Car', '⛵ Boat', '🚌 Bus', '🚲 Bike']),
];
const challengeQuestions = [
  CatQuestion('Find the lion!', '🦁 Lion', ['🐰 Rabbit', '🦁 Lion', '🐱 Cat', '🐶 Dog']),
  CatQuestion('Find the red color!', '🔴 Red', ['🔵 Blue', '🟢 Green', '🔴 Red', '🟡 Yellow']),
  CatQuestion('Find the apple!', '🍎 Apple', ['🍌 Banana', '🍎 Apple', '🍇 Grapes', '🍉 Watermelon']),
];

class CatMissionScreen extends StatefulWidget {
  final String title;
  final List<CatQuestion> questions;
  final VoidCallback onStar;
  const CatMissionScreen({super.key, required this.title,
    required this.questions, required this.onStar});
  @override
  State<CatMissionScreen> createState() => _CatMissionScreenState();
}
class _CatMissionScreenState extends State<CatMissionScreen> {
  final voice = FlutterTts();
  int index = 0;
  bool solved = false;
  String feedback = '';
  late List<String> options;
  @override
  void initState() {
    super.initState();
    voice.setLanguage('en-US');
    voice.setSpeechRate(.42);
    options = [...widget.questions.first.options]..shuffle(Random());
  }
  @override
  void dispose() { voice.stop(); super.dispose(); }
  Future<void> say(String words) async {
    await voice.stop();
    await voice.speak(words);
  }
  void select(String choice) {
    if (solved) return;
    if (choice == widget.questions[index].answer) {
      widget.onStar();
      setState(() { solved = true; feedback = '🌟 Giỏi lắm! +1 sao'; });
      say('Great job!');
    } else {
      setState(() => feedback = 'Thử lại nhé! 💗');
      say('Try again!');
    }
  }
  void next() {
    if (index + 1 == widget.questions.length) {
      Navigator.pop(context);
      return;
    }
    setState(() {
      index++;
      solved = false;
      feedback = '';
      options = [...widget.questions[index].options]..shuffle(Random());
    });
    say(widget.questions[index].prompt);
  }
  @override
  Widget build(BuildContext context) {
    final q = widget.questions[index];
    return Scaffold(
      appBar: AppBar(title: Text(widget.title,
        style: const TextStyle(fontWeight: FontWeight.w900))),
      body: SafeArea(child: Padding(padding: const EdgeInsets.all(18),
        child: Column(children: [
          Row(children: [
            Text('Nhiệm vụ ${index + 1}/${widget.questions.length}',
              style: const TextStyle(fontWeight: FontWeight.w800, color: _ink)),
            const Spacer(), const Text('🐱 ⭐', style: TextStyle(fontSize: 23)),
          ]),
          const SizedBox(height: 12),
          LinearProgressIndicator(value: (index + 1) / widget.questions.length,
            minHeight: 9, color: _purple,
            backgroundColor: const Color(0xFFE9E0FF)),
          const SizedBox(height: 16),
          Container(width: double.infinity, padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: const Color(0xFFE7E0FF),
              borderRadius: BorderRadius.circular(24)),
            child: Column(children: [
              const Text('🐱', style: TextStyle(fontSize: 75)),
              const SizedBox(height: 8),
              Text(q.prompt, textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 26,
                  fontWeight: FontWeight.w900, color: _ink)),
              const SizedBox(height: 10),
              FilledButton.icon(onPressed: () => say(q.prompt),
                icon: const Icon(Icons.volume_up_rounded),
                label: const Text('Nghe mèo nói')),
            ])),
          const SizedBox(height: 18),
          const Text('Bé chọn hình đúng nhé!', style: TextStyle(
            fontSize: 19, fontWeight: FontWeight.w800, color: _ink)),
          const SizedBox(height: 12),
          Expanded(child: GridView.builder(
            itemCount: options.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 12,
              mainAxisSpacing: 12, childAspectRatio: 1.12),
            itemBuilder: (context, i) {
              final option = options[i];
              final parts = option.split(' ');
              return Material(
                color: solved && option == q.answer
                  ? const Color(0xFFD6F6E8) : Colors.white,
                borderRadius: BorderRadius.circular(24),
                child: InkWell(onTap: () => select(option),
                  borderRadius: BorderRadius.circular(24),
                  child: Column(mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(parts.first, style: const TextStyle(fontSize: 52)),
                      const SizedBox(height: 8),
                      Text(parts.skip(1).join(' '), textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 17,
                          fontWeight: FontWeight.w900, color: _ink)),
                    ])),
              );
            })),
          Text(feedback, style: const TextStyle(fontSize: 18,
            color: _purple, fontWeight: FontWeight.w900)),
          const SizedBox(height: 10),
          SizedBox(width: double.infinity, height: 58,
            child: FilledButton(
              onPressed: solved ? next : null,
              child: Text(index + 1 == widget.questions.length
                ? 'Hoàn thành 🎉' : 'Tiếp tục ➜',
                style: const TextStyle(fontSize: 18,
                  fontWeight: FontWeight.w900)))),
        ]))),
    );
  }
}
