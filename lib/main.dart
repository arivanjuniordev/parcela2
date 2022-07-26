import 'package:flutter/material.dart';
import 'package:parcela2/datas.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(const MyApp());
}

extension DateTimeAddCalendarDays on DateTime {
  /// Adds a specified number of days to this [DateTime].
  ///
  /// Unlike `DateTime.add(Duration(days: numberOfDays))`, this adds "days"
  /// and not 24-hour increments, and therefore it leaves the time of day
  /// unchanged if a DST change would occur during the time interval.
  DateTime addCalendarDays(int numDays) => copyWith(day: day + numDays);

  /// Copies a [DateTime], overriding specified values.
  DateTime copyWith({
    int? year,
    int? month,
    int? day,
    int? hour,
    int? minute,
    int? second,
    int? millisecond,
    int? microsecond,
  }) {
    return (isUtc ? DateTime.utc : DateTime.new)(
      year ?? this.year,
      month ?? this.month,
      day ?? this.day,
      hour ?? this.hour,
      minute ?? this.minute,
      second ?? this.second,
      millisecond ?? this.millisecond,
      microsecond ?? this.microsecond,
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Datas.gerarParcelaDiaSemana(
          //   nroparcelas: 2,
          //   idParcelaItem: 1,
          //   mesSeguinte: false,
          //   ordsemana: 2,
          //   diaDoVencimentoFixo: 'E',
          // );

          var now = DateTime.now();
          String formatDate(DateTime dateTime) =>
              DateFormat('dd MMM').format(dateTime);

          var firstOfMonth = DateTime(now.year, now.month, 1);
          var firstMonday = firstOfMonth.addCalendarDays(
              (7 - (firstOfMonth.weekday - DateTime.monday)) % 7);
          var currentMonday = firstMonday;
          while (currentMonday.month == now.month) {
            var nextMonday = currentMonday.addCalendarDays(7);
            var nextSunday = nextMonday.addCalendarDays(-1);
            print('${formatDate(currentMonday)} - ${formatDate(nextSunday)}');
            currentMonday = nextMonday;
          }
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
