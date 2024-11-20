class SepetUrunleri {
  final int sepetId;
  final String ad;
  final String resim;
  final String kategori;
  final int fiyat;
  final String marka;
  final int siparisAdeti;
  final String kullaniciAdi;

  SepetUrunleri({
    required this.sepetId,
    required this.ad,
    required this.resim,
    required this.kategori,
    required this.fiyat,
    required this.marka,
    required this.siparisAdeti,
    required this.kullaniciAdi,
  });

  factory SepetUrunleri.fromJson(Map<String, dynamic> json) {
    print("SepetUrunleri.fromJson JSON Verisi: $json");
    return SepetUrunleri(
      sepetId: int.tryParse(json["sepetId"].toString()) ?? 0,
      ad: json["ad"]?.toString() ?? "",
      resim: json["resim"]?.toString() ?? "",
      kategori: json["kategori"]?.toString() ?? "",
      fiyat: int.tryParse(json["fiyat"].toString()) ?? 0,
      marka: json["marka"]?.toString() ?? "",
      siparisAdeti: int.tryParse(json["siparisAdeti"].toString()) ?? 0,
      kullaniciAdi: json["kullaniciAdi"]?.toString() ?? "",
    );
  }

}
