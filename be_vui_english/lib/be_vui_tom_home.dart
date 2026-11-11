import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'main.dart' show TopicScreen;

/// Pixel-aligned interactive overlay for the approved Bé Vui cat home artwork.
/// Asset: assets/images/tom_home.jpg (included in downloadable integration kit).
class BeVuiTomHome extends StatefulWidget {
  const BeVuiTomHome({super.key});
  @override
  State<BeVuiTomHome> createState() => _BeVuiTomHomeState();
}

class _BeVuiTomHomeState extends State<BeVuiTomHome> {
  final FlutterTts tts = FlutterTts();
  int stars = 0;
  void _go(String item) {
    if (item == 'Học tập' || item == 'Chơi ngay') {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const TopicScreen()));
    } else if (item == 'Mèo nói') {
      tts.setLanguage('en-US');
      tts.setSpeechRate(0.43);
      tts.speak("Hi! I'm your English cat. Let's learn English together!");
    } else {
      showDialog<void>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text(item),
          content: Text(item == 'Thành tích'
              ? '⭐ Bạn có $stars ngôi sao.'
              : 'Chức năng đang được hoàn thiện.'),
          actions: [TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Đóng'))],
        ),
      );
    }
  }

  @override
  void dispose() {
    tts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF70C9F6),
      body: Center(
        child: AspectRatio(
          aspectRatio: 1672 / 941,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                'assets/images/tom_home.jpg',
                fit: BoxFit.fill,
                errorBuilder: (context, error, stack) => const Center(
                  child: Text('Thiếu hình nền: assets/images/tom_home.jpg',
                    textAlign: TextAlign.center),
                ),
              ),
              _hit('Học tập', .725, .125, .25, .12),
              _hit('Nhiệm vụ', .725, .251, .25, .104),
              _hit('Chăm sóc mèo', .725, .355, .25, .11),
              _hit('Trò chơi', .725, .465, .25, .105),
              _hit('Cửa hàng', .725, .570, .25, .105),
              _hit('Thành tích', .725, .675, .25, .105),
              _hit('Cài đặt', .725, .780, .25, .110),
              _hit('Chơi ngay', .420, .750, .300, .170),
              _hit('Mèo nói', .440, .550, .110, .110),
            ],
          ),
        ),
      ),
    );
  }

  Widget _hit(String label, double x, double y, double w, double h) {
    return Positioned(
      left: 0, top: 0, right: 0, bottom: 0,
      child: LayoutBuilder(builder: (context, constraints) => Stack(children: [
        Positioned(
          left: constraints.maxWidth * x,
          top: constraints.maxHeight * y,
          width: constraints.maxWidth * w,
          height: constraints.maxHeight * h,
          child: Semantics(
            label: label,
            button: true,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(22),
                splashColor: Colors.white24,
                onTap: () => _go(label),
              ),
            ),
          ),
        ),
      ])),
    );
  }
}
