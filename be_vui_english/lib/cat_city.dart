import 'dart:math';
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
  int stars = 0;
  int hearts = 3;
  String mood = 'happy';
  @override
  void initState() {
    super.initState();
    voice.setLanguage('en-US');
    voice.setSpeechRate(.42);
  }
  @override
  void dispose() { voice.stop(); super.dispose(); }
  Future<void> say(String text) async {
    await voice.stop();
    await voice.speak(text);
  }
  void openMission(String title, List<CatQuestion> questions) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) =>
      CatMissionScreen(title: title, questions: questions,
        onStar: () => setState(() => stars++))));
  }
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('🐱 Thành phố Bé Vui',
      style: TextStyle(fontWeight: FontWeight.w900)), actions: [
      Center(child: Padding(padding: const EdgeInsets.only(right: 18),
        child: Text('⭐ $stars', style: const TextStyle(fontSize: 18,
          fontWeight: FontWeight.bold)))),
    ]),
    body: ListView(padding: const EdgeInsets.all(16), children: [
      Container(padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(colors: [Color(0xFFB7E8FF), Color(0xFFE8D9FF)]),
          borderRadius: BorderRadius.circular(30)),
        child: Column(children: [
          const Text('🏙️  ☀️  🏡  🌳  🏬', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          const Text('🐱', style: TextStyle(fontSize: 100)),
          const Text('Xin chào! Mình là Mèo Bé Vui!',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20, color: _ink, fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          FilledButton.icon(onPressed: () => say('Hello! Let us explore the city!'),
            icon: const Icon(Icons.volume_up_rounded),
            label: const Text('🔊 Nghe mèo nói')),
        ])),
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
            onTap: () => openMission(item.$2, item.$4),
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
