import 'extensions.dart';
import '../text_style_gen/typography.dart';

class ClassGenFunctions {
  static String getConstructorRequiredParameters(
      Iterable<String> variableNames, int numberOfTabs) {
    final mapped = variableNames.map(
      (e) {
        return "required this.$e,";
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String getClassField(
      Iterable<({String variableName, String variableType})> values,
      int numberOfTabs) {
    final mapped = values.map(
      (e) {
        final name = e.variableName;
        final type = e.variableType;
        return "final $type $name;";
      },
    );
    return mapped.join('\n${'\t' * numberOfTabs}');
  }

  static String getCopyWithMethodParameters(
      Iterable<({String variableType, String variableName})> values,
      int numberOfTabs) {
    final mapped = values.map(
      (e) {
        final name = e.variableName;
        final type = e.variableType;
        return "$type? $name,";
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String getCopyWithConstructor(
      Iterable<String> variableNames, int numberOfTabs) {
    final mapped = variableNames.map(
      (e) {
        return "$e: $e ?? this.$e,";
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String getColorLerpConstructorParameters(
      Iterable<String> variableNames, int numberOfTabs) {
    final mapped = variableNames.map(
      (e) {
        return "$e: Color.lerp($e, other.$e, t)!,";
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String getStaticConstColors(
      Iterable<({String variableName, String colorHash})> values,
      int numberOfTabs) {
    final mapped = values.map(
      (e) {
        final name = e.variableName;
        final color = e.colorHash;
        if (color.length > 7) {
          return "static Color $name = ${_hashColorToColor(color)};";
        } else {
          return "static const Color $name = ${_hashColorToColor(color)};";
        }
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String _hashColorToColor(String hashColor) {
    String hexColor = hashColor.replaceFirst('#', '');

    if (hexColor.length > 6) {
      int alpha = int.parse(hashColor.substring(6), radix: 16);
      double opacity = (alpha / 255);
      opacity %= 1;

      hexColor = hexColor.substring(0, 6);
      return "Color(0xFF$hexColor).withOpacity(${opacity.toStringAsFixed(2)})";
    } else {
      return "Color(0xFF$hexColor)";
    }
  }

  static String getNamedConstructorImplementation(
      Iterable<({String fieldName, String value})> values, int numberOfTabs) {
    final mapped = values.map(
      (e) {
        final name = e.fieldName;
        final implementation = e.value;
        return "$name: $implementation,";
      },
    );

    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String getFontFamilies(Set<String> fontFamilies, int numberOfTabs) {
    final mapped = fontFamilies.map(
      (e) {
        return "static String? ${e.fileNameFormat()} = Platform.isIOS ? '$e' : null;";
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String getFontWeights(Set<String> fontWeights, int numberOfTabs) {
    final mapped = fontWeights.map(
      (e) {
        return "static const FontWeight ${e.toLowerCase()} = ${parseWeight(e)};";
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String parseWeight(String weight) {
    switch (weight) {
      case "Ultralight":
        return "FontWeight.w100";
      case "Thin":
        return "FontWeight.w200";
      case "Light":
        return "FontWeight.w300";
      case "Regular":
        return "FontWeight.w400";
      case "Medium":
        return "FontWeight.w500";
      case "Semibold":
        return "FontWeight.w600";
      case "Bold":
        return "FontWeight.w700";
      case "Heavy":
        return "FontWeight.w800";
      default:
        return "FontWeight.w400";
    }
  }

  static String getTextStyleFields(List<Typography> styles, Set<double> letterSpacing, int numberOfTabs) {
    final mapped = styles.map(
      (e) {
        final name = e.name;
        return '''
  static TextStyle $name = TextStyle(
    fontFamily: AppFontFamily.${e.fontFamily.fileNameFormat()},
    fontWeight: AppFontWeight.${e.fontWeight.toLowerCase()},
    fontSize: ${e.fontSize},
    height: ${(e.lineHeight / e.fontSize).roundToDouble()},
    letterSpacing: AppLetterSpacing.k${letterSpacing.toList().indexOf(e.letterSpacing)},
  );
        ''';
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static getLetterSpacings(Set<double> letterSpacings, int i) {
    final mapped = letterSpacings.map(
      (e) {
        return "static const double k${letterSpacings.toList().indexOf(e)} = $e;";
      },
    );
    return mapped.join('\n${i.tabs()}');
  }
}
