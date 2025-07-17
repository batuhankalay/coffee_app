import 'package:coffe_app/models/food.dart';

class Restaurant {
  String name;
  String waitTime;
  String distance;
  String label;
  String logoUrl;
  String desc;
  num score;
  Map<String, List<Food>> menu;
  Restaurant(
    this.name,
    this.waitTime,
    this.distance,
    this.label,
    this.logoUrl,
    this.desc,
    this.score,
    this.menu,
  );

  static Restaurant generateRestaurant() {
    return Restaurant(
      'Bi Kahve',
      '20-30 dk',
      '2.4 km',
      'Restoran',
      'assets/images/logokahve.png',
      'Küçük bir yudum, büyük bir an.',
      4.7,
      {
        'Espresso Bazlı Kahveler': [],
        'Soğuk Kahveler': [],
        'Sütlü Kahveler': [],
        //'Dünya Kahveleri': [],
      },
    );
  }
}