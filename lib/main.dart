import 'package:exv_opening/opening_function.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

enum RunMode {
  cooling,
  heating,
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '130 VHS EXV Initial Opening',
      theme: FlexThemeData.light(
        scheme: FlexScheme.materialBaseline,
        surfaceMode: FlexSurfaceMode.highBackgroundLowScaffold,
        blendLevel: 20,
        appBarOpacity: 0.95,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 20,
          blendOnColors: false,
          inputDecoratorRadius: 20.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      darkTheme: FlexThemeData.dark(
        scheme: FlexScheme.materialBaseline,
        surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
        blendLevel: 15,
        appBarStyle: FlexAppBarStyle.background,
        appBarOpacity: 0.90,
        subThemesData: const FlexSubThemesData(
          blendOnLevel: 30,
          inputDecoratorRadius: 20.0,
        ),
        visualDensity: FlexColorScheme.comfortablePlatformDensity,
        // To use the playground font, add GoogleFonts package and uncomment
        // fontFamily: GoogleFonts.notoSans().fontFamily,
      ),
      themeMode: ThemeMode.system,
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var ewt = 12.0;
  var oat = 20.0;
  var compSpd = 30.0;

  var mode = RunMode.cooling;

  var opening = 40.0;

  final ewtTextController = TextEditingController();
  final oatTextController = TextEditingController();
  final compSpdTextController = TextEditingController();

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  @override
  void initState() {
    super.initState();
    ewtTextController.text = ewt.toStringAsFixed(2);
    oatTextController.text = oat.toStringAsFixed(2);
    compSpdTextController.text = compSpd.toStringAsFixed(2);

    ewtTextController.addListener(updateOpening);
    oatTextController.addListener(updateOpening);
    compSpdTextController.addListener(updateOpening);
  }

  @override
  void dispose() {
    ewtTextController.removeListener(updateOpening);
    oatTextController.removeListener(updateOpening);
    compSpdTextController.removeListener(updateOpening);
    ewtTextController.dispose();
    oatTextController.dispose();
    compSpdTextController.dispose();
    super.dispose();
  }

  void updateOpening() {
    setState(() {
      opening = initCooling(oat, ewt, compSpd);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Flexible(
              flex: 6,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: RunModeCard(
                              mode: mode,
                              thisMode: RunMode.cooling,
                              onTap: () {
                                setState(() {
                                  mode = RunMode.cooling;
                                });
                              }),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: RunModeCard(
                              mode: mode,
                              thisMode: RunMode.heating,
                              onTap: () {
                                setState(() {
                                  mode = RunMode.heating;
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                  Flexible(
                    flex: 2,
                    fit: FlexFit.tight,
                    child: Column(
                      children: [
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DataAdjustable(
                              lowerLimit: -20,
                              upperLimit: 22,
                              name: 'OAT',
                              value: oat,
                              textController: oatTextController,
                              onSliderChanged: (val) {
                                setState(() {
                                  oat = val;
                                  oatTextController.text =
                                      val.toStringAsFixed(2);
                                });
                              }),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DataAdjustable(
                              lowerLimit: -20,
                              upperLimit: 22,
                              name: 'EWT',
                              value: ewt,
                              textController: ewtTextController,
                              onSliderChanged: (val) {
                                setState(() {
                                  ewt = val;
                                  ewtTextController.text =
                                      val.toStringAsFixed(2);
                                });
                              }),
                        ),
                        Flexible(
                          flex: 1,
                          fit: FlexFit.tight,
                          child: DataAdjustable(
                              lowerLimit: 30,
                              upperLimit: 60,
                              name: 'CompSpd',
                              value: compSpd,
                              textController: compSpdTextController,
                              onSliderChanged: (val) {
                                setState(() {
                                  compSpd = val;
                                  compSpdTextController.text =
                                      val.toStringAsFixed(2);
                                });
                              }),
                        ),
                      ],
                    ),
                  ),
                ],
              )),
          Flexible(
              flex: 4,
              child: Row(
                children: [
                  Flexible(
                    flex: 1,
                    fit: FlexFit.tight,
                    child: Center(
                        child: Text(
                      opening.toStringAsFixed(2),
                      textScaleFactor: 12,
                    )),
                  ),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: LineChart(LineChartData(lineBarsData: [
                        LineChartBarData(
                          spots: const [
                            FlSpot(0, 3),
                            FlSpot(2.6, 2),
                            FlSpot(4.9, 5),
                            FlSpot(6.8, 3.1),
                            FlSpot(8, 4),
                            FlSpot(9.5, 3),
                            FlSpot(11, 4),
                          ],
                          isCurved: true,
                          gradient: LinearGradient(
                            colors: gradientColors,
                            begin: Alignment.centerLeft,
                            end: Alignment.centerRight,
                          ),
                          barWidth: 5,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: false,
                          ),
                        )
                      ])))
                ],
              ))
        ],
      ),
    );
  }
}

class DataAdjustable extends StatelessWidget {
  const DataAdjustable(
      {Key? key,
      required this.lowerLimit,
      required this.upperLimit,
      required this.name,
      required this.value,
      required this.textController,
      required this.onSliderChanged})
      : super(key: key);

  final double lowerLimit;
  final double upperLimit;
  final String name;
  final double value;
  final TextEditingController textController;
  final void Function(double) onSliderChanged;

  String? dataValidate(String? val) {
    if (val != null) {
      if (val.isEmpty) {
        return 'Can not be empty';
      } else {
        final valNum = double.tryParse(val);
        if (valNum == null) {
          return 'Please input a number';
        } else {
          if (valNum > upperLimit || valNum < lowerLimit) {
            return 'Out of bound';
          }
        }
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.displayMedium,
                )),
            const SizedBox(
              width: 12,
            ),
            Flexible(
              flex: 3,
              fit: FlexFit.tight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: textController,
                    keyboardType: TextInputType.number,
                    validator: dataValidate,
                    onFieldSubmitted: (val) {
                      if (dataValidate(val) == null) {
                        onSliderChanged(double.parse(val));
                      }
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Slider(
                    label: value.toStringAsFixed(1),
                    value: value,
                    divisions: (upperLimit - lowerLimit) * 10 as int,
                    max: upperLimit,
                    min: lowerLimit,
                    onChanged: onSliderChanged,
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RunModeCard extends StatelessWidget {
  const RunModeCard(
      {Key? key,
      required this.mode,
      required this.thisMode,
      required this.onTap})
      : super(key: key);

  final RunMode mode;
  final RunMode thisMode;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16),
        color: mode == thisMode
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.secondary,
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text(
              thisMode == RunMode.cooling ? 'Cooling' : 'Heating',
              style: Theme.of(context).textTheme.displayLarge,
            ))),
      ),
    );
  }
}
