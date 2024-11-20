import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urunler_app/data/entity/urunler.dart';
import 'package:urunler_app/ui/cubit/detay_sayfa_cubit.dart';

class DetaySayfa extends StatefulWidget {
  final Urunler urun;
  DetaySayfa({super.key, required this.urun});

  @override
  State<DetaySayfa> createState() => _DetaySayfaState();
}

class _DetaySayfaState extends State<DetaySayfa> {
  int adet = 1; // Ürün miktarı
  final String kullaniciAdi = "mehdi_moh"; // Sabit kullanıcı adı

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Ürün Detayı",
          style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightGreenAccent.shade700,
        elevation: 2,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(16),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Ürün Resmi
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  "http://kasimadalan.pe.hu/urunler/resimler/${widget.urun.resim}",
                  height: 250,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(
                      Icons.broken_image,
                      size: 80,
                      color: Colors.grey,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Ürün Adı ve Fiyatı
            Text(
              widget.urun.ad,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 26,
                color: Colors.grey.shade800,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "${widget.urun.fiyat} ₺",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Colors.lightGreenAccent.shade700,
              ),
            ),
            const SizedBox(height: 16),
            // Ürün Açıklaması (Örnek)
            const Text(
              "Bu ürün en kaliteli malzemelerle üretilmiştir. Şimdi satın alarak harika bir deneyim yaşayabilirsiniz.",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            // Adet Seçimi
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      if (adet > 1) adet--;
                    });
                  },
                  icon: const Icon(Icons.remove_circle),
                  color: Colors.lightGreenAccent.shade700,
                  iconSize: 32,
                ),
                Container(
                  width: 60,
                  height: 40,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    adet.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      adet++;
                    });
                  },
                  icon: const Icon(Icons.add_circle),
                  color: Colors.lightGreenAccent.shade700,
                  iconSize: 32,
                ),
              ],
            ),
            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Toplam: ${(widget.urun.fiyat * adet)} ₺",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.grey.shade800,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Sepete Ekleme İşlemi
                      context.read<DetaySayfaCubit>().sepeteEkle(
                        widget.urun.ad,
                        widget.urun.resim,
                        widget.urun.kategori,
                        widget.urun.fiyat,
                        widget.urun.marka,
                        adet,
                        kullaniciAdi,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Ürün sepete eklendi."),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightGreenAccent.shade700,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Sepete Ekle",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
