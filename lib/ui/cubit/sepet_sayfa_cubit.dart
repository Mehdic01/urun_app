import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/entity/sepet_urunleri.dart';
import '../../data/repo/urunlerdao_repository.dart';

class SepetSayfaCubit extends Cubit<List<SepetUrunleri>> {
  SepetSayfaCubit() : super([]);

  final UrunlerdaoRepository urepo = UrunlerdaoRepository();

  Future<void> sepettekiUrunleriYukle(String kullaniciAdi) async {
    try {
      var sepetUrunleri = await urepo.sepettekiUrunleriGetir(kullaniciAdi);
      print("Cubit'e Gelen Sepet Ürünleri: $sepetUrunleri");
      emit(sepetUrunleri);
    } catch (e) {
      print("Hata (sepettekiUrunleriYukle): $e");
      emit([]);
    }
  }

  Future<void> urunSil(String kullaniciAdi, int sepetId) async {
    try {
      await urepo.sepettenUrunSil(kullaniciAdi, sepetId);
      await sepettekiUrunleriYukle(kullaniciAdi); // Listeyi güncelle
    } catch (e) {
      print("Hata (urunSil): $e");
    }
  }
}
