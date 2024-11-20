import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:urunler_app/data/entity/sepet_cevap.dart';
import 'package:urunler_app/data/entity/sepet_urunleri.dart';
import 'package:urunler_app/data/entity/urunler.dart';
import 'package:urunler_app/data/entity/urunler_cevap.dart';

class UrunlerdaoRepository {

  List<Urunler> parseUrunlerCevap(String cevap){
    return UrunlerCevap.fromJson(json.decode(cevap)).urunler;
  }

  Future<List<Urunler>> urunleriYukle() async {
    var url = "http://kasimadalan.pe.hu/urunler/tumUrunleriGetir.php";
    var cevap = await Dio().get(url);
    return parseUrunlerCevap(cevap.data.toString());
  }

  Future<void> sepeteEkle(
      String ad,
      String resim,
      String kategori,
      int fiyat,
      String marka,
      int siparisAdeti,
      String kullaniciAdi) async {

    var url = "http://kasimadalan.pe.hu/urunler/sepeteUrunEkle.php";


    var veri = {
      "ad": ad,
      "resim": resim,
      "kategori": kategori,
      "fiyat": fiyat,
      "marka": marka,
      "siparisAdeti": siparisAdeti,
      "kullaniciAdi": kullaniciAdi,
    };

    try {
      // Dio kütüphanesi ile POST isteği
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));

      // Web servis cevabı
      print("Cevap: ${cevap.data.toString()}");
    } catch (e) {
      // Hata durumunda hata mesajını yazdır
      print("Hata: $e");
    }
  }

  Future<List<SepetUrunleri>> sepettekiUrunleriGetir(String kullaniciAdi) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepettekiUrunleriGetir.php";
    var veri = {"kullaniciAdi": kullaniciAdi};

    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));
      var jsonCevap = jsonDecode(utf8.decode(cevap.data.toString().codeUnits));
      print("UTF-8 Decode Edilmiş JSON Cevabı: $jsonCevap");

      if (jsonCevap["success"] == 1) {
        return SepetCevap.fromJson(jsonCevap).sepetUrunleri;
      } else {
        print("Sepet boş veya bir hata oluştu.");
        return [];
      }
    } catch (e) {
      print("Hata (sepettekiUrunleriGetir): $e");
      return [];
    }
  }

  Future<void> sepettenUrunSil(String kullaniciAdi, int sepetId) async {
    var url = "http://kasimadalan.pe.hu/urunler/sepettenUrunSil.php";


    var veri = {
      "kullaniciAdi": kullaniciAdi,
      "sepetId": sepetId,
    };

    try {
      var cevap = await Dio().post(url, data: FormData.fromMap(veri));


      print("Silme Cevabı: ${cevap.data}");

      if (cevap.data["success"] == 1) {
        print("Ürün başarıyla silindi.");
      } else {
        print("Ürün silme başarısız: ${cevap.data["message"]}");
      }
    } catch (e) {
      print("Hata (sepettenUrunSil): $e");
    }
  }
}