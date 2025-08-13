# coffe_app

Coffee App, Flutter ile geliştirilen, kahve ürünlerini listeleme, arama ve detaylarını görüntüleme özelliklerine sahip bir mobil uygulamadır. Modern bir arayüz, ürün detay sayfaları ve esnek arama deneyimi sunar.

## Özellikler
- Ürün listesi: Kategori ve ürün kartları ile akıcı bir liste deneyimi
- Ürün detay: Boy, fiyat, miktar, şeker seviyesi seçenekleri ve ürün hakkında bilgiler
- Arama: Ürün adı, açıklama ve hakkında alanlarında arama; Türkçe karakter desteği için iyileştirmeye uygun
- Durum yönetimi: Basit ve anlaşılır state yapısı
- Firebase entegrasyonu: flutterfire ile oluşturulan `firebase_options.dart` kullanımı (repo dışı takip edilir)
- Varlıklar: `assets/images/` klasörü repoda takip dışıdır. Görseller lokalinizde tutulur.

## Proje Yapısı (özet)
- `lib/screens/home/` Ana sayfa, arama ve ürün listesi
- `lib/screens/detail/` Ürün detay sayfası
- `lib/firebase_options.dart` Firebase yapılandırması (git ile izlenmez)
- `assets/images/` Görseller (git ile izlenmez)

## Gereksinimler
- Flutter 3.x+
- Dart 3.x+
- (Opsiyonel) Firebase projesi ve FlutterFire CLI

## Kurulum
1) Bağımlılıkları indir
   - `flutter pub get`
2) Firebase (varsa) yapılandır
   - `dart pub global activate flutterfire_cli`
   - `flutterfire configure`
   - Bu işlem `lib/firebase_options.dart` dosyasını üretir. `.gitignore` nedeniyle repoya dahil edilmez.
3) Asset’leri hazırlayın
   - `assets/images/` klasörüne kendi görsellerinizi ekleyin.
   - `pubspec.yaml` içindeki assets bölümünde `assets/images/` tanımlı olmalıdır.
4) Çalıştırın
   - `flutter run`

## Notlar ve Bilinen İyileştirmeler
- Arama kutusu: Kutudan başka yere tıklanınca otomatik kapanma ve focus kaybı eklenecek.
- Arama state’i: Detay sayfasından geri dönüldüğünde arama durumu temizlenecek.
- Arama kapsamı: `name`, `about` yanında `desc` alanı da aranacak ve Türkçe karakter uyumluluğu artırılacak.
- Ürün kartları: Kaydırmada kutu görünümü belirginleşmesin diye gölge/elevation iyileştirilecek.
- Detay sayfası: “Şeker Miktarı” ve “Hakkında” bölümleri fiyat/miktar seçiminden hemen sonra gösterilecek.
- Şeker miktarı seçenekleri: Yatay kaydırma yerine ekrana göre grid düzeni kullanılacak.

## Katkı
PR’ler memnuniyetle karşılanır. Geliştirme öncesi kısa bir açıklama içeren issue açmanız tercih edilir.

## Lisans
Bu proje kişisel öğrenme ve demo amaçlıdır. Gerekirse lisanslandırma bilgisi eklenecektir.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
