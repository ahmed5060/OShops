// ignore_for_file: unnecessary_new, unnecessary_this

class Data {
  String? sId;
  String? productName;
  String? productImageURL;
  double? price;
  int? rate;
  bool? inStock;
  bool? topProduct;
  String? storeId;
  String? categoryId;
  int? iV;

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
    data['_id'] = this.sId;
    data['productName'] = this.productName;
    data['productImageURL'] = this.productImageURL;
    data['price'] = this.price;
    data['rate'] = this.rate;
    data['inStock'] = this.inStock;
    data['topProduct'] = this.topProduct;
    data['storeId'] = this.storeId;
    data['categoryId'] = this.categoryId;
    data['__v'] = this.iV;
    return data;
  }
}
