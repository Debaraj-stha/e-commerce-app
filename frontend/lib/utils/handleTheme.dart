import 'package:flutter/material.dart';
import 'package:frontend/utils/constraints.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HandleTheme extends GetxController {
  final _sharedPreference = SharedPreferences.getInstance();
  final key = Constrains.themeKey;
  Future<void> saveTheme(String theme) async {
    final sp = await _sharedPreference;
    await sp.setString(key, theme);
  }

  Future<String> getSavedThemeValue() async {
    final sp = await _sharedPreference;
    String theme = sp.getString(key) ?? "light";
    print(theme);
    return theme;
  }

  Future<ThemeMode> getThememode() async {
    final String savedTheme = await getSavedThemeValue();
    switch (savedTheme) {
      case "light":
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  changeTheme(String theme) async {
    saveTheme(theme);
    Get.changeThemeMode(await getThememode());
    update();
  }
}
