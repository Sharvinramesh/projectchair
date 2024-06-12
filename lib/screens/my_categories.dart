import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projectchair/datas/datamodel.dart';
import 'package:projectchair/datas/db/db_functions.dart';
import 'package:projectchair/screens/edit_category.dart';
import 'package:projectchair/screens/my_product.dart';
import 'package:projectchair/screens/structuredCodes/bottom_nav_dynamic.dart';
import 'package:projectchair/screens/structuredCodes/my_colors.dart';

class MyCategories extends StatefulWidget {
  final ValueNotifier<List<Categorymodel>> categoryListNotifier;

  const MyCategories({required this.categoryListNotifier, Key? key})
      : super(key: key);

  @override
  State<MyCategories> createState() => _MyCategoriesState();
}

class _MyCategoriesState extends State<MyCategories> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  List<Categorymodel> filteredCategories(
      List<Categorymodel> categoryList, String query) {
    return categoryList
        .where((category) =>
            category.categoryname.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MyColors.background,
        title: const Text(
          'Categories',
          style: TextStyle(fontSize: 25, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      backgroundColor: MyColors.background,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: 370,
              height: 50,
              child: TextFormField(
                controller: searchController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'no result found';
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.search),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: widget.categoryListNotifier,
              builder: (BuildContext context, List<Categorymodel> categoryList,
                  Widget? child) {
                List<Categorymodel> displayedCategories =
                    filteredCategories(categoryList, searchController.text);
                if (displayedCategories.isEmpty) {
                  return const Center(
                    child: Text('No results found'),
                  );
                }
                return CustomScrollView(
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.all(8),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 0.75,
                        ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            final category = displayedCategories[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => Myproduct(
                                          productListNotifier: productListNotifier,
                                          data: category,
                                        )));
                              },
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Image.file(
                                        File(category.imagepath),
                                        width: 180,
                                        height: 200,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 0,
                                        child: PopupMenuButton<String>(
                                          onSelected: (value) {
                                            if (value == 'edit') {
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                  builder: (context) => Myeditctgry(
                                                    category: category,
                                                  ),
                                                ),
                                              );
                                            } else if (value == 'delete') {
                                              showDialog(
                                                context: context,
                                                builder: (BuildContext context) {
                                                  return AlertDialog(
                                                    title: const Text("Delete Category"),
                                                    content: const Text("Are you sure want to delete"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(context).pop();
                                                        },
                                                        child: const Text('Cancel'),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          if (category.id != null) {
                                                            await deletectgrs(category.id!);
                                                            Navigator.of(context).pop();
                                                          } else {
                                                            print('Category ID is null');
                                                          }
                                                        },
                                                        child: const Text("Delete"),
                                                      )
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
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    category.categoryname,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: displayedCategories.length,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: const DynamicBottomNavigation(currentIndex: 0),
    );
  }
}
