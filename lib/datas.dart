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

  // OK
  static void gerarParcelaDiaFixo({
    int nroparcelas = 1,
    int dtinvalida = 0,
    String diasFixos = '',
    int carencia = 0,
    bool mesSeguinte = false,
    bool diaFixoDtVenda = false,
    //DIAFIXODTVENDA
    //Nesta configuração temos a informação se caso vendido no dia que
    // está marcado como vencimento, se será gerado vencimento para o mesmo
    //dia ou só para o próximo marcado
  }) {
    final dias = diasFixos.substring(0, diasFixos.length - 1);

    final List<int> listDiasFixos = dias.split(';').map((e) => int.parse(e)).toList();

    listDiasFixos.sort();

    DateTime nowDate = DateTime.now().add(Duration(days: carencia));

    List<DateTime> datesVencimento = [];

    if (nowDate.day > listDiasFixos.last) {
      nowDate = DateTime(nowDate.year, nowDate.month + 1, 1);
    }

    if (mesSeguinte) {
      //TODO Inicializar o mes no dia 1, deve ser feito dessa forma.
      nowDate = DateTime(nowDate.year, nowDate.month + 1, 1);
    }

    while (datesVencimento.length != nroparcelas) {
      for (int i = 0; i < listDiasFixos.length; i++) {
        if (datesVencimento.length == nroparcelas) break;
        if (nowDate.day <= listDiasFixos[i]) {
          if (!mesSeguinte && (nowDate.day == listDiasFixos[i] && !diaFixoDtVenda)) {
            if (listDiasFixos[i] == listDiasFixos.last) {
              break;
            }
          } else {
            nowDate = DateTime(nowDate.year, nowDate.month, listDiasFixos[i]);
            datesVencimento.add(nowDate);
          }
        }
      }
      nowDate = DateTime(nowDate.year, nowDate.month + 1, 1);
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

  static void generateParcelaPorPeriodo({
    required List<PrazoParcela> prazoParcelas,
    bool mesSeguinte = false,
    int nroparcelas = 1,
    bool diaFixoDtVenda = false,
  }) {
    //rever
    //  Datas.generateParcelaPorPeriodo(
    //         nroparcelas: 2,
    //         prazoParcelas: [
    //           PrazoParcela(ateDia: 29, venc: 30),
    //         ],
    //       );

    List<DateTime> datesVencimento = [];

    DateTime nowDate = DateTime.now();
    late final PrazoParcela prazoParcela;
    if (prazoParcelas.length > 1) {
      prazoParcelas.sort((a, b) => a.ateDia.compareTo(b.ateDia));
      prazoParcela = prazoParcelas.where((element) => element.ateDia > nowDate.day).first;
    } else {
      prazoParcela = prazoParcelas.first;
    }

    if (nowDate.day > prazoParcela.venc) {
      nowDate = addMonths(nowDate, 1);
    }

    nowDate = DateTime(nowDate.year, nowDate.month, prazoParcela.venc);

    if (mesSeguinte) {
      nowDate = addMonths(nowDate, 1);
    }

    // vericar data invalida. para pular mes.
    for (int i = 0; i < nroparcelas; i++) {
      if (prazoParcela.venc != nowDate.day && !diaFixoDtVenda) {
        datesVencimento.add(DateTime(nowDate.year, nowDate.month, 1));
      } else {
        datesVencimento.add(nowDate);
      }
    /// TODO verificar

         nowDate = addMonths(nowDate, 1);
    }

    final tt = datesVencimento;
  }
}

DateTime getNextWeekDay({required int weekDay, DateTime? specificDate}) {
  specificDate ??= DateTime.now();

  int remainDays = weekDay - specificDate.weekday + 7;

  return specificDate.add(Duration(days: remainDays));
}

List<DateTime> getDatesDays({required int year, required int month, required int weekday}) {
  var firstDayMonth = DateTime(year, month, 1);

  List<DateTime> dates = [];

  var firstMonday = firstDayMonth.add(Duration(days: (7 - (firstDayMonth.weekday - weekday)) % 7));

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
// Verificar valor da parcelas
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
    return DateTime.utc(newYear, newMonth, newDay, from.hour, from.minute, from.second, from.millisecond, from.microsecond);
  } else {
    return DateTime(newYear, newMonth, newDay, from.hour, from.minute, from.second, from.millisecond, from.microsecond);
  }
}

int daysInMonth(int year, int month) {
  var result = daysInMonthArray[month];
  if (month == 2 && isLeapYear(year)) result++;
  return result;
}

const daysInMonthArray = [0, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

bool isLeapYear(int year) => (year % 4 == 0) && ((year % 100 != 0) || (year % 400 == 0));

class PrazoParcela {
  final int ateDia;
  final int venc;

  const PrazoParcela({required this.ateDia, required this.venc});
}
