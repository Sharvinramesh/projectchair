// ignore_for_file: file_names

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/screens/recent_sales.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';

class ProfitDetails extends StatefulWidget {
  const ProfitDetails({Key? key}) : super(key: key);

  @override
  State<ProfitDetails> createState() => _ProfitDetailsState();
}

class _ProfitDetailsState extends State<ProfitDetails> {
  late Future<Box<SellProduct>> _sellProductsFuture;
  List<SellProduct> _sellProducts = [];
  int _selectedFilterIndex = 0; // Default filter: Last 7 days

  @override
  void initState() {
    super.initState();
    _sellProductsFuture = _initHive();
  }

  Future<Box<SellProduct>> _initHive() async {
    final sellProductsBox = await Hive.openBox<SellProduct>('sell_products');
    setState(() {
      _sellProducts = sellProductsBox.values.toList();
    });
    return sellProductsBox;
  }

  List<FlSpot> getWeeklyProfitData() {
    List<FlSpot> spots = [];
    DateTime currentDate = DateTime.now();
    for (int i = 0; i < 7; i++) {
      double totalProfit = 0.0;
      for (SellProduct product in _sellProducts) {
        if (product.sellDate!
            .isAfter(currentDate.subtract(const Duration(days: 6)))) {
          totalProfit += double.parse(product.sellPrice);
        }
      }
      spots.add(FlSpot(i.toDouble(), totalProfit));
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    return spots.reversed.toList();
  }

  List<FlSpot> getMonthlyProfitData() {
    List<FlSpot> spots = [];
    DateTime currentDate = DateTime.now();
    int daysInMonth = DateTime(currentDate.year, currentDate.month + 1, 0).day;
    double totalProfit = 0.0;
    for (int i = 0; i < daysInMonth; i++) {
      for (SellProduct product in _sellProducts) {
        if (product.sellDate!.month == currentDate.month &&
            product.sellDate!.year == currentDate.year &&
            product.sellDate!.day == currentDate.day) {
          totalProfit += double.parse(product.sellPrice);
        }
      }
      spots.add(FlSpot(i.toDouble(), totalProfit));
      totalProfit = 0.0;
      currentDate = currentDate.subtract(const Duration(days: 1));
    }
    return spots.reversed.toList();
  }

  List<SellProduct> getFilteredSellProducts() {
    if (_selectedFilterIndex == 2) {
      return _sellProducts;
    } else {
      DateTime currentDate = DateTime.now();
      DateTime filterDate = currentDate
          .subtract(Duration(days: _selectedFilterIndex == 0 ? 6 : 29));
      return _sellProducts
          .where((product) => product.sellDate!.isAfter(filterDate))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.background,
        centerTitle: true,
        title: const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Profit Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: FutureBuilder<Box<SellProduct>>(
        future: _sellProductsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            _sellProducts = snapshot.data!.values.toList();
            List<SellProduct> filteredSellProducts = getFilteredSellProducts();
            return filteredSellProducts.isEmpty
                ? const Center(
                    child: Text(
                      'No recent sales found.',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView(
                    children: [
                      SizedBox(
                        height: 250,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: LineChart(
                            LineChartData(
                              gridData: const FlGridData(
                                show: false,
                              ),
                              borderData: FlBorderData(
                                  show: true,
                                  border: Border.all(
                                      color: Colors.grey.withOpacity(0.3))),
                              minX: 0,
                              maxX: _selectedFilterIndex == 2
                                  ? (_sellProducts.isNotEmpty
                                      ? _sellProducts.length.toDouble() - 1
                                      : 1)
                                  : (_selectedFilterIndex == 0 ? 6 : 29)
                                      .toDouble(),
                              minY: 0,
                              maxY: 2500,
                              lineBarsData: [
                                LineChartBarData(
                                  spots: getWeeklyProfitData(),
                                  isCurved: true,
                                  color: Colors.blue.withOpacity(0.8),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.blue.withOpacity(0.3),
                                  ),
                                  dotData: const FlDotData(show: false),
                                ),
                                LineChartBarData(
                                  spots: getMonthlyProfitData(),
                                  isCurved: true,
                                  color: Colors.red.withOpacity(0.8),
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: Colors.red.withOpacity(0.3),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 30),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            DropdownButton<int>(
                              value: _selectedFilterIndex,
                              items: const [
                                DropdownMenuItem(
                                  value: 0,
                                  child: Text('Last 7 days'),
                                ),
                                DropdownMenuItem(
                                  value: 1,
                                  child: Text('Last 30 days'),
                                ),
                                DropdownMenuItem(
                                  value: 2,
                                  child: Text('All Sales'),
                                ),
                              ],
                              onChanged: (value) {
                                setState(() {
                                  _selectedFilterIndex = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => RecentSales(
                filterIndex: _selectedFilterIndex,
              ),
            ),
          );
        },
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }
}
