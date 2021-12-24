// ignore_for_file: unnecessary_this

class SpecialStoreModel {
  int? status;
  String? message;
  List<Store>? store;

  SpecialStoreModel({this.status, this.message, this.store});

  SpecialStoreModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['store'] != null) {
      store = <Store>[];
      json['store'].forEach((v) {
        store!.add(Store.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.store != null) {
      data['store'] = this.store!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Store {
  String? sId;
  String? storeName;
  String? storeLogoURL;
  List<int>? telephoneNumber;
  String? website;
  List<StoreCategories>? storeCategories;
  int? iV;

  Store(
      {this.sId,
      this.storeName,
      this.storeLogoURL,
      this.telephoneNumber,
      this.website,
      this.storeCategories,
      this.iV});

  Store.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    storeName = json['storeName'];
    storeLogoURL = json['storeLogoURL'];
    telephoneNumber = json['telephoneNumber'].cast<int>();
    website = json['website'];
    if (json['storeCategories'] != null) {
      storeCategories = <StoreCategories>[];
      json['storeCategories'].forEach((v) {
        storeCategories!.add(StoreCategories.fromJson(v));
      });
    }
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = this.sId;
    data['storeName'] = this.storeName;
    data['storeLogoURL'] = this.storeLogoURL;
    data['telephoneNumber'] = this.telephoneNumber;
    data['website'] = this.website;
    if (this.storeCategories != null) {
      data['storeCategories'] =
          this.storeCategories!.map((v) => v.toJson()).toList();
    }
    data['__v'] = this.iV;
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
