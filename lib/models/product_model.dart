class ProductModel {
  int? status;
  String? message;
  int? totalRes;
  int? totalPages;
  List<AllProducts>? allProducts;

  ProductModel(
      {this.status,
      this.message,
      this.totalRes,
      this.totalPages,
      this.allProducts});

  ProductModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalRes = json['totalRes'];
    totalPages = json['totalPages'];
    if (json['allProducts'] != null) {
      allProducts = <AllProducts>[];
      json['allProducts'].forEach((v) {
        allProducts!.add(AllProducts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['totalRes'] = totalRes;
    data['totalPages'] = totalPages;
    if (allProducts != null) {
      data['allProducts'] = allProducts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllProducts {
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

  AllProducts(
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

  AllProducts.fromJson(Map<String, dynamic> json) {
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
