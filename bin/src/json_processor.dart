import 'dart:convert';
import 'dart:io';
import 'utils/extensions.dart';
import 'color_gen/theme.dart';
import 'color_gen/color.dart';

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

      final resolvedColors = _flattenMap(colors).map(
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
  Map<String, dynamic> _flattenMap(Map<String, dynamic> colorMap,
      [String? prevKey]) {
    final colors = <String, dynamic>{};
    colorMap.forEach(
      (key, value) {
        if (value is Map && value.containsKey("value")) {
          colors[(prevKey ?? "").removeRedundantChars() +
              key.removeRedundantChars()] = value["value"];
        } else {
          final newColorMap = _flattenMap(value, key);
          colors.addAll(newColorMap);
        }
      },
    );
    return colors;
  }
}
