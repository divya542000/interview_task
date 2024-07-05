// To parse this JSON data, do
//
//     final categoryModel = categoryModelFromJson(jsonString);

import 'dart:convert';

CategoryModel categoryModelFromJson(String str) =>
CategoryModel.fromJson(json.decode(str));

String categoryModelToJson(CategoryModel data) => json.encode(data.toJson());

class CategoryModel {
final int id;
final String name;
final List<SubCategoryModel> subcategory;

CategoryModel({
this.id = 0,
this.name = '',
this.subcategory = const [],
});

factory CategoryModel.fromJson(Map<String, dynamic> json) {
return CategoryModel(
id: json['Id'] ?? 0,
name: json['Name'] ?? '',
subcategory: json["SubCategories"] == null
? []
    : List<SubCategoryModel>.from(
json["SubCategories"].map((x) => SubCategoryModel.fromJson(x))),
);
}

Map<String, dynamic> toJson() => {
"Id": id,
"Name": name,
};
}

class SubCategoryModel {
final int id;
final String name;
final List<ProductModel> products;

SubCategoryModel({
this.id = 0,
this.name = '',
this.products = const [],
});

factory SubCategoryModel.fromJson(Map<String, dynamic> json) =>
SubCategoryModel(
id: json["Id"] ?? 0,
name: json["Name"] ?? '',
products: json["Product"] == null
? []
    : List<ProductModel>.from(
json["Product"].map((x) => ProductModel.fromJson(x))),
);

Map<String, dynamic> toJson() => {
"Id": id,
"Name": name,
};
}

class ProductModel {
final int id;
final String name;
final String priceCode;
final String imageName;

ProductModel({
this.id = 0,
this.name = '',
this.priceCode = '',
this.imageName = '',
});

factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
id: json["Id"] ?? 0,
name: json["Name"] ?? '',
priceCode: json["PriceCode"] ?? '',
imageName: json["ImageName"] ?? '',
);

Map<String, dynamic> toJson() => {
"Id": id,
"Name": name,
"PriceCode": priceCode,
"ImageName": imageName,
};
}