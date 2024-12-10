extension DateTimeExtensions on DateTime {
  String formatDateToApi() {
    String date = toString();
    int indicePonto = date.indexOf('.');
    if (indicePonto != -1) {
      return '${date.substring(0, indicePonto + 1)}000000';
    }
    return '$date.000000';
  }

  String ymd() =>
      "$year-${month.toString().padLeft(2, '0')}-${day.toString().padLeft(2, '0')}";

  String dmyhm() =>
      "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";
  String dmy() =>
      "${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year";
  String lastSync() =>
      "Última sincronização: ${day.toString().padLeft(2, '0')}/${month.toString().padLeft(2, '0')}/$year ${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}";

  bool syncIsInvalid() {
    final now = DateTime.now();

    if (difference(now).inDays > 1) return true;
    if (difference(now).inDays == 0 && hour >= 4 && day == now.day) {
      return false;
    }
    if (difference(now).inDays == 0 && hour < 4 && now.hour < 4) return false;
    if (hour >= 18 && now.hour < 4) return false;
    return true;
  }

  (int begin, int end) getSyncLimit() {
    final now = DateTime.now();
    if (now.hour >= 4) {
      return (
        DateTime.now()
            .copyWith(hour: 4, minute: 0, second: 0)
            .millisecondsSinceEpoch,
        DateTime.now()
            .add(const Duration(days: 1))
            .copyWith(hour: 3, minute: 59, second: 59)
            .millisecondsSinceEpoch
      );
    }
    return (
      DateTime.now()
          .subtract(const Duration(days: 1))
          .copyWith(hour: 4, minute: 0, second: 0)
          .millisecondsSinceEpoch,
      DateTime.now()
          .copyWith(hour: 3, minute: 59, second: 59)
          .millisecondsSinceEpoch
    );
  }
}
