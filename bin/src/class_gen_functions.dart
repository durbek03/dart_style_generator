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
        return "static const Color $name = ${_hashColorToColor(color)};";
      },
    );
    return mapped.join('\n${numberOfTabs.tabs()}');
  }

  static String _hashColorToColor(String hashColor) {
    String hexColor = hashColor.replaceFirst('#', '');

    if (hexColor.length > 6) {
      hexColor = hexColor.substring(0, 6);
    }

    // Parse the hex string to an integer and create a Color
    return "Color(0xFF${hexColor.toUpperCase()})";
  }

  static String getNamedConstructorImplementation(
      Iterable<({String fieldName, String value})> values,
      int numberOfTabs) {
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
