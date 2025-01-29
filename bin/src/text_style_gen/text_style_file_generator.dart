import 'dart:io';

import 'typography.dart';
import '../utils/class_gen_functions.dart';
import '../utils/extensions.dart';

class TextStyleFileGenerator {
  String _outputPath;
  final List<Typography> typography;
  late final Set<String> fontFamilies;
  late final Set<double> letterSpacings;
  late final Set<String> fontWeights;

  TextStyleFileGenerator(this._outputPath, this.typography) {
    _outputPath = _outputPath.removeLastSlash();

    fontFamilies = typography.map((e) => e.fontFamily).toSet();
    letterSpacings = typography.map((e) => e.letterSpacing).toSet();
    fontWeights = typography.map((e) => e.fontWeight).toSet();

    final dir = Directory("$_outputPath/text_styles");
    _outputPath = dir.path;
    dir.createSync();
  }

  void generate() {
    final file = File('$_outputPath/app_font_family.dart');
    file.writeAsStringSync(fontFamilyTemplate);

    final file2 = File('$_outputPath/app_typography.dart');
    file2.writeAsStringSync(typographyTemplate);

    final file3 = File('$_outputPath/app_font_weight.dart');
    file3.writeAsStringSync(fontWeightTemplate);

    final file4 = File('$_outputPath/app_letter_spacing.dart');
    file4.writeAsStringSync(letterSpacingTemplate);
  }

  late final fontFamilyTemplate = '''
import 'dart:io';
class AppFontFamily {
  AppFontFamily._();
  
  ${ClassGenFunctions.getFontFamilies(fontFamilies, 1)}
}  
  ''';

  late final letterSpacingTemplate = '''
class AppLetterSpacing {
  AppLetterSpacing._();
  
  ${ClassGenFunctions.getLetterSpacings(letterSpacings, 1)}
}  
  ''';

  late final fontWeightTemplate = '''
import 'package:flutter/material.dart';

class AppFontWeight {
  AppFontWeight._();
  
  ${ClassGenFunctions.getFontWeights(fontWeights, 1)}
}  
  ''';

  late final typographyTemplate = '''
import 'package:flutter/material.dart';
import 'app_font_weight.dart';
import 'app_font_family.dart';
import 'app_letter_spacing.dart';

class AppTypography {
  AppTypography._();
  
  ${ClassGenFunctions.getTextStyleFields(typography, letterSpacings, 1)}
}  
  ''';
}
