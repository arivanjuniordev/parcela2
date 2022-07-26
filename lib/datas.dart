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

    DateTime dueDate;
    DateTime nowDate = DateTime.now();

    switch (nowDate.month) {
      case 2:
        if (dtinvalida == 0) {
          dueDate = DateTime(nowDate.year, nowDate.month + 1);
        } else {
          dueDate = DateTime(nowDate.year, nowDate.month + 1)
              .subtract(const Duration(days: 1));
        }
        break;
      case 4:
        if (dtinvalida == 0) {
          dueDate = DateTime(nowDate.year, nowDate.month + 1);
        } else {
          dueDate = DateTime(nowDate.year, nowDate.month + 1)
              .subtract(const Duration(days: 1));
        }
        break;
      case 6:
        if (dtinvalida == 0) {
          dueDate = DateTime(nowDate.year, nowDate.month + 1);
        } else {
          dueDate = DateTime(nowDate.year, nowDate.month + 1)
              .subtract(const Duration(days: 1));
        }
        break;
      case 9:
        if (dtinvalida == 0) {
          dueDate = DateTime(nowDate.year, nowDate.month + 1);
        } else {
          dueDate = DateTime(nowDate.year, nowDate.month + 1)
              .subtract(const Duration(days: 1));
        }
        break;
      case 11:
        if (dtinvalida == 0) {
          dueDate = DateTime(nowDate.year, nowDate.month + 1);
        } else {
          dueDate = DateTime(nowDate.year, nowDate.month + 1)
              .subtract(const Duration(days: 1));
        }
        break;
      default:
        dueDate = nowDate;
    }

    if (mesSeguinte) {
      dueDate = DateTime(dueDate.year, dueDate.month + 1);
    }

//rever
    for (int i = 1; i <= nroparcelas; i++) {
      if (i == 1) {
        //       diasFixos: '15;31;10;',de acordo que for mais perto
        //ate com a soma da carrencia tem q ser perto do dia
        dueDate = DateTime(dueDate.year, dueDate.month, carencia);
      } else {
        dueDate = DateTime(dueDate.year, dueDate.month + 1);
      }
    }
  }

  static void gerarParcelaDiaSemana({
    int nroparcelas = 1,
    required bool mesSeguinte,
    int carencia = 0,
    required int ordsemana,
    required int idParcelaItem,
    required String diaDoVencimentoFixo,
  }) {
    DateTime dueDate;
    DateTime nowDate = DateTime.now();
    List<DateTime> datesVencimento = [];
    final day = nowDate.day + carencia;
    DateTime dataBase =
        DateTime(nowDate.year, nowDate.month).add(Duration(days: day));
    final String diaSemana = diaDoVencimentoFixo;
    late int weekdayDate;

    switch (diaSemana) {
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
      //select * from portionItem pi  verificar se idParcela > 1

      if (mesSeguinte && idParcelaItem > 1) {
        dataBase = DateTime(dataBase.year, dataBase.month + 1, dataBase.day);
      }

      final ordemSemanaAtual = DateTime(dataBase.year, dataBase.month);
      late DateTime ordemSemanaAtual2;

      for (int i = 1; i <= ordsemana; i++) {
        ordemSemanaAtual2 = getNextWeekDay(
            weekDay: weekdayDate, specificDate: ordemSemanaAtual);
      }

      if (dataBase.isBefore(ordemSemanaAtual2)) {
        dataBase = DateTime(dataBase.year, dataBase.month + 1, dataBase.day);
      }

      DateTime? vencimento;

      for (int i = 1; i <= nroparcelas; i++) {
        for (int i = 1; i <= ordsemana; i++) {
          vencimento = getNextWeekDay(
              weekDay: weekdayDate, specificDate: vencimento ?? dataBase);
        }

        datesVencimento.add(vencimento!);

        vencimento = DateTime(vencimento.year, vencimento.month + 1);
      }
    }

    final tt = datesVencimento;
  }

  static void gerarParcelaPorPeriodo({
    bool dtinvalida = false,
    String diasFixos = '',
    int carencia = 0,
    int ateDia = 0,
    bool mesSeguinte = false,
  }) {
    DateTime dueDate;
    DateTime nowDate = DateTime.now();

    if (dtinvalida) {
      dueDate = DateTime(nowDate.year, nowDate.month + 1);
    } else {
      dueDate = DateTime(nowDate.year, nowDate.month + 1)
          .subtract(const Duration(days: 1));
    }

    if ((mesSeguinte) && (dueDate.day <= ateDia)) {
      dueDate = DateTime(dueDate.year, dueDate.month + 1);
    } else if ((mesSeguinte) && (dueDate.day > ateDia)) {
      dueDate = DateTime(dueDate.year, dueDate.month + 2);
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
