import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:n7bluetooth/pages/detail_info/detail_info_provider.dart';
import 'package:n7bluetooth/services/dynamic_size.dart';
import 'package:n7bluetooth/utils/app_asset.dart';
import 'package:n7bluetooth/utils/app_color.dart';
import 'package:n7bluetooth/utils/app_extension.dart';
import 'package:n7bluetooth/utils/app_style.dart';

class DetailInfoPage extends StatefulWidget {

  final List<Color> availableColors = <Color>[
    Colors.purpleAccent,
    Colors.yellow,
    Colors.lightBlue,
    Colors.orange,
    Colors.pink,
    Colors.redAccent,
  ];


  @override
  _DetailInfoPageState createState() => _DetailInfoPageState();
}

class _DetailInfoPageState extends State<DetailInfoPage> with DynamicSize {

  //#region public properties
  //-----------------
  final Color barBackgroundColor = const Color(0xff72d8bf);
  final Duration animDuration = const Duration(milliseconds: 250);
  int touchedIndex;
  bool isPlaying = false;

  //#region Life cycles
  //-----------------
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async{
      await Provider.of<DetailInfoProvider>(context, listen: false).readInfoFromBLEDevice();
      Provider.of<DetailInfoProvider>(context, listen: false).loadWeightChartData();
    });
  }

  //#region METHOD
  //-----------------


  //#region BUILD
  //-----------------
  @override
  Widget build(BuildContext context) {
    //Init screen dynamic size
    initDynamicSize(context);
    return Material(
      child: Container(
        color: AppColors.mainBackgroundColor,
        child: Column(
          children: <Widget>[
            SizedBox(height: 61.H,),
            Stack(
              children: <Widget>[
                Positioned(
                  left: 30.W,
                  child: InkWell(
                    child: Container(
                      width: 30.W,
                      height: 30.W,
                      child: Image.asset(AppImages.icBack),
                    ),
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                Center(
                  child: Text('Weight', style: normalTextStyle(50.SP, color: Colors.white),),
                ),
              ],
            ),
            SizedBox(height: 10.H,),
            Center(
              child: Text('Average Weight (November 2020)', style: normalTextStyle(14.SP, color: const Color(0xFF6E737E)),),
            ),
            SizedBox(height: 40.H,),
            Center(
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Center(
                    child: Container(
                      width: 220.W,
                      height: 220.W,
                      child: Image.asset(AppImages.icFrameInfoDetail),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Selector<DetailInfoProvider, double>(
                          selector: (_, DetailInfoProvider provider) => provider.weightValue,
                          builder: (_, double weightValue ,__) {
                            return Text('$weightValue', style: normalTextStyle(70.SP, color: Colors.white),);
                          }
                        ),
                        SizedBox(height: 8.H,),
                        Text('kg', style: normalTextStyle(18.SP, color: const Color(0xFF6D737A)),)
                      ],

                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10.H,),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 30),
                child: BarChart(
                  mainBarData(),
                  swapAnimationDuration: animDuration,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  BarChartGroupData makeGroupData(
      int x,
      double y, {
        bool isTouched = false,
        Color barColor = Colors.white,
        double width = 22,
        List<int> showTooltips = const <int>[],
      }) {
    return BarChartGroupData(
      x: x,
      barRods: <BarChartRodData>[
        BarChartRodData(
          y: isTouched ? y + 1 : y,
          colors: isTouched ? <Color>[Colors.yellow] : <Color>[barColor],
          width: width,
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            y: 100,
            colors: <Color>[barBackgroundColor],
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  // ignore: always_specify_types
  List<BarChartGroupData> showingGroups() => List.generate(7, (int i) {
    switch (i) {
      case 0:
        return makeGroupData(0, context.watch<DetailInfoProvider>().weightChartData[0], isTouched: i == touchedIndex);
      case 1:
        return makeGroupData(1, context.watch<DetailInfoProvider>().weightChartData[1], isTouched: i == touchedIndex);
      case 2:
        return makeGroupData(2, context.watch<DetailInfoProvider>().weightChartData[2], isTouched: i == touchedIndex);
      case 3:
        return makeGroupData(3, context.watch<DetailInfoProvider>().weightChartData[3], isTouched: i == touchedIndex);
      case 4:
        return makeGroupData(4, context.watch<DetailInfoProvider>().weightChartData[4], isTouched: i == touchedIndex);
      case 5:
        return makeGroupData(5, context.watch<DetailInfoProvider>().weightChartData[5], isTouched: i == touchedIndex);
      case 6:
        return makeGroupData(6, context.watch<DetailInfoProvider>().weightChartData[6], isTouched: i == touchedIndex);
      default:
        return null;
    }
  });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
            tooltipBgColor: Colors.blueGrey,
            getTooltipItem: (BarChartGroupData group, int groupIndex, BarChartRodData rod, int rodIndex) {
              String weekDay;
              switch (group.x.toInt()) {
                case 0:
                  weekDay = 'Sunday';
                  break;
                case 1:
                  weekDay = 'Monday';
                  break;
                case 2:
                  weekDay = 'Tuesday';
                  break;
                case 3:
                  weekDay = 'Wednesday';
                  break;
                case 4:
                  weekDay = 'Thursday';
                  break;
                case 5:
                  weekDay = 'Friday';
                  break;
                case 6:
                  weekDay = 'Saturday';
                  break;
              }
              return BarTooltipItem(
                  weekDay + '\n' + (rod.y - 1).toString(), const TextStyle(color: Colors.yellow));
            }),
        touchCallback: (BarTouchResponse barTouchResponse) {
          setState(() {
            if (barTouchResponse.spot != null &&
                barTouchResponse.touchInput is! FlPanEnd &&
                barTouchResponse.touchInput is! FlLongPressEnd) {
              touchedIndex = barTouchResponse.spot.touchedBarGroupIndex;
            } else {
              touchedIndex = -1;
            }
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          getTextStyles: (double value) =>
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          margin: 16,
          getTitles: (double value) {
            switch (value.toInt()) {
              case 0:
                return 'S';
              case 1:
                return 'M';
              case 2:
                return 'T';
              case 3:
                return 'W';
              case 4:
                return 'T';
              case 5:
                return 'F';
              case 6:
                return 'S';
              default:
                return '';
            }
          },
        ),
        leftTitles: SideTitles(
          showTitles: false,
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
    );
  }


  Future<dynamic> refreshState() async {
    setState(() {});
    await Future<dynamic>.delayed(animDuration + const Duration(milliseconds: 50));
    if (isPlaying) {
      refreshState();
    }
  }
}
