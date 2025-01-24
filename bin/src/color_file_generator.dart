import 'dart:io';
import 'class_gen_functions.dart';
import 'extensions.dart';

class ColorFileGenerator {
  final Map<String, dynamic> themes;
  String outputDirPath;

  ColorFileGenerator(this.themes, this.outputDirPath) {

    final colorExtensionsFir = Directory("$outputDirPath/color_extensions");
    colorExtensionsFir.createSync();
    final colorThemesDir = Directory("$outputDirPath/color_themes");
    colorThemesDir.createSync();
    final extensionImplementationsDir =
        Directory("$outputDirPath/extension_implementations");
    extensionImplementationsDir.createSync();

    if (outputDirPath[outputDirPath.length - 1] == "/") {
      outputDirPath = outputDirPath.substring(0, outputDirPath.length - 1);
    }
  }

  void generateColorExtensionFile() async {
    final file =
        File("$outputDirPath/color_extensions/app_colors_extension.dart");
    file.writeAsStringSync(extensionFileTemplate());
  }

  void generateColorsFile() {
    themes.forEach(
      (key, value) {
        final file = File("$outputDirPath/color_themes/${key}_colors.dart");
        file.writeAsStringSync(colorsFileTemplate(key, value));
      },
    );
  }

  void generateThemeImplementations() {
    themes.forEach(
      (key, value) {
        final file =
            File("$outputDirPath/extension_implementations/${key}_theme.dart");
        file.writeAsStringSync(themeImplementationTemplate(
            key, value, "../color_themes/${key}_colors.dart"));
      },
    );
  }

  String themeImplementationTemplate(
      String themeName, Map<String, dynamic> colors, String colorFilePath) {
    final fields = colors.keys.map(
      (e) => (fieldName: e, value: "${themeName}Color.$e"),
    );

    return '''
import '$colorFilePath';
import '../color_extensions/app_colors_extension.dart';

final ${themeName.firstLetterLower()}Extension = AppColorsExtension(
  ${ClassGenFunctions.getNamedConstructorImplementation(fields, 1)}
);
    ''';
  }

  String colorsFileTemplate(String themeName, Map<String, dynamic> colors) {
    return '''
import 'package:flutter/material.dart';

class ${themeName}Color {
  ${themeName}Color._();
  
  ${ClassGenFunctions.getStaticConstColors(colors.keys.map(
              (e) => (variableName: e, colorHash: colors[e]),
            ), 1)}
 
}
    ''';
  }

  String extensionFileTemplate() {
    ///any theme is okay, it is just to fetch variable name
    ///all themes have same variable names so it is okay to do this
    final firstThemeColors = themes.entries.first.value as Map<String, dynamic>;
    return '''
import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    ${ClassGenFunctions.getConstructorRequiredParameters(firstThemeColors.keys, 2)}
  });

  ${ClassGenFunctions.getClassField(firstThemeColors.keys.map(
              (e) => (variableType: "Color", variableName: e),
            ), 1)}

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    ${ClassGenFunctions.getCopyWithMethodParameters(firstThemeColors.keys.map(
              (e) => (variableName: e, variableType: "Color"),
            ), 2)}
  }) {
    return AppColorsExtension(
      ${ClassGenFunctions.getCopyWithConstructor(firstThemeColors.keys, 3)}
    );
  }

  @override
  ThemeExtension<AppColorsExtension> lerp(
      covariant ThemeExtension<AppColorsExtension>? other,
      double t,
      ) {
    if (other is! AppColorsExtension) {
      return this;
    }

    return AppColorsExtension(
      ${ClassGenFunctions.getColorLerpConstructorParameters(firstThemeColors.keys, 3)}
    );
  }
}
    ''';
  }
}
