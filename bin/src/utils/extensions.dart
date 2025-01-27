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

  String fileNameFormat() {
    print("qwe got str $this");
    var str = this;
    str = str.replaceAll(' ', '_');
    str = str.replaceAll('-', '_');
    //all uppercase letters with lowercase and add _ before them
    str = str.replaceAllMapped(RegExp(r'[A-Z]'), (match) {
      return '_${match.group(0)}';
    });
    str = str.toLowerCase();
    if (str[0] == '_') {
      str = str.substring(1);
    }
    print("qwe returning $str");
    return str;
  }
}

extension IntegerExt on int {
  String tabs() {
    return '\t' * this;
  }
}
