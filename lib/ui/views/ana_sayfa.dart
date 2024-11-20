import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urunler_app/data/entity/urunler.dart';
import 'package:urunler_app/ui/views/detay_sayfa.dart';
import 'package:urunler_app/ui/views/sepet_sayfa.dart';
import 'package:urunler_app/ui/views/favori_sayfa.dart';
import '../cubit/anasayfa_cubit.dart';

class Anasayfa extends StatefulWidget {
  final List<Urunler> favoriteItems;
  final Function(Urunler) onToggleFavorite;

  const Anasayfa({
    Key? key,
    required this.favoriteItems,
    required this.onToggleFavorite,
  }) : super(key: key);

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  List<Urunler> favoriteItems = []; // Favori ürünlerin listesi

  void toggleFavorite(Urunler urun) {
    setState(() {
      if (favoriteItems.contains(urun)) {
        favoriteItems.remove(urun);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${urun.ad} favorilerden çıkarıldı."),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        favoriteItems.add(urun);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("${urun.ad} favorilere eklendi!"),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();
    context.read<AnasayfaCubit>().tumUrunleriYukle();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightGreenAccent.shade700,
        elevation: 5,
        title: Row(
          children: [
            const Text(
              "Ürünler",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                color: Colors.white,
              ),
            ),
            const Spacer(),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SepetSayfa(kullaniciAdi: "mehdi_moh"),
                  ),
                );
              },
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FavoriSayfa(favoriteItems: favoriteItems),
                  ),
                );
              },
              icon: const Icon(Icons.favorite, color: Colors.white),
            ),
          ],
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(20),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: BlocBuilder<AnasayfaCubit, List<Urunler>>(
              builder: (context, urunlerListesi) {
                if (urunlerListesi.isNotEmpty) {
                  return GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.55,
                      crossAxisSpacing: 2,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: urunlerListesi.length,
                    itemBuilder: (context, indeks) {
                      var urun = urunlerListesi[indeks];
                      return Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetaySayfa(urun: urun),
                                ),
                              ).then((value) {
                                context.read<AnasayfaCubit>().tumUrunleriYukle();
                              });
                            },
                            child: Card(
                              color: Colors.white,
                              shape: const RoundedRectangleBorder(
                                side: BorderSide(color: Colors.black, width: 0.1),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                      child: Image.network(
                                        "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                            color: Colors.grey,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          urun.ad,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          urun.marka,
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 14),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          '${urun.fiyat} ₺',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              icon: Icon(
                                favoriteItems.contains(urun)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: favoriteItems.contains(urun)
                                    ? Colors.red
                                    : Colors.grey,
                              ),
                              onPressed: () => toggleFavorite(urun),
                            ),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  return const Center(
                    child: Text(
                      "Ürün bulunamadı",
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
