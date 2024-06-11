import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/recent_bills.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';

class RecentSales extends StatelessWidget {
  final int filterIndex;

  const RecentSales({Key? key, required this.filterIndex}) : super(key: key);

  List<SellProduct> getFilteredSellProducts(List<SellProduct> sellProducts) {
    if (filterIndex == 2) {
      return sellProducts;
    } else {
      DateTime currentDate = DateTime.now();
      DateTime filterDate =
          currentDate.subtract(Duration(days: filterIndex == 0 ? 6 : 29));
      return sellProducts
          .where((product) => product.sellDate!.isAfter(filterDate))
          .toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: MyColors.background,
        title: const Text(
          'Recent Sales',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: MyColors.background,
      body: FutureBuilder<Box<SellProduct>>(
        future: Hive.openBox<SellProduct>('sell_products'),
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
            List<SellProduct> sellProducts = snapshot.data!.values.toList();
            List<SellProduct> filteredSellProducts =
                getFilteredSellProducts(sellProducts);

            return ListView.builder(
              itemCount: filteredSellProducts.length,
              itemBuilder: (context, index) {
                SellProduct product = filteredSellProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => SellDetails(
                            selectedProducts: productListNotifier.value)));
                  },
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 5),
                    height: 130,
                    width: double.infinity,
                    child: Card(
                      color: Colors.black,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 15),
                      child: ListTile(
                        title: Text(
                          product.sellName,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        subtitle: Text(
                          'Sold on: ${DateFormat.yMMMd().format(product.sellDate!)}',
                          style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        trailing: Text('₹ ${product.sellPrice}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white)),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
