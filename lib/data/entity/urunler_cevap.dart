import 'urunler.dart';

class UrunlerCevap {
  List<Urunler> urunler;
  int success;

  UrunlerCevap({
    required this.urunler,
    required this.success,
  });

  factory UrunlerCevap.fromJson(Map<String, dynamic> json) {
    var urunlerArray = json["urunler"] as List? ?? [];
    var urunler = urunlerArray
        .map((jsonUrunNesnesi) => Urunler.fromJson(jsonUrunNesnesi))
        .toList();

    int success = json["success"] as int;

    return UrunlerCevap(
      urunler: urunler,
      success: success,
    );
  }
}
