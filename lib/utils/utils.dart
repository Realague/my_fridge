class Utils {
  static final int maxInt = (double.infinity is int) ? double.infinity as int : ~minInt;
  static final int minInt = (double.infinity is int) ? -double.infinity as int : (-1 << 63);

  static final DateTime nullDateTime = DateTime(2050);

  static bool isNumber(String str) {
    return int.tryParse(str) != null;
  }
}
