import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:interview_task/model.dart';
import 'package:interview_task/modules/home/controller/gome_screen_controller.dart';


class HomeScreen extends StatelessWidget {
  final CategoryController categoryController = Get.put(CategoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<CategoryModel>>(
        future: categoryController.fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No categories found.'));
          }

          final categories = snapshot.data!;

          return DefaultTabController(
            length: categories.length,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                title: Text(
                  'ESPTILES',
                  style: Theme.of(context)
                      .textTheme
                      .bodyLarge!
                      .copyWith(color: Colors.white),
                ),
                centerTitle: true,
                actions: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.filter_alt_outlined,
                      color: Colors.white,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: Colors.white,
                    ),
                  ),
                ],
                bottom: TabBar(
                  isScrollable: true,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  tabs: categories.map((category) {
                    return Tab(text: category.name);
                  }).toList(),
                ),
              ),
              body: TabBarView(
                children: categories.map((category) {
                  return SubCategoryList(category: category);
                }).toList(),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SubCategoryList extends StatefulWidget {
  final CategoryModel category;

  const SubCategoryList({Key? key, required this.category}) : super(key: key);

  @override
  _SubCategoryListState createState() => _SubCategoryListState();
}

class _SubCategoryListState extends State<SubCategoryList> {
  final CategoryController categoryController = Get.find();
  final ScrollController _scrollController = ScrollController();
  int _pageIndex = 1;

  @override
  void initState() {
    super.initState();
    _fetchSubCategories();
    _scrollController.addListener(_onScroll);
  }

  void _fetchSubCategories() {
    categoryController.fetchSubCategories(
        categoryId: widget.category.id, pageIndex: _pageIndex);
  }

  void _onScroll() {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels != 0) {
        setState(() {
          _pageIndex++;
          _fetchSubCategories();
        });
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (categoryController.isLoading.value && _pageIndex == 1) {
        return const Center(child: CircularProgressIndicator());
      }

      if (categoryController.subCategories.isEmpty) {
        return const Center(child: Text('No subcategories found.'));
      }

      return ListView.builder(
        controller: _scrollController,
        itemCount: categoryController.subCategories.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          SubCategoryModel subdata = categoryController.subCategories[index];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                subdata.name,
                style: Theme
                    .of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 5),
              FutureBuilder<List<ProductModel>>(
                future: categoryController.fetchProducts(
                    subCategoryId: subdata.id, pageIndex: 1),
                builder: (context, productSnapshot) {
                  if (productSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (productSnapshot.hasError) {
                    return Text('Error: ${productSnapshot.error}');
                  } else if (!productSnapshot.hasData ||
                      productSnapshot.data!.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }

                  return SizedBox(
                    height: 200,
                    child: ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      separatorBuilder: (context, index) =>
                      const SizedBox(width: 20),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: productSnapshot.data!.length,
                      itemBuilder: (context, index) {
                        ProductModel data = productSnapshot.data![index];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: 150,
                                  width: 150,
                                  child: Image.network(
                                    data.imageName,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  left: 10,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 5),
                                    decoration: BoxDecoration(
                                      color: Colors.lightBlue,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      data.priceCode,
                                      style: Theme
                                          .of(context)
                                          .textTheme
                                          .bodyMedium!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
                            Text(
                              data.name,
                              style: Theme
                                  .of(context)
                                  .textTheme
                                  .bodySmall,
                            ),
                          ],
                        );
                      },
                    ),
                  );
                },
              ),
            ],
          );
        },
      ).paddingSymmetric(horizontal: 10, vertical: 20);
    });
  }
}