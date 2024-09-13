extension ExtensionStringHelper on String {
  String get clearLogPassword {
    return replaceAll(RegExp(r'password->\w+'), 'password->****')
        .replaceAll(RegExp(r'password_confirmation->\w+'), 'password_confirmation->****');
  }

  String get ucFirst {
    if (isEmpty) {
      return '';
    }
    if (length == 1) {
      return toUpperCase();
    }
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String afterFirst(String character) {
    final String tmpValue = this;
    final int pos = tmpValue.indexOf(character);
    return (pos != -1)
        ? (tmpValue.substring(pos, tmpValue.length).replaceFirst(character, ''))
        : tmpValue;
  }

  bool get isUrl => (contains('https://') || contains('http://'));
}
