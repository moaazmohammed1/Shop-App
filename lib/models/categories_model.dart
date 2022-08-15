class CategoriesModel {
  bool? status;
  CategoriesData? categoriesData;
  CategoriesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    categoriesData =
        json['data'] != null ? CategoriesData.fromJson(json['data']) : null;
  }
}

class CategoriesData {
  int? currentPage;
  List<DataModel> data = [];

  CategoriesData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    json['data'].forEach((element) {
      data.add(DataModel.fromJson(element));
    });
  }
}

class DataModel {
  int? id;
  String? name;
  String? image;

  DataModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
  }
}
