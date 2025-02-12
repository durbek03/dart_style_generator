import 'dart:io';
import '../utils/class_gen_functions.dart';
import '../utils/extensions.dart';
import 'theme.dart';
import 'color.dart';

class ColorFileGenerator {
  final List<Theme> themes;
  String outputDirPath;

  ColorFileGenerator(this.themes, this.outputDirPath) {
    if (outputDirPath[outputDirPath.length - 1] == "/") {
      outputDirPath = outputDirPath.substring(0, outputDirPath.length - 1);
    }
    createDirs();
  }

  void generateColorExtensionFile() async {
    final file =
        File("$outputDirPath/color_extensions/app_colors_extension.dart");
    file.writeAsStringSync(extensionFileTemplate());
  }

  void generateColorsFile() {
    for (var theme in themes) {
      final file = File(
          "$outputDirPath/color_themes/${theme.themeName.fileNameFormat()}_colors.dart");
      file.writeAsStringSync(colorsFileTemplate(theme.themeName, theme.colors));
    }
  }

  void generateThemeImplementations() {
    for (var theme in themes) {
      final file = File(
          "$outputDirPath/extension_implementations/${theme.themeName.fileNameFormat()}_theme.dart");
      file.writeAsStringSync(themeImplementationTemplate(
          theme.themeName,
          theme.colors,
          "../color_themes/${theme.themeName.fileNameFormat()}_colors.dart"));
    }
  }

  String themeImplementationTemplate(
      String themeName, List<Color> colors, String colorFilePath) {
    final fields = colors.map(
      (e) =>
          (fieldName: e.colorName, value: "${themeName}Color.${e.colorName}"),
    );

    return '''
import '$colorFilePath';
import '../color_extensions/app_colors_extension.dart';

final ${themeName.firstLetterLower()}Extension = AppColorsExtension(
  ${ClassGenFunctions.getNamedConstructorImplementation(fields, 1)}
);
    ''';
  }

  String colorsFileTemplate(String themeName, List<Color> colors) {
    return '''
import 'package:flutter/material.dart';

class ${themeName}Color {
  ${themeName}Color._();
  
  ${ClassGenFunctions.getStaticConstColors(colors.map(
              (e) => (variableName: e.colorName, colorHash: e.hash),
            ), 1)}
 
}
    ''';
  }

  String extensionFileTemplate() {
    ///any theme is okay, it is just to fetch variable name
    ///all themes have same variable names so it is okay to do this
    final firstThemeColors = themes.first.colors;
    return '''
import 'package:flutter/material.dart';

class AppColorsExtension extends ThemeExtension<AppColorsExtension> {
  AppColorsExtension({
    ${ClassGenFunctions.getConstructorRequiredParameters(firstThemeColors.map(
              (e) => e.colorName,
            ), 2)}
  });

  ${ClassGenFunctions.getClassField(firstThemeColors.map(
              (e) => (variableType: "Color", variableName: e.colorName),
            ), 1)}

  @override
  ThemeExtension<AppColorsExtension> copyWith({
    ${ClassGenFunctions.getCopyWithMethodParameters(firstThemeColors.map(
              (e) => (variableName: e.colorName, variableType: "Color"),
            ), 2)}
  }) {
    return AppColorsExtension(
      ${ClassGenFunctions.getCopyWithConstructor(firstThemeColors.map(
              (e) => e.colorName,
            ), 3)}
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
      ${ClassGenFunctions.getColorLerpConstructorParameters(firstThemeColors.map(
              (e) => e.colorName,
            ), 3)}
    );
  }
}
    ''';
  }

  void createDirs() async {
    outputDirPath = "$outputDirPath/theme_colors";
    final parentDir = Directory(outputDirPath);
    parentDir.createSync();
    final colorExtensionsFir = Directory("$outputDirPath/color_extensions");
    colorExtensionsFir.createSync();
    final colorThemesDir = Directory("$outputDirPath/color_themes");
    colorThemesDir.createSync();
    final extensionImplementationsDir =
        Directory("$outputDirPath/extension_implementations");
    extensionImplementationsDir.createSync();
  }
}
