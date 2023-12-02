extension StringExtension on String {
  String capitalize() {
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}

extension IntExtension on int {
  String toPaddedString(int padding) {
    return toString().padLeft(padding, '0');
  }
}
