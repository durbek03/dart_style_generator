import 'package:args/args.dart';
import 'src/generator.dart';

ArgParser buildParser() {
  return ArgParser()
    ..addCommand('generate-color')
    ..addCommand('generate-text')
    ..addOption(
      'json-file-path',
      abbr: 'i',
      help: 'The path for json file with text styles or colors',
    )
    ..addOption(
      'output-dir-path',
      abbr: 'o',
      help: 'Directory [ath of files which will be generated in',
    );
}

void main(List<String> arguments) async {
  try {
    final ArgParser argParser = buildParser();
    final ArgResults results = argParser.parse(arguments);
    final commandName = results.command?.name;

    final inputJsonFilePath = results['json-file-path'];
    final outputDirPath = results['output-dir-path'];

    final generator = Generator(outputDirPath, inputJsonFilePath);
    if (commandName == 'generate-color') {
      generator.generateColors();
    } else if (commandName == 'generate-text') {
      generator.generateTextStyles();
    }
  } catch (e, s) {
  }
}
