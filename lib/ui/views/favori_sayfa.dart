import 'package:flutter/material.dart';
import 'package:urunler_app/data/entity/urunler.dart';

class FavoriSayfa extends StatelessWidget {
  final List<Urunler> favoriteItems;

  const FavoriSayfa({Key? key, required this.favoriteItems}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Favorilerim",
          style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 25,
          color: Colors.white,
        ),),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent.shade700,
      ),
      body: favoriteItems.isEmpty
          ? const Center(
        child: Text(
          "Favori ürün bulunmamaktadır.",
          style: TextStyle(fontSize: 18, color: Colors.grey),
        ),
      )
          : ListView.builder(
        itemCount: favoriteItems.length,
        itemBuilder: (context, index) {
          var urun = favoriteItems[index];
          return ListTile(
            leading: Image.network(
              "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
              width: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.broken_image, color: Colors.grey);
              },
            ),
            title: Text(
              urun.ad,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text("${urun.fiyat} ₺"),
          );
        },
      ),
    );
  }
}
