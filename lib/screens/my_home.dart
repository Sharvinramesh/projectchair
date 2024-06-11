// ignore_for_file: file_names, prefer_const_constructors, unnecessary_null_comparison, prefer_final_fields, avoid_print, unnecessary_brace_in_string_interps, invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member, unused_field

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/recent_bills.dart';
import 'package:projectchair/screens/stock_updates.dart';
import 'package:projectchair/screens/revenue_details.dart';
import 'package:projectchair/screens/structuredCodes/bottom_nav_dynamic.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  double _totalRevenue = 0.00;
  int productCount = 0;
  List<Productmodel> selectedProducts = [];

  @override
  void initState() {
    super.initState();
    Hive.openBox<Productmodel>('product_db');
    initData();
  }

  Future<void> initData() async {
    await getProductCount();
  }

  Future<void> getProductCount() async {
    try {
      final productBox = await Hive.openBox<Productmodel>('product_db');
      if (productBox != null) {
        setState(() {
          productCount = productBox.length;
        });
        print('Product count: $productCount');
      } else {
        print('Error: productBox is null');
      }
    } catch (e) {
      print('Error fetching product count: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1A1A2E),
        title: const Text(
          'My Home',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFF1A1A2E),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProfitDetails()));
                          },
                          child: Container(
                            height: 155,
                            width: 375,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color(0xFF6A82FB),
                                  Color(0xFFFC5C7D),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Row(
                            children: const [
                              Icon(
                                Icons.currency_rupee,
                                size: 60,
                                color: Colors.white,
                              ),
                              Text(
                                'Revenue\n Details',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 50,
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 155,
                  width: 375,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: const [
                        Color(0xFF6A82FB),
                        Color(0xFFFC5C7D),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 4),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    child: const Padding(
                      padding: EdgeInsets.all(35),
                      child: Row(
                        children: [
                          Icon(
                            Icons.book,
                            size: 60,
                            color: Colors.white,
                          ),
                          Text(
                            "Recent\nBills",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SellDetails(
                            selectedProducts: selectedProducts,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Container(
                          height: 180,
                          width: 180,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: const [
                                Color(0xFF6A82FB),
                                Color(0xFFFC5C7D),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 4),
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Product\nCount: $productCount',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ProductUpdates()));
                          },
                          child: Container(
                            height: 180,
                            width: 180,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: const [
                                  Color(0xFF6A82FB),
                                  Color(0xFFFC5C7D),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(0, 4),
                                  blurRadius: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Text(
                                'Stock\nUpdates',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: DynamicBottomNavigation(currentIndex: 1),
    );
  }
}

Future<double> calculateTotalRevenue() async {
  final sellBox = await Hive.openBox<SellProduct>('sell_products');
  final sellProducts = sellBox.values.toList();

  double totalRevenue = 0.0;
  for (var product in sellProducts) {
    totalRevenue += product.sellPrice as double;
  }

  return totalRevenue;
}

Future<void> getallproduct() async {
  final productBox = await Hive.openBox<Productmodel>('product_db');
  final categoryList = List<Productmodel>.from(productBox.values);
  productListNotifier.value = [...categoryList];
  productListNotifier.notifyListeners();
}
