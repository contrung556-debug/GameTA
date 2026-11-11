import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:be_vui_english/be_vui_progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('stars and completed lessons persist in device preferences', () async {
    SharedPreferences.setMockInitialValues({
      'be_vui_stars_v1': 7,
      'be_vui_lessons_v1': 2,
    });
    final progress=BeVuiProgress.instance;
    await progress.load();
    expect(progress.stars,7);
    expect(progress.completedLessons,2);
    await progress.earnStars(3);
    await progress.completeLesson();
    expect(progress.stars,10);
    expect(progress.completedLessons,3);
    final prefs=await SharedPreferences.getInstance();
    expect(prefs.getInt('be_vui_stars_v1'),10);
    expect(prefs.getInt('be_vui_lessons_v1'),3);
    await progress.earnStars(0);
    expect(progress.stars,10);
  });
}
