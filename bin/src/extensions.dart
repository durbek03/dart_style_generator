extension StringExt on String {
  String removeRedundantChars() {
    var str = replaceAll(' ', '');
    str = str.replaceAll('-', '');
    str = str.replaceAll('_', '');
    return str;
  }

  String firstLetterLower() {
    return replaceRange(0, 1, this[0].toLowerCase());
  }
}

extension IntegerExt on int {
  String tabs() {
    return '\t' * this;
  }
}
