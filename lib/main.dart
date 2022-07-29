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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'You have pushed the button this many times:',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Datas.generateParcelaPorPeriodo(
              nroparcelas: 5,
              mesSeguinte: false,
              prazoParcelas: [
                PrazoParcela(ateDia: 29, venc: 31),
              ],
              diaFixoDtVenda: true

              /*  prazoParcelas: [

            ],*/
              );
          // Datas.gerarParcelaDiaFixo(
          //   diasFixos: '15;30;',
          //   mesSeguinte: false,
          //   nroparcelas: 2,
          // );
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
