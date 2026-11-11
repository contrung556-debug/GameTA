import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Single source of truth for local rewards and lesson progress.
class BeVuiProgress extends ChangeNotifier {
  BeVuiProgress._();
  static final BeVuiProgress instance=BeVuiProgress._();
  SharedPreferences? _prefs;
  int stars=0;
  int completedLessons=0;
  bool loaded=false;

  Future<void> load() async {
    if(loaded)return;
    _prefs=await SharedPreferences.getInstance();
    stars=_prefs!.getInt('be_vui_stars_v1') ?? 0;
    completedLessons=_prefs!.getInt('be_vui_lessons_v1') ?? 0;
    loaded=true;
    notifyListeners();
  }

  Future<void> earnStars(int amount) async {
    if(amount<=0)return;
    stars+=amount;
    notifyListeners();
    await _prefs?.setInt('be_vui_stars_v1',stars);
  }

  Future<void> completeLesson() async {
    completedLessons++;
    notifyListeners();
    await _prefs?.setInt('be_vui_lessons_v1',completedLessons);
  }
}
