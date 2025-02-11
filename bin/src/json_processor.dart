import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'utils/extensions.dart';
import 'color_gen/theme.dart';
import 'color_gen/color.dart';
import 'text_style_gen/typography.dart';
import 'text_style_gen/font_family.dart';

class JsonProcessor {
  ///return map with 2 keys: light and dark. each key has a map of colors
  ///make sure name of theme keys is correct because they will be used as a class name
  List<Theme> getThemes(File inputJsonFile) {
    final json =
        jsonDecode(inputJsonFile.readAsStringSync()) as Map<String, dynamic>;

    final themeKeys = json.keys.where(
      (element) => element.contains("Light") || element.contains("Dark"),
    );

    final themedColors = <String, dynamic>{};

    ///for each theme
    for (var element in themeKeys) {
      ///for all colors inside these them

      ///example:      colors = {red: {shade1: #001, shade2: #002}, green: #00FF00, blue: #0000FF}
      final colors = json[element] as Map<String, dynamic>;

      final resolvedColors = _flattenColorMap(colors).map(
        (key, value) => MapEntry(key.firstLetterLower(), value),
      );

      themedColors[element] = resolvedColors;
    }

    return themedColors.keys.map(
      (key) {
        final themeName = key;
        final colors = themedColors[key] as Map<String, dynamic>;
        return Theme(
            themeName,
            colors.keys
                .map(
                  (e) => Color(
                    e,
                    colors[e]!,
                  ),
                )
                .toList());
      },
    ).toList();
  }

  ///colors might be nested like in example. this method resolves this.
  ///basically it makes nested map one flat map
  Map<String, dynamic> _flattenColorMap(Map<String, dynamic> colorMap,
      [String? prevKey]) {
    final colors = <String, dynamic>{};
    colorMap.forEach(
      (key, value) {
        if (value is Map && value.containsKey("value")) {
          colors[(prevKey ?? "").removeRedundantChars() +
              key.removeRedundantChars()] = value["value"];
        } else {
          final newColorMap = _flattenColorMap(value, key);
          colors.addAll(newColorMap);
        }
      },
    );
    return colors;
  }

  List<Typography> getTypography(File inputJsonFile) {
    final json =
        jsonDecode(inputJsonFile.readAsStringSync()) as Map<String, dynamic>;

    var allStyles = json["Variables"] as Map<String, dynamic>;

    final mapped = <Typography>[];

    allStyles.forEach(
      (key, value) {
        final isTypography = _isTypographyStyle(value);
        if (isTypography) {
          final typography = flattenNestedTypography({key: value});

          final withValues = setValuesForPath(typography, allStyles);

          final reducedMap = withValues.values.first;
          final fontFamily = reducedMap["fontFamily"];
          final fontWeight = reducedMap["fontWeight"];
          final fontSize = double.tryParse(reducedMap["fontSize"]);
          final lineHeight = double.tryParse(reducedMap["lineHeight"]);
          final letterSpacing = double.tryParse(
              (reducedMap["letterSpacing"] as String).replaceAll("%", ''));

          print("qwe fontweight $fontWeight");

          if (fontSize == null || lineHeight == null || letterSpacing == null) {
            throw Exception(
                "Font size, line height or letter spacing is null. Something went wrong");
          }

          mapped.add(Typography(
              name: withValues.keys.first,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
              fontSize: fontSize,
              lineHeight: lineHeight,
              letterSpacing: letterSpacing));
        }
      },
    );

    return mapped;
  }

  Map<String, dynamic> setValuesForPath(
      Map<String, dynamic> typography, Map<String, dynamic> allStyles) {
    final map = {};
    final name = typography.keys.first;
    final attributes = typography.values.first as Map;
    attributes.forEach(
      (key, value) {
        final _value = getValue(value);
        final resolvedValue = _getValueFromPath(_value, allStyles);
        map[key] = resolvedValue;
      },
    );
    return {name: map};
  }

  dynamic _getValueFromPath(String value, Map<String, dynamic> allStyles) {
    final path = (value.replaceAll("{", "").replaceAll("}", "")).split(".");
    late dynamic attribute;
    var prevValue = {};

    for (int i = 0; i < path.length; i++) {
      if (i == path.length - 1) {
        attribute = getValue(prevValue[path[i]]);
      } else {
        prevValue = allStyles[path[i]];
      }
    }
    return attribute;
  }

  Map<String, dynamic> flattenNestedTypography(Map<String, dynamic> values,
      [String prevKey = ""]) {
    final typography = <String, dynamic>{};

    values.forEach(
      (key, value) {
        final isTypography = typographyIsCurrentLevel(value);
        final currentKey = key == "value" ? "" : key;
        final _prevKey = prevKey.isEmpty ? "" : "${prevKey}_";
        if (isTypography) {
          typography[prevKey + currentKey] = value;
        } else {
          if (value is Map<String, dynamic>) {
            typography.addAll(flattenNestedTypography(
                value, _prevKey + currentKey.fileNameFormat()));
          }
        }
      },
    );
    return typography;
  }

  dynamic getValue(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value["value"];
    } else {
      return value;
    }
  }

  bool typographyIsCurrentLevel(dynamic value) {
    if (value is Map) {
      if (value.containsKey("fontFamily") &&
          value.containsKey("fontSize") &&
          value.containsKey("fontWeight") &&
          value.containsKey("letterSpacing")) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool _isTypographyStyle(dynamic value) {
    if (value is Map) {
      value as Map<String, dynamic>;
      if (value.containsKey("fontFamily") &&
          value.containsKey("fontSize") &&
          value.containsKey("fontWeight") &&
          value.containsKey("letterSpacing")) {
        return true;
      } else {
        if (value.values.isNotEmpty) {
          return _isTypographyStyle(value.values.first);
        } else {
          return false;
        }
      }
    } else {
      return false;
    }
  }
}
