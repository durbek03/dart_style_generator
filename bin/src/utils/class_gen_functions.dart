import 'dart:developer';

import 'extensions.dart';

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
}
