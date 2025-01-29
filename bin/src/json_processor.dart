import 'dart:convert';
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

  Map<String, dynamic> _extractStyles(Map<String, dynamic> typographyMap, [String? prevKey]) {
    var styles = <String, dynamic>{};
    typographyMap.forEach(
      (key, value) {
        if (value is Map<String, dynamic>) {
          if (_isTypographyStyle(value)) {
            styles[(prevKey ?? "").removeRedundantChars() + key.removeRedundantChars()] = value;
          } else {
            styles.addAll(_extractStyles(value, key));
          }
        } else {
          return;
        }
      },
    );
    return styles;
  }

  List<Typography> getTypography(File inputJsonFile) {
    final json =
        jsonDecode(inputJsonFile.readAsStringSync()) as Map<String, dynamic>;

    var allStyles = json["Variables"] as Map<String, dynamic>;
    final mapped = <Typography>[];

    final typography = _extractStyles(allStyles);
    typography.forEach(
      (key, value) {
        final isStyle = _isTypographyStyle(value);
        final reducedMap = <String, dynamic>{};
        if (isStyle) {
          value as Map<String, dynamic>;
          value.forEach(
            (key, value) {
              var variablePath = value["value"] as String;
              //remove {}
              variablePath =
                  variablePath.replaceAll("{", "").replaceAll("}", "");
              final path = variablePath.split(".");
              var mapBefore = allStyles;
              for (int index = 0; index < path.length; index++) {
                final value = path[index];
                if (index == path.length - 1) {
                  reducedMap[key] = mapBefore[value]['value'];
                } else {
                  mapBefore = mapBefore[path[index]];
                }
              }
            },
          );

          final name = key.fileNameFormat();
          final fontFamily = reducedMap["fontFamily"];
          final fontWeight = reducedMap["fontWeight"];
          final fontSize = double.tryParse(reducedMap["fontSize"]);
          final lineHeight = double.tryParse(reducedMap["lineHeight"]);
          final letterSpacing = double.tryParse(
              (reducedMap["letterSpacing"] as String).replaceAll("%", ''));

          if (fontSize == null || lineHeight == null || letterSpacing == null) {
            throw Exception(
                "Font size, line height or letter spacing is null. Something went wrong");
          }

          mapped.add(Typography(
              name: name,
              fontFamily: fontFamily,
              fontWeight: fontWeight,
              fontSize: fontSize,
              lineHeight: lineHeight,
              letterSpacing: letterSpacing));
        } else {

        }
      },
    );
    return mapped;
  }

  _isTypographyStyle(Map<String, dynamic> map) {
    return map.containsKey("fontSize") &&
        map.containsKey("lineHeight") &&
        map.containsKey("letterSpacing") &&
        map.containsKey("fontFamily") &&
        map.containsKey("fontWeight");
  }
}
