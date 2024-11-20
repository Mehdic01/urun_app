import 'sepet_urunleri.dart';

class SepetCevap {
  List<SepetUrunleri> sepetUrunleri;
  int success;

  SepetCevap({
    required this.sepetUrunleri,
    required this.success,
  });

  factory SepetCevap.fromJson(Map<String, dynamic> json) {
    print("SepetCevap.fromJson JSON Verisi: $json");

    var sepetArray = json["urunler_sepeti"] as List? ?? [];
    print("Sepet Array Türü: ${sepetArray.runtimeType}");
    print("Sepet Array İçeriği: $sepetArray");

    var sepetUrunleri = sepetArray
        .map((jsonSepetNesnesi) => SepetUrunleri.fromJson(jsonSepetNesnesi))
        .toList();

    print("SepetUrunleri Nesneleri: $sepetUrunleri");

    return SepetCevap(
      sepetUrunleri: sepetUrunleri,
      success: int.tryParse(json["success"].toString()) ?? 0,
    );
  }
}
