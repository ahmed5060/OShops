// ignore_for_file: unnecessary_new

class StoriesModel {
  int? status;
  String? message;
  int? totalRes;
  int? totalPages;
  List<AllStores>? allStores;

  StoriesModel(
      {this.status,
      this.message,
      this.totalRes,
      this.totalPages,
      this.allStores});

  StoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    totalRes = json['totalRes'];
    totalPages = json['totalPages'];
    if (json['allStores'] != null) {
      allStores = <AllStores>[];
      json['allStores'].forEach((v) {
        allStores!.add(new AllStores.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    data['totalRes'] = totalRes;
    data['totalPages'] = totalPages;
    if (allStores != null) {
      data['allStores'] = allStores!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AllStores {
  String? sId;
  String? storeName;
  String? storeLogoURL;
  List<int>? telephoneNumber;
  String? website;
  int? iV;

  AllStores(
      {this.sId,
      this.storeName,
      this.storeLogoURL,
      this.telephoneNumber,
      this.website,
      this.iV});

  AllStores.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    storeName = json['storeName'];
    storeLogoURL = json['storeLogoURL'];
    telephoneNumber = json['telephoneNumber'].cast<int>();
    website = json['website'];
    iV = json['__v'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['storeName'] = storeName;
    data['storeLogoURL'] = storeLogoURL;
    data['telephoneNumber'] = telephoneNumber;
    data['website'] = website;
    data['__v'] = iV;
    return data;
  }
}
