import 'package:flutter/material.dart';
import 'package:urunler_app/data/entity/urunler.dart';
import 'package:urunler_app/ui/views/ana_sayfa.dart';
import 'package:urunler_app/ui/views/favori_sayfa.dart';
import 'package:urunler_app/ui/views/search_sayfa.dart';
import 'package:urunler_app/ui/views/sepet_sayfa.dart';

class CustomBottomNavBar extends StatefulWidget {
  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  int _currentIndex = 0;

  // Favori Ürünlerin Listesi
  List<Urunler> favoriteItems = [];

  // Ekranlar
  late List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Ekranlar burada tanımlanır ve favori listesi parametre olarak geçilir
    _screens = [
      Anasayfa(
        onToggleFavorite: (urun) => toggleFavorite(urun),
        favoriteItems: favoriteItems,
      ),
      const SearchPage(),
      const SepetSayfa(kullaniciAdi: "mehdi_moh"),
      FavoriSayfa(favoriteItems: favoriteItems),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  // Favori ürün ekleme/çıkarma işlemi
  void toggleFavorite(Urunler urun) {
    setState(() {
      if (favoriteItems.contains(urun)) {
        favoriteItems.remove(urun);
      } else {
        favoriteItems.add(urun);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(0),
            topRight: Radius.circular(0),
          ),
        ),
        padding: const EdgeInsets.only(top: 5, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, "Anasayfa", 0),
            _buildNavItem(Icons.search, "Arama", 1),
            _buildNavItem(Icons.shopping_bag_outlined, "Sepetim", 2),
            _buildNavItem(Icons.favorite_outline, "Favoriler", 3),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index,
      {bool hasDot = false}) {
    bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () => _onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                icon,
                size: isSelected ? 30 : 16,
                color: isSelected ? Colors.white : Colors.grey,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.grey,
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
