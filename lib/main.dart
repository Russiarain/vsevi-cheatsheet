import 'package:vsevi_cheatsheet/opening_function.dart';
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
  static const oatBoundCooling = [-25.0, 35.0];
  static const ewtBoundCooling = [15.0, 55.0];
  static const spdBoundCooling = [30.0, 95.0];
  static const oatBoundHeating = [-25.0, 30.0];
  static const ewtBoundHeating = [25.0, 50.0];
  static const spdBoundHeating = [30.0, 60.0];

  static const axisDivisions = 600;

  final oatXCooling = List.generate(
      axisDivisions,
      (index) =>
          oatBoundCooling[0] +
          (oatBoundCooling[1] - oatBoundCooling[0]) *
              index /
              (axisDivisions - 1));
  final ewtXCooling = List.generate(
      axisDivisions,
      (index) =>
          ewtBoundCooling[0] +
          (ewtBoundCooling[1] - ewtBoundCooling[0]) *
              index /
              (axisDivisions - 1));
  final spdXCooling = List.generate(
      axisDivisions,
      (index) =>
          spdBoundCooling[0] +
          (spdBoundCooling[1] - spdBoundCooling[0]) *
              index /
              (axisDivisions - 1));
  final oatXHeating = List.generate(
      axisDivisions,
      (index) =>
          oatBoundHeating[0] +
          (oatBoundHeating[1] - oatBoundHeating[0]) *
              index /
              (axisDivisions - 1));
  final ewtXHeating = List.generate(
      axisDivisions,
      (index) =>
          ewtBoundHeating[0] +
          (ewtBoundHeating[1] - ewtBoundHeating[0]) *
              index /
              (axisDivisions - 1));
  final spdXHeating = List.generate(
      axisDivisions,
      (index) =>
          spdBoundHeating[0] +
          (spdBoundHeating[1] - spdBoundHeating[0]) *
              index /
              (axisDivisions - 1));
  late double ewt;
  late double oat;
  late double compSpd;

  var mode = RunMode.cooling;

  late double opening;

  final ewtTextController = TextEditingController();
  final oatTextController = TextEditingController();
  final compSpdTextController = TextEditingController();

  List<Color> gradientColors = const [
    Color(0xff23b6e6),
    Color(0xff02d39a),
  ];
  List<Color> ewtColors = const [
    Color.fromARGB(255, 210, 41, 11),
    Color.fromARGB(255, 137, 226, 4),
  ];
  List<Color> spdColors = const [
    Color.fromARGB(255, 51, 35, 230),
    Color.fromARGB(255, 225, 71, 138),
  ];

  @override
  void initState() {
    super.initState();

    setValueDefault();

    ewtTextController.addListener(updateOpening);
    oatTextController.addListener(updateOpening);
    compSpdTextController.addListener(updateOpening);
    updateOpening();
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
      opening = mode == RunMode.cooling
          ? initCooling(oat, ewt, compSpd)
          : initHeating(oat, ewt, compSpd);
    });
  }

  void setValueDefault() {
    if (mode == RunMode.cooling) {
      oat = (oatBoundCooling[0] + oatBoundCooling[1]) / 2;
      ewt = (ewtBoundCooling[0] + ewtBoundCooling[1]) / 2;
      compSpd = (spdBoundCooling[0] + spdBoundCooling[1]) / 2;
    } else {
      oat = (oatBoundHeating[0] + oatBoundHeating[1]) / 2;
      ewt = (ewtBoundHeating[0] + ewtBoundHeating[1]) / 2;
      compSpd = (spdBoundHeating[0] + spdBoundHeating[1]) / 2;
    }
    ewtTextController.text = ewt.toStringAsFixed(2);
    oatTextController.text = oat.toStringAsFixed(2);
    compSpdTextController.text = compSpd.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final coolingAdjustable = Column(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: DataAdjustable(
              lowerLimit: oatBoundCooling[0],
              upperLimit: oatBoundCooling[1],
              name: 'OAT',
              value: oat,
              textController: oatTextController,
              onSliderChanged: (val) {
                setState(() {
                  oat = val;
                  oatTextController.text = val.toStringAsFixed(2);
                });
              }),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: DataAdjustable(
              lowerLimit: ewtBoundCooling[0],
              upperLimit: ewtBoundCooling[1],
              name: 'EWT',
              value: ewt,
              textController: ewtTextController,
              onSliderChanged: (val) {
                setState(() {
                  ewt = val;
                  ewtTextController.text = val.toStringAsFixed(2);
                });
              }),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: DataAdjustable(
              lowerLimit: spdBoundCooling[0],
              upperLimit: spdBoundCooling[1],
              name: 'CompSpd',
              value: compSpd,
              textController: compSpdTextController,
              onSliderChanged: (val) {
                setState(() {
                  compSpd = val;
                  compSpdTextController.text = val.toStringAsFixed(2);
                });
              }),
        ),
      ],
    );

    final heatingAdjustable = Column(
      children: [
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: DataAdjustable(
              lowerLimit: oatBoundHeating[0],
              upperLimit: oatBoundHeating[1],
              name: 'OAT',
              value: oat,
              textController: oatTextController,
              onSliderChanged: (val) {
                setState(() {
                  oat = val;
                  oatTextController.text = val.toStringAsFixed(2);
                });
              }),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: DataAdjustable(
              lowerLimit: ewtBoundHeating[0],
              upperLimit: ewtBoundHeating[1],
              name: 'EWT',
              value: ewt,
              textController: ewtTextController,
              onSliderChanged: (val) {
                setState(() {
                  ewt = val;
                  ewtTextController.text = val.toStringAsFixed(2);
                });
              }),
        ),
        Flexible(
          flex: 1,
          fit: FlexFit.tight,
          child: DataAdjustable(
              lowerLimit: spdBoundHeating[0],
              upperLimit: spdBoundHeating[1],
              name: 'CompSpd',
              value: compSpd,
              textController: compSpdTextController,
              onSliderChanged: (val) {
                setState(() {
                  compSpd = val;
                  compSpdTextController.text = val.toStringAsFixed(2);
                });
              }),
        ),
      ],
    );

    return Scaffold(
      body: Row(
        children: [
          Flexible(
            flex: 6,
            fit: FlexFit.tight,
            child: Column(
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
                                      if (mode != RunMode.cooling) {
                                        setState(() {
                                          mode = RunMode.cooling;
                                          setValueDefault();
                                        });
                                        updateOpening();
                                      }
                                    }),
                              ),
                              Flexible(
                                flex: 1,
                                fit: FlexFit.tight,
                                child: RunModeCard(
                                    mode: mode,
                                    thisMode: RunMode.heating,
                                    onTap: () {
                                      if (mode != RunMode.heating) {
                                        setState(() {
                                          mode = RunMode.heating;
                                          setValueDefault();
                                        });
                                        updateOpening();
                                      }
                                    }),
                              ),
                            ],
                          ),
                        ),
                        Flexible(
                          flex: 2,
                          fit: FlexFit.tight,
                          child: mode == RunMode.cooling
                              ? coolingAdjustable
                              : heatingAdjustable,
                        ),
                      ],
                    )),
                Flexible(
                    flex: 4,
                    child: Center(
                        child: Text(
                      opening.toStringAsFixed(2),
                      textScaleFactor: 12,
                    )))
              ],
            ),
          ),
          Flexible(
              flex: 4,
              fit: FlexFit.tight,
              child: Column(
                children: [
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LineChart(LineChartData(
                            titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                    axisNameSize: 36,
                                    axisNameWidget: Text(
                                      'OAT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ))),
                            lineBarsData: [
                              LineChartBarData(
                                spots: mode == RunMode.cooling
                                    ? oatXCooling
                                        .map((e) => FlSpot(
                                            e, initCooling(e, ewt, compSpd)))
                                        .toList()
                                    : oatXHeating
                                        .map((e) => FlSpot(
                                            e, initHeating(e, ewt, compSpd)))
                                        .toList(),
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
                            ])),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LineChart(LineChartData(
                            titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                    axisNameSize: 36,
                                    axisNameWidget: Text(
                                      'EWT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ))),
                            lineBarsData: [
                              LineChartBarData(
                                spots: mode == RunMode.cooling
                                    ? ewtXCooling
                                        .map((e) => FlSpot(
                                            e, initCooling(oat, e, compSpd)))
                                        .toList()
                                    : ewtXHeating
                                        .map((e) => FlSpot(
                                            e, initHeating(oat, e, compSpd)))
                                        .toList(),
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: ewtColors,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                barWidth: 5,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                              )
                            ])),
                      )),
                  const SizedBox(
                    height: 12,
                  ),
                  Flexible(
                      flex: 1,
                      fit: FlexFit.tight,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LineChart(LineChartData(
                            titlesData: FlTitlesData(
                                topTitles: AxisTitles(
                                    axisNameSize: 36,
                                    axisNameWidget: Text(
                                      'CompSpd',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge,
                                    ))),
                            lineBarsData: [
                              LineChartBarData(
                                spots: mode == RunMode.cooling
                                    ? spdXCooling
                                        .map((e) =>
                                            FlSpot(e, initCooling(oat, ewt, e)))
                                        .toList()
                                    : spdXHeating
                                        .map((e) =>
                                            FlSpot(e, initHeating(oat, ewt, e)))
                                        .toList(),
                                isCurved: true,
                                gradient: LinearGradient(
                                  colors: spdColors,
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                barWidth: 5,
                                isStrokeCapRound: true,
                                dotData: FlDotData(
                                  show: false,
                                ),
                              )
                            ])),
                      )),
                ],
              )),
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
      margin: const EdgeInsets.all(4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
            ? Theme.of(context).colorScheme.primaryContainer
            : Theme.of(context).colorScheme.background,
        child: SizedBox(
            width: double.infinity,
            child: Center(
                child: Text(
              thisMode == RunMode.cooling ? 'Cooling' : 'Heating',
              style: Theme.of(context).textTheme.displayLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onPrimaryContainer),
            ))),
      ),
    );
  }
}
