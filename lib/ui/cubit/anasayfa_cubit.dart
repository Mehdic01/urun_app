import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urunler_app/data/entity/urunler.dart';
import 'package:urunler_app/data/repo/urunlerdao_repository.dart';

class AnasayfaCubit extends Cubit<List<Urunler>> {
  AnasayfaCubit() : super([]);
  final UrunlerdaoRepository urepo = UrunlerdaoRepository();

  Future<void> tumUrunleriYukle() async {
    var liste = await urepo.urunleriYukle();
    emit(liste);
  }

  Future<void> urunleriAra(String query, String kategori) async {
    var liste = await urepo.urunleriYukle();
    var filteredList = liste.where((urun) {
      final matchesQuery = urun.ad.toLowerCase().contains(query.toLowerCase());
      final matchesCategory =
          kategori == "Tümü" || urun.kategori == kategori;
      return matchesQuery && matchesCategory;
    }).toList();
    emit(filteredList);
  }
}
