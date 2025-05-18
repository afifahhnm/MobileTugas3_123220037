class Clothes {
  final int? id;
  final String? name;
  final int? price;
  final String? category;
  final String? brand;
  final int? sold;
  final double? rating;
  final int? stock;
  final int? yearReleased;
  final String? material;

  Clothes({
    this.id,
    this.name,
    this.price,
    this.category,
    this.brand,
    this.sold,
    this.rating,
    this.stock,
    this.yearReleased,
    this.material,
  });

  factory Clothes.fromJson(Map<String, dynamic> json) {
    return Clothes(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      brand: json['brand'],
      sold: json['sold'],
      rating: (json['rating'] as num?)?.toDouble(),
      stock: json['stock'],
      yearReleased: json['yearReleased'],
      material: json['material'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "price": price,
      "category": category,
      "brand": brand,
      "sold": sold,
      "rating": rating,
      "stock": stock,
      "yearReleased": yearReleased,
      "material": material,
    };
  }
}

class ClothesModel {
  final String? status;
  final String? message;
  final List<Clothes>? data;

  ClothesModel({this.status, this.message, this.data});

  factory ClothesModel.fromJson(Map<String, dynamic> json) {
    return ClothesModel(
      status: json['status'],
      message: json['message'],
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => Clothes.fromJson(e))
          .toList(),
    );
  }
}
