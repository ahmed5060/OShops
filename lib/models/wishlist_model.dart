class WishlistModel {
  String? message;
  List<WishList>? wishList;

  WishlistModel({this.message, this.wishList});

  WishlistModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    if (json['wishList'] != null) {
      wishList = <WishList>[];
      json['wishList'].forEach((v) {
        wishList!.add(WishList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    if (wishList != null) {
      data['wishList'] = wishList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class WishList {
  String? sId;
  String? productName;
  String? productImageURL;
  dynamic price;
  int? rate;
  bool? inStock;
  bool? topProduct;
  String? storeId;
  String? categoryId;
  int? iV;
  int? productAmount;

  WishList(
      {this.sId,
      this.productName,
      this.productImageURL,
      this.price,
      this.rate,
      this.inStock,
      this.topProduct,
      this.storeId,
      this.categoryId,
      this.iV});

  WishList.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    productName = json['productName'];
    productImageURL = json['productImageURL'];
    price = json['price'];
    rate = json['rate'];
    inStock = json['inStock'];
    topProduct = json['topProduct'];
    storeId = json['storeId'];
    categoryId = json['categoryId'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['productName'] = productName;
    data['productImageURL'] = productImageURL;
    data['price'] = price;
    data['rate'] = rate;
    data['inStock'] = inStock;
    data['topProduct'] = topProduct;
    data['storeId'] = storeId;
    data['categoryId'] = categoryId;
    data['__v'] = iV;
    return data;
  }
}
