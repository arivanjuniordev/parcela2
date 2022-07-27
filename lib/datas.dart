import 'dart:math';

class Datas {
  static void gerarParcelaNormal({
    int nroparcelas = 1,
    int carencia = 0,
    int diasEntreParcelas = 1,
  }) {
    DateTime nowDate = DateTime.now();

    for (int i = 1; i <= nroparcelas; i++) {
      if (i == 1) {
        nowDate = nowDate.add(Duration(days: carencia));
      } else {
        nowDate = nowDate.add(Duration(days: diasEntreParcelas));
      }
    }
  }

  static void gerarParcelaDiaFixo({
    int nroparcelas = 1,
    int dtinvalida = 0,
    String diasFixos = '',
    int carencia = 0,
    bool mesSeguinte = false,
  }) {
    final dias = diasFixos.substring(0, diasFixos.length - 1);

    final List<int> listDiasFixos =
        dias.split(';').map((e) => int.parse(e)).toList();

    listDiasFixos.sort();

    DateTime nowDate = DateTime.now().add(Duration(days: carencia));

    List<DateTime> datesVencimento = [];

    var maiorDia = listDiasFixos.last;

    if (nowDate.day <= maiorDia) {
      nowDate = DateTime(nowDate.year, nowDate.month + 1, 1);
    }

    if (mesSeguinte) {
      nowDate = addMonths(nowDate, 1);
    }

    DateTime dueDate = nowDate;

    while (datesVencimento.length < nroparcelas) {
      for (int i = 0; i < diasFixos.length; i++) {
        if (datesVencimento.length == nroparcelas) {
          break;
        }

        if ((dueDate.month == nowDate.month) &&
            (dueDate.day <= listDiasFixos[i])) {
          dueDate = DateTime(nowDate.year, nowDate.month, listDiasFixos[i]);
          datesVencimento.add(dueDate);
        } else {
          nowDate = DateTime(nowDate.year, nowDate.month + 1, 1);
          dueDate = DateTime(nowDate.year, nowDate.month + 1, 1);
          break;
        }
      }
    }

    final tt = datesVencimento;
  }

  static void gerarParcelaDiaSemana({
    int nroparcelas = 1,
    int carencia = 0,
    required int ordsemana,
    required int idParcelaItem,
    required String diaDoVencimentoFixo,
  }) {
    DateTime nowDate = DateTime.now().add(Duration(days: carencia));

    List<DateTime> datesVencimento = [];

    late int weekdayDate;

    switch (diaDoVencimentoFixo) {
      case 'D':
        weekdayDate = DateTime.sunday;
        break;
      case 'S':
        weekdayDate = DateTime.monday;
        break;
      case 'T':
        weekdayDate = DateTime.tuesday;
        break;
      case 'Q':
        weekdayDate = DateTime.wednesday;
        break;
      case 'U':
        weekdayDate = DateTime.thursday;
        break;
      case 'E':
        weekdayDate = DateTime.friday;
        break;

      case 'A':
        weekdayDate = DateTime.saturday;
        break;
      default:
    }

    if (ordsemana != 0) {
      for (int i = 1; i <= nroparcelas; i++) {
        var result = getDate(
          month: nowDate.month,
          order: ordsemana,
          weekday: weekdayDate,
          year: nowDate.year,
        );

        if (result.isBefore(nowDate)) {
          DateTime dueDate = DateTime(result.year, result.month, 1);
          nowDate = addMonths(dueDate, 1);

          result = getDate(
            month: nowDate.month,
            order: ordsemana,
            weekday: weekdayDate,
            year: nowDate.year,
          );
        }

        datesVencimento.add(result);

        DateTime dueDate = DateTime(result.year, result.month, 1);
        nowDate = addMonths(dueDate, 1);
      }

      print(datesVencimento);
    }
  }

  static void gerarParcelaPorPeriodo({
    bool dtinvalida = false,
    String diasFixos = '',
    int carencia = 0,
    int ateDia = 0,
    bool mesSeguinte = false,
    int nroparcelas = 1,
  }) {
    DateTime nowDate = DateTime.now().add(Duration(days: carencia));

    List<DateTime> datesVencimento = [];

    if (mesSeguinte) {
      nowDate = addMonths(nowDate, 1);
    }

    if (nowDate.day > ateDia) {
      nowDate = addMonths(nowDate, 1);
    }

    for (int i = 1; i <= nroparcelas; i++) {
      if (nowDate.day < ateDia) {
        nowDate = addMonths(nowDate, 1);
      } else {
        nowDate = DateTime(nowDate.year, nowDate.month, ateDia);
      }

      datesVencimento.add(nowDate);
      nowDate = addMonths(nowDate, 1);
    }
  }
}

enum WeekDay {
  monday,
  tuesday,
  wednesday,
  thursday,
  friday,
  saturday,
  sunday,
}

DateTime getNextWeekDay({required int weekDay, DateTime? specificDate}) {
  specificDate ??= DateTime.now();

  int remainDays = weekDay - specificDate.weekday + 7;

  return specificDate.add(Duration(days: remainDays));
}

List<DateTime> getDatesDays(
    {required int year, required int month, required int weekday}) {
  var firstDayMonth = DateTime(year, month, 1);

  List<DateTime> dates = [];

  var firstMonday = firstDayMonth
      .add(Duration(days: (7 - (firstDayMonth.weekday - weekday)) % 7));

  var currentMonday = firstMonday;

  //while (currentMonday.month == firstDayMonth.month) {
  while (dates.length < 5) {
    var nextWeekday = currentMonday.add(const Duration(days: 7));
    dates.add(currentMonday);

    currentMonday = nextWeekday;
  }

  return dates;
}

DateTime getDate({
  required int year,
  required int month,
  required int weekday,
  required int order,
}) {
  List<DateTime> result = [];

  while (!(order <= result.length)) {
    result = getDatesDays(month: month, weekday: weekday, year: year);
    month++;
  }
  return result[order - 1];
}

DateTime addMonths(DateTime from, int months) {
  final r = months % 12;
  final q = (months - r) ~/ 12;
  var newYear = from.year + q;
  var newMonth = from.month + r;
  if (newMonth > 12) {
    newYear++;
    newMonth -= 12;
  }
  final newDay = min(from.day, daysInMonth(newYear, newMonth));
  if (from.isUtc) {
    return DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  } else {
    return DateTime(newYear, newMonth, newDay, from.hour, from.minute,
        from.second, from.millisecond, from.microsecond);
  }
}

int daysInMonth(int year, int month) {
  var result = daysInMonthArray[month];
  if (month == 2 && isLeapYear(year)) result++;
  return result;
}

const daysInMonthArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

bool isLeapYear(int year) =>
    (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));
