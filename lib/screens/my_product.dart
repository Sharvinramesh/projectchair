// ignore_for_file: file_names

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/add_product.dart';
import 'package:projectchair/screens/edit_products.dart';
import 'package:projectchair/screens/product_detail.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';

class Myproduct extends StatefulWidget {
  final ValueNotifier<List<Productmodel>> productListNotifier;
  final Categorymodel data;

  const Myproduct(
      {required this.productListNotifier, Key? key, required this.data})
      : super(key: key);

  @override
  State<Myproduct> createState() => _MyproductState();
}

class _MyproductState extends State<Myproduct> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getProductsByCategory(widget.data.categoryname);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.background,
        centerTitle: true,
        title: Text(
          widget.data.categoryname,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
        ),
      ),
      backgroundColor: MyColors.background,
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  height: 50,
                  width: 375,
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      labelText: 'Search by product name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      // Calling a method to update the product list based on the search query
                      updateProductList(value);
                    },
                  ),
                ),
              ],
            ),
            Expanded(
              child: ValueListenableBuilder<List<Productmodel>>(
                valueListenable: widget.productListNotifier,
                builder: (BuildContext context, List<Productmodel>? productList,
                    Widget? child) {
                  if (productList?.isEmpty ?? true) {
                    return const Center(
                      child: Text('No products found'),
                    );
                  }
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8,
                        crossAxisSpacing: 8,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: productList?.length ?? 0,
                      itemBuilder: (BuildContext context, int index) {
                        Allproduct.product.add(productList![index]);
                        return GridTile(
                          footer: GridTileBar(
                            backgroundColor: Colors.black45,
                            title: Text(productList[index].productname!),
                            subtitle: Text(
                                '₹ ${productList[index].sellingrate ?? ''}'),
                          ),
                          child: Stack(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showModalBottomSheet(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Productdetail(
                                          data: productList[index]);
                                    },
                                  );
                                },
                                child: Image.file(
                                  File(productList[index].image ?? ''),
                                  fit: BoxFit.cover,
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: 0,
                                child: PopupMenuButton<String>(
                                  onSelected: (value) {
                                    if (value == 'edit') {
                                      Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Myeditproducts(
                                                    categoryid: widget
                                                        .data.categoryname,
                                                    data: productList[index])),
                                      );
                                    } else if (value == 'delete') {
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Delete Product'),
                                            content: const Text(
                                                'Are you sure you want to delete this product?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  deleteproduct(
                                                      productList[index].id ??
                                                          0);
                                                  Navigator.of(context).pop();
                                                },
                                                child: const Text('Delete'),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    }
                                  },
                                  itemBuilder: (BuildContext context) {
                                    return {'edit', 'delete'}
                                        .map((String choice) {
                                      return PopupMenuItem<String>(
                                        value: choice,
                                        child: Text(choice),
                                      );
                                    }).toList();
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FloatingActionButton(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => Addproduct(
                              categoryname: widget.data.categoryname,
                            )));
                  },
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    size: 40,
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  // Fetch products by category ID
  Future<void> getProductsByCategory(String categoryname) async {
    List<Productmodel> products = await fetchProductsByCategory(categoryname);
    widget.productListNotifier.value = products;
  }

  Future<List<Productmodel>> fetchProductsByCategory(
      String categoryname) async {
    final productBox = await Hive.openBox<Productmodel>('product_db');
    final productList = productBox.values
        .where((product) => product.categoryname == categoryname)
        .toList();
    // ignore: avoid_print
    print(
        'Fetched products for category: $categoryname'); // Add this line for debugging
    return productList;
  }

  // Update product list based on search query
  void updateProductList(String query) {
    if (query.isEmpty) {
      getProductsByCategory(widget.data.categoryname);
    } else {
      final List<Productmodel> filteredList = widget.productListNotifier.value
          .where((product) =>
              product.productname!.toLowerCase().contains(query.toLowerCase()))
          .toList();
      widget.productListNotifier.value = filteredList;
    }
  }
}
