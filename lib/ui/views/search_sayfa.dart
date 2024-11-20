import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:urunler_app/data/entity/urunler.dart';
import 'package:urunler_app/ui/views/detay_sayfa.dart';
import 'package:urunler_app/ui/cubit/anasayfa_cubit.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;
  String selectedCategory = "Tümü";
  List<String> categories = ["Tümü", "Teknoloji", "Aksesuar", "Kozmetik"];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<AnasayfaCubit>().tumUrunleriYukle();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Ürün Arama",
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
      body: Column(
        children: [
          // Arama Alanı ve Kategori Seçimi
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (query) {
                      context
                          .read<AnasayfaCubit>()
                          .urunleriAra(query, selectedCategory);
                    },
                    decoration: InputDecoration(
                      hintText: "Ürün ara...",
                      hintStyle: TextStyle(color: Colors.grey.shade400),
                      prefixIcon: Icon(Icons.search, color: Colors.grey.shade500),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8.0),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: DropdownButton<String>(
                    value: selectedCategory,
                    underline: const SizedBox(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCategory = value;
                          context.read<AnasayfaCubit>().urunleriAra(
                              _searchController.text, selectedCategory);
                        });
                      }
                    },
                    items: categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(
                          category,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade800,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          // Ürün Listesi
          Expanded(
            child: BlocBuilder<AnasayfaCubit, List<Urunler>>(
              builder: (context, urunler) {
                if (urunler.isEmpty) {
                  return const Center(
                    child: Text(
                      "Hiçbir ürün bulunamadı.",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  );
                }
                return ListView.builder(
                  itemCount: urunler.length,
                  itemBuilder: (context, index) {
                    var urun = urunler[index];
                    return GestureDetector(
                      onTap: () {
                        // Ürün detay sayfasına yönlendir
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetaySayfa(urun: urun),
                          ),
                        );
                      },
                      child: Card(
                        color: Colors.white,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        elevation: 1,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              "http://kasimadalan.pe.hu/urunler/resimler/${urun.resim}",
                              width: 50,
                              height: 50,
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
                          subtitle: Text(
                            "Kategori: ${urun.kategori}",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                          trailing: Text(
                            "${urun.fiyat} ₺",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.lightGreenAccent.shade700,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
