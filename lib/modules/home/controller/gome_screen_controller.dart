import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:interview_task/main.dart';
import 'package:interview_task/model.dart';


class CategoryController extends GetxController {
  var isLoading = true.obs;
  int currentPageIndex = 1;
  List<SubCategoryModel> subCategories = [];

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<List<CategoryModel>> fetchCategories() async {
    const url = 'http://esptiles.imperoserver.in/api/API/Product/DashBoard';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['Result']['Category'] as List;
      return data.map((json) => CategoryModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> fetchSubCategories(
      {required int categoryId, required int pageIndex}) async {
    try {
      final url = 'http://esptiles.imperoserver.in/api/API/Product/DashBoard';
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "CategoryId": categoryId,
          "PageIndex": pageIndex,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['Result']['Category'] as List;

        List<SubCategoryModel> newSubCategories = [];

        for (var json in data) {
          CategoryModel category = CategoryModel.fromJson(json);
          newSubCategories.addAll(category.subcategory);
        }

        if (pageIndex == 1) {
          subCategories = newSubCategories;
        } else {
          subCategories.addAll(newSubCategories);
        }

        isLoading.value = false;
        currentPageIndex = pageIndex;
      } else {
        throw Exception('Failed to load subcategories');
      }
    } catch (e) {
      isLoading.value = false;
      rethrow;
    }
  }

  Future<List<ProductModel>> fetchProducts(
      {required int subCategoryId, required int pageIndex}) async {
    try {
      final url = 'http://esptiles.imperoserver.in/api/API/Product/ProductList';
      final response = await http.post(
        Uri.parse(url),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode({
          "SubCategoryId": subCategoryId,
          "PageIndex": pageIndex,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['Result'] as List;
        final products =
        data.map((json) => ProductModel.fromJson(json)).toList();

        logger.d("=============${products[0].toJson()}");

        return products;
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      rethrow;
    }
  }
}