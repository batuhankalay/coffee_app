import 'package:cloud_firestore/cloud_firestore.dart';

class Food {
  String? id;
  String? imgUrl;
  String? desc;
  String? name;
  String? waitTime;
  num? score;
  String? cal;
  num? price;
  num? quantity;
  String? about;
  bool? hightLight;
  String? category;

  Food({
    this.id,
    this.imgUrl,
    this.desc,
    this.name,
    this.waitTime,
    this.score,
    this.cal,
    this.price,
    this.about,
    this.hightLight,
    this.quantity,
    this.category,
  });

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id']??"",
      imgUrl: json['imgUrl'] ?? '',
      desc: json['desc'] ?? '',
      name: json['name'] ?? '',
      waitTime: json['waitTime'] ?? '',
      score: json['score'] ?? 0,
      cal: json['cal'] ?? '',
      price: (json['price'] ?? 0).toDouble(),
      quantity: json['quantity'] ?? 1,
      about: json['about'] ?? '',
      hightLight: json['hightLight'] ?? false,
      category: json['category'] ?? '',
    );
  }

  factory Food.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>?; 
    if (data == null) {
     
      return Food();
    }
    return Food.fromJson({
      ...data,
      'id': doc.id, 
    });
  }

  Map<String, dynamic> toJson() {
    return {
      'imgUrl': imgUrl,
      'desc': desc,
      'name': name,
      'waitTime': waitTime,
      'score': score,
      'cal': cal,
      'price': price,
      'quantity': quantity,
      'about': about,
      'hightLight': hightLight,
      'category': category,
    };
  }
}