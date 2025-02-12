import 'dart:io';

import 'json_processor.dart';
import 'color_gen/color_file_generator.dart';
import 'text_style_gen/text_style_file_generator.dart';

class Generator {
  final String outputFilesDir;
  final String inputJsonPath;

  final jsonProcessor = JsonProcessor();

  Generator(this.outputFilesDir, this.inputJsonPath);

  void generateColors() async {
    final isFile = await FileSystemEntity.isFile(inputJsonPath);
    if (!isFile) throw Exception('File not found');

    final jsonFile = File(inputJsonPath);

    final colors = jsonProcessor.getThemes(jsonFile);
    final colorFileGenerator = ColorFileGenerator(colors, outputFilesDir);

    colorFileGenerator.generateColorExtensionFile();
    colorFileGenerator.generateColorsFile();
    colorFileGenerator.generateThemeImplementations();
  }

  void generateTextStyles() async {
    final isFile = await FileSystemEntity.isFile(inputJsonPath);
    if (!isFile) throw Exception('File not found');

    final jsonFile = File(inputJsonPath);

    final textStyles = jsonProcessor.getTypography(jsonFile);

    final textFileGenerator = TextStyleFileGenerator(outputFilesDir, textStyles);
    textFileGenerator.generate();
  }
}
