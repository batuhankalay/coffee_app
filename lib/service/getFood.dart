
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_app/models/food.dart';
import 'package:flutter/material.dart';

const String demoUserId = "demo_user_123";

Future<List<Food>> fetchFoods() async {
  try {
    CollectionReference foodCollection = FirebaseFirestore.instance.collection('foodList');
    QuerySnapshot snapshot = await foodCollection.get();

    // Firestore'dan dönen dokümanları Food nesnesine dönüştür
    List<Food> foods = snapshot.docs.map((doc) {
      return Food.fromDocument(doc);
    }).toList();

    return foods;
  } catch (error) {
    print("Failed to fetch food: $error");
    return []; // Hata durumunda boş liste döndür
  }
}


Future<void> postFood(Food food) {
  CollectionReference foodCollection = FirebaseFirestore.instance.collection('foodList');

  return foodCollection.add(food.toJson())
    .then((DocumentReference docRef) {
      print('Document added with ID: ${docRef.id}');
    })
    .catchError((error) => print("Failed to add food: $error"));
}



Future<void> addToCart(BuildContext context, String name, String id, String imageUrl, num totalPrice, num quantity) async {
  try {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(demoUserId)
        .collection('card');

    await cartRef.add({
      'foodId': id,
      'name': name,
      'price': totalPrice,
      'quantity': quantity,
      'imageUrl': imageUrl,
      'createdAt': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Ürün sepete eklendi")),
    );
  } catch (e) {
    print("Sepete ekleme hatası: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Sepete eklenemedi")),
    );
  }
}

// Favori durumunu kontrol etme işlevi
Future<bool> isFavorite(String foodId) async {
  try {
    final favoriteDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(demoUserId)
        .collection('favorites')
        .doc(foodId)
        .get();

    return favoriteDoc.exists;
  } catch (e) {
    print("Favori kontrolü hatası: $e");
    return false;
  }
}

// Favorilere ekleme/çıkarma işlevi
Future<bool> toggleFavorite(BuildContext context, Food food) async {
  try {
    final favoriteRef = FirebaseFirestore.instance
        .collection('users')
        .doc(demoUserId)
        .collection('favorites')
        .doc(food.id);

    final docSnapshot = await favoriteRef.get();
    
    if (docSnapshot.exists) {
      // Favorilerden kaldır
      await favoriteRef.delete();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${food.name} favorilerden çıkarıldı")),
      );
      return false;
    } else {
      // Favorilere ekle
      await favoriteRef.set({
        'foodId': food.id,
        'name': food.name,
        'price': food.price,
        'imgUrl': food.imgUrl,
        'addedAt': FieldValue.serverTimestamp(),
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("${food.name} favorilere eklendi")),
      );
      return true;
    }
  } catch (e) {
    print("Favori ekleme/çıkarma hatası: $e");
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("İşlem gerçekleştirilemedi")),
    );
    return false;
  }
}

Future<void> completeOrder(BuildContext context, String userId, List<Map<String, dynamic>> cartItems, double totalPrice) async {
  try {
    // Sipariş dokümanı oluştur
    final orderRef = FirebaseFirestore.instance.collection('orders').doc();
    
    // Sipariş bilgilerini kaydet
    await orderRef.set({
      'userId': userId,
      'totalAmount': totalPrice,
      'status': 'yeni',
      'items': cartItems.map((item) => {
        'foodId': item['foodId'],
        'name': item['name'],
        'price': item['price'],
        'quantity': item['quantity'],
        'imageUrl': item['imageUrl'],
      }).toList(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    
    // Sepeti temizle - tüm ürünleri sil
    final batch = FirebaseFirestore.instance.batch();
    final cartSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('card')
        .get();
    
    for (var doc in cartSnapshot.docs) {
      batch.delete(doc.reference);
    }
    
    // Batch işlemini uygula
    await batch.commit();
    
    print("Sipariş başarıyla tamamlandı: ${orderRef.id}");
    
  } catch (e) {
    print("Sipariş tamamlama hatası: $e");
    throw e; // Hatayı yukarıya ilet
  }
}

