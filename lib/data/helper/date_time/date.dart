import 'package:injectable/injectable.dart';

@injectable
@lazySingleton
class DateTimeHelper {
  DateTime getCurrentDate() {
    final present = DateTime.now();
    return DateTime(
      present.year,
      present.month,
      present.day,
    );
  }

  DateTime getFutureDate({required int days}) {
    return getCurrentDate().add(
      Duration(
        days: days - 1,
      ),
    );
  }

  DateTime getPastDate({required int days}) {
    return getCurrentDate().subtract(
      Duration(
        days: days - 1,
      ),
    );
  }

  DateTime getLastDateOfCurrentMonth() {
    final today = getCurrentDate();
    final firstDayOfNextMonth = DateTime(
      today.year,
      today.month + 1,
      1,
    );

    return firstDayOfNextMonth.subtract(
      const Duration(days: 1),
    );
  }
}
