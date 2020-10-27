class DateUtils {
  static Map<int, int> _daysInMonthCache = {};
  static int daysInMonth(int month) {
    return _daysInMonthCache.putIfAbsent(month, () {
      DateTime lastDate = DateTime(2020, month == 12 ? 1 : month + 1, 1);
      lastDate = lastDate.subtract(Duration(days: 1));
      return lastDate.day;
    });
  }
}
