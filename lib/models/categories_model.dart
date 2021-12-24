// ignore_for_file: unnecessary_this

class CategoriesModel {
  int? status;
  String? message;
  int? totalRes;
  int? totalPages;
  List<StoreCategories>? storeCategories;

  CategoriesModel(
      {this.status,
      this.message,
      this.totalRes,
      this.totalPages,
      this.storeCategories});

  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalRes = json['totalRes'];
    totalPages = json['totalPages'];
    if (json['storeCategories'] != null) {
      storeCategories = <StoreCategories>[];
      json['storeCategories'].forEach((v) {
        storeCategories!.add(StoreCategories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    data['totalRes'] = this.totalRes;
    data['totalPages'] = this.totalPages;
    if (this.storeCategories != null) {
      data['storeCategories'] =
          this.storeCategories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StoreCategories {
  String? sId;
  String? categoryName;
  String? categoryImageURL;
  int? iV;

  StoreCategories(
      {this.sId, this.categoryName, this.categoryImageURL, this.iV});

  StoreCategories.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    categoryName = json['categoryName'];
    categoryImageURL = json['categoryImageURL'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['categoryName'] = this.categoryName;
    data['categoryImageURL'] = this.categoryImageURL;
    data['__v'] = this.iV;
    return data;
  }
}
