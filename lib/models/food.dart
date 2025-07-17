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



/* 
  /* static List<Food> generateRecommendFoods(){
    return [
       /* Food(
        'assets/images/espresso.webp',
        'Sert içim, yoğun aroma',
        'Espresso',
        '50 dk',
        4.8,
        '325 kcal',
        150,
        1,
        [
          {
            'Küçük' : 'assets/images/boycafe.png'
          },
          {
            'Orta' : 'assets/images/boycafe.png'
          },
          {
            'Büyük' : 'assets/images/boycafe.png'
          },
          {
            'Extra' : 'assets/images/boycafe.png'
          },
        ],
        'Az miktarda, yoğun ve sert kahve. Kahve dünyasının temel taşı.', 
        hightLight: true), */

      /* Food(
        'assets/images/FullCoffeeCups_738x800_Americano.webp',
        'Hafif içim, sade tat',
        'Americano',
        '50 dk',
        4.8,
        '325 kcal',
        140,
        1,
        [
          {
            'Noodle' : 'assets/images/kahve.jpg'
          },
          {
            'Shrimp' : 'assets/images/kahve.jpg'
          },
          {
            'Egg' : 'assets/images/kahve.jpg'
          },
          {
            'Scallion' : 'assets/images/kahve.jpg'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true), */

     /* Food(
        'assets/images/latte.webp',
        'Yumuşak içim, sütlü dokunuş',
        'Latte',
        '50 dk',
        4.8,
        '325 kcal',
        130,
        1,
        [
          {
            'Noodle' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Shrimp' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Egg' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Scallion' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),

      Food(
        'assets/images/capci.webp',
        'Dengeli içim',
        'Cappuccino',
        '20 dk',
        4.8,
        '325 kcal',
        180,
        1,
        [
          {
            'Noodle' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Shrimp' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Egg' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Scallion' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),

      Food(
        'assets/images/moci.webp',
        'Tatlı içim, çikolata aromalı',
        'Mocha',
        '50 dk',
        4.8,
        '325 kcal',
        200,
        1,
        [
          {
            'Noodle' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Shrimp' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Egg' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
          {
            'Scallion' : 'assets/images/FullCoffeeCups_738x800_CAPPUCCINO.webp'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true), */
    ];
  } */




 static List<Food> generatePopulerFoods(){
    return [
       Food(
        'assets/images/icelatt.webp',
        '	Yumuşak içim, sütlü ve serin',
        'Iced Latte',
        '50 dk',
        4.8,
        '325 kcal',
        170,
        1,
        [
          {
            'Noodle' : 'assets/images/kahve.jpg'
          },
          {
            'Shrimp' : 'assets/images/kahve.jpg'
          },
          {
            'Egg' : 'assets/images/kahve.jpg'
          },
          {
            'Scallion' : 'assets/images/kahve.jpg'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),

      Food(
        'assets/images/coldbrew.png',
        'Hafif asidik, serinletici içim',
        'Cold Brew',
        '50 dk',
        4.8,
        '325 kcal',
        150,
        1,
        [
          {
            'Noodle' : 'assets/images/kahve.jpg'
          },
          {
            'Shrimp' : 'assets/images/kahve.jpg'
          },
          {
            'Egg' : 'assets/images/kahve.jpg'
          },
          {
            'Scallion' : 'assets/images/kahve.jpg'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),

        Food(
        'assets/images/frappe.webp',
        'Köpüklü yapı, tatlı içim',
        'Frappé',
        '50 dk',
        4.8,
        '325 kcal',
        210,
        1,
        [
          {
            'Noodle' : 'assets/images/kahve.jpg'
          },
          {
            'Shrimp' : 'assets/images/kahve.jpg'
          },
          {
            'Egg' : 'assets/images/kahve.jpg'
          },
          {
            'Scallion' : 'assets/images/kahve.jpg'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),

         Food(
        'assets/images/Affogato.png',
        'Yoğun espresso',
        'Affogato',
        '50 dk',
        4.8,
        '325 kcal',
        180,
        1,
        [
          {
            'Noodle' : 'assets/images/kahve.jpg'
          },
          {
            'Shrimp' : 'assets/images/kahve.jpg'
          },
          {
            'Egg' : 'assets/images/kahve.jpg'
          },
          {
            'Scallion' : 'assets/images/kahve.jpg'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),
    ];
  }




  


  static List<Food> generateMilkFoods(){
    return [
       Food(
        'assets/images/flat.png',
        'Yumuşak ama yoğun',
        'Flat White',
        '50 dk',
        4.8,
        '325 kcal',
        160,
        1,
        [
          {
            'Noodle' : 'assets/images/kahve.jpg'
          },
          {
            'Shrimp' : 'assets/images/kahve.jpg'
          },
          {
            'Egg' : 'assets/images/kahve.jpg'
          },
          {
            'Scallion' : 'assets/images/kahve.jpg'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),

      Food(
        'assets/images/cortado.webp',
        'Sert içim',
        'Cortado',
        '50 dk',
        4.8,
        '325 kcal',
        190,
        1,
        [
          {
            'Noodle' : 'assets/images/kahve.jpg'
          },
          {
            'Shrimp' : 'assets/images/kahve.jpg'
          },
          {
            'Egg' : 'assets/images/kahve.jpg'
          },
          {
            'Scallion' : 'assets/images/kahve.jpg'
          },
        ],
        'Simply put, ramen is a Japanese noodle soup, with ', 
        hightLight: true),
    ];
  } */