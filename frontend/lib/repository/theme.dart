import 'package:flutter/material.dart';
import 'package:frontend/resources/appColors.dart';
import 'package:get/get.dart';

class Themes extends GetxController {
  final darkTheme = ThemeData(
      primaryColor: AppColors.primary,
      searchBarTheme: SearchBarThemeData(
          hintStyle: MaterialStatePropertyAll<TextStyle>(
            TextStyle(color: AppColors.third),
          ),
          backgroundColor: MaterialStatePropertyAll(AppColors.secondary)),
      checkboxTheme: CheckboxThemeData(
          // side: BorderSide(color: AppColors.third),
          materialTapTargetSize: MaterialTapTargetSize.padded,
          checkColor: MaterialStateProperty.all(AppColors.textColorPrimary),
          fillColor: MaterialStatePropertyAll(AppColors.third)),
      primaryColorLight: AppColors.secondary,
      scaffoldBackgroundColor: AppColors.primary,
      bottomAppBarTheme: BottomAppBarTheme(color: AppColors.primary),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.primary,
          unselectedIconTheme: IconThemeData(color: AppColors.primary),
          selectedIconTheme: IconThemeData(color: AppColors.secondary),
          selectedItemColor: AppColors.textColorPrimary),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.secondary,
      ),
      listTileTheme: ListTileThemeData(
        textColor: AppColors.textColorPrimary,
      ),
      expansionTileTheme:
          ExpansionTileThemeData(iconColor: AppColors.textColorPrimary),
      brightness: Brightness.dark,
      textButtonTheme: TextButtonThemeData(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(AppColors.third),
              iconColor: MaterialStatePropertyAll(AppColors.textColorPrimary),
              textStyle: MaterialStateProperty.all<TextStyle>(
                  TextStyle(color: AppColors.primary)))),
      iconButtonTheme: IconButtonThemeData(
          style: ButtonStyle(
              backgroundColor:
                  MaterialStatePropertyAll(AppColors.textColorPrimary),
              iconColor: MaterialStateProperty.all(AppColors.third))),
      iconTheme: IconThemeData(color: AppColors.primary),
      primaryTextTheme: TextTheme(
          titleMedium: const TextStyle(color: Colors.green),
          headlineLarge: TextStyle(
              color: AppColors.textColorPrimary, fontFamily: "Roboto"),
          headlineMedium: TextStyle(
              color: AppColors.textColorPrimary, fontFamily: "Roboto"),
          headlineSmall: TextStyle(
              color: AppColors.textColorPrimary, fontFamily: "Roboto"),
          bodyMedium: TextStyle(
              color: AppColors.textColorPrimary,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w600),
          titleSmall: TextStyle(
            color: AppColors.textColorPrimary,
            fontFamily: "Roboto",
          ),
          bodyLarge: TextStyle(
              color: AppColors.textColorPrimary,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w700),
          bodySmall: TextStyle(
              color: AppColors.textColorPrimary,
              fontFamily: "Roboto",
              fontWeight: FontWeight.w500)));

  final lightTheme = ThemeData(
    primaryColor: AppColors.secondary,
    radioTheme:
        RadioThemeData(fillColor: MaterialStateProperty.all(AppColors.primary)),
    checkboxTheme: CheckboxThemeData(
        side: BorderSide(color: AppColors.third),
        materialTapTargetSize: MaterialTapTargetSize.padded,
        checkColor: MaterialStateProperty.all(AppColors.primary),
        fillColor: MaterialStatePropertyAll(AppColors.secondary)),
    primaryColorLight: AppColors.secondary,
    scaffoldBackgroundColor: AppColors.secondary,
    searchBarTheme: SearchBarThemeData(
        hintStyle: MaterialStatePropertyAll<TextStyle>(
          TextStyle(color: AppColors.third),
        ),
        backgroundColor: MaterialStatePropertyAll(AppColors.secondary)),
    bottomAppBarTheme: BottomAppBarTheme(color: AppColors.primary),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: AppColors.secondary,
        unselectedIconTheme: IconThemeData(color: AppColors.primary),
        selectedIconTheme: IconThemeData(color: AppColors.secondary),
        selectedItemColor: AppColors.textColorPrimary),
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.secondary,
    ),
    listTileTheme: ListTileThemeData(
        textColor: AppColors.textColorPrimary, iconColor: AppColors.third),
    expansionTileTheme: ExpansionTileThemeData(
        iconColor: AppColors.third, collapsedIconColor: AppColors.third),
    brightness: Brightness.dark,
    textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(AppColors.third),
            iconColor: MaterialStatePropertyAll(AppColors.secondary),
            textStyle: MaterialStateProperty.all<TextStyle>(
                TextStyle(color: AppColors.secondary)))),
    iconButtonTheme: IconButtonThemeData(
        style: ButtonStyle(
            backgroundColor:
                MaterialStatePropertyAll(AppColors.textColorPrimary),
            iconColor: MaterialStateProperty.all(AppColors.third))),
    iconTheme: IconThemeData(color: AppColors.secondary),
    primaryTextTheme: TextTheme(
        titleMedium: const TextStyle(color: Colors.green),
        headlineLarge: TextStyle(color: AppColors.third, fontFamily: "Roboto"),
        headlineMedium: TextStyle(color: AppColors.third, fontFamily: "Roboto"),
        headlineSmall: TextStyle(color: AppColors.third, fontFamily: "Roboto"),
        bodyMedium: TextStyle(
          color: AppColors.third,
          fontFamily: "Roboto",
          fontWeight: FontWeight.w600,
        ),
        titleSmall: TextStyle(
          color: AppColors.textColorPrimary,
          fontFamily: "Roboto",
        ),
        bodyLarge: TextStyle(
            color: AppColors.third,
            fontWeight: FontWeight.w700,
            fontFamily: "Roboto"),
        bodySmall: TextStyle(
          color: AppColors.third,
          fontWeight: FontWeight.w400,
          fontFamily: "Roboto",
        )),
  );
}
