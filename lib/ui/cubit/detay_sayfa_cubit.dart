import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urunler_app/data/repo/urunlerdao_repository.dart';

class DetaySayfaCubit extends Cubit<void> {
  DetaySayfaCubit() : super(0);

  final UrunlerdaoRepository urepo = UrunlerdaoRepository();

  Future<void> sepeteEkle(
      String ad,
      String resim,
      String kategori,
      int fiyat,
      String marka,
      int siparisAdeti,
      String kullaniciAdi) async {
    await urepo.sepeteEkle(
      ad,
      resim,
      kategori,
      fiyat,
      marka,
      siparisAdeti,
      kullaniciAdi,
    );
  }
}
