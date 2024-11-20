import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urunler_app/data/entity/sepet_urunleri.dart';
import 'package:urunler_app/ui/cubit/sepet_sayfa_cubit.dart';

class SepetSayfa extends StatefulWidget {
  final String kullaniciAdi;

  const SepetSayfa({Key? key, required this.kullaniciAdi}) : super(key: key);

  @override
  _SepetSayfaState createState() => _SepetSayfaState();
}

class _SepetSayfaState extends State<SepetSayfa> {
  @override
  void initState() {
    super.initState();
    context.read<SepetSayfaCubit>().sepettekiUrunleriYukle(widget.kullaniciAdi);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Sepetim",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            color: Colors.white
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent.shade700,
        elevation: 4,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: BlocBuilder<SepetSayfaCubit, List<SepetUrunleri>>(
        builder: (context, sepetUrunleri) {
          if (sepetUrunleri.isNotEmpty) {
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: sepetUrunleri.length,
                    itemBuilder: (context, index) {
                      var urun = sepetUrunleri[index];
                      return Card(
                        color: Colors.white,
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                              width: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.broken_image,
                                    color: Colors.grey);
                              },
                            ),
                          ),
                          title: Text(
                            urun.ad,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Kategori: ${urun.kategori}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Text(
                                "Marka: ${urun.marka}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Text(
                                "Adet: ${urun.siparisAdeti}",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              Text(
                                "Fiyat: ${urun.fiyat} ₺",
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                            ],
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red, size: 30),
                            onPressed: () {
                              mesajGoster(context, urun.sepetId);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, -3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Toplam Tutar:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        "${sepetUrunleri.fold(0, (toplam, urun) => toplam + (urun.fiyat * urun.siparisAdeti))} ₺",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.lightGreenAccent.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return const Center(
              child: Text(
                "Sepetiniz boş.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }
        },
      ),
    );
  }

  void mesajGoster(BuildContext context, int sepetId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Ürünü Sil"),
          content: const Text("Bu ürünü sepetinizden silmek istediğinize emin misiniz?"),
          actions: [
            TextButton(
              child: const Text("Hayır"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text("Evet"),
              onPressed: () {
                Navigator.of(context).pop();
                context
                    .read<SepetSayfaCubit>()
                    .urunSil(widget.kullaniciAdi, sepetId)
                    .then((_) {
                  context
                      .read<SepetSayfaCubit>()
                      .sepettekiUrunleriYukle(widget.kullaniciAdi);
                });
              },
            ),
          ],
        );
      },
    );
  }
}
