import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/mock_data.dart';
import '../../../../models/product_model.dart';

/// Provider quan ly Danh sach yeu thich (Wishlist) & Nut trai tim
/// Phu trach boi: Thanh Toan (AP-YT1)
class WishlistProvider extends ChangeNotifier {
  final List<ProductModel> _favorites = [];

  WishlistProvider() {
    loadFavorites();
  }

  List<ProductModel> get favorites => _favorites;
  int get count => _favorites.length;

  /// Kiem tra xem 1 san pham co dang trong danh sach yeu thich khong
  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  /// Toggle trai tim yeu thich (Them hoac Xoa)
  Future<bool> toggleFavorite(ProductModel product) async {
    final exists = isFavorite(product.id);
    if (exists) {
      _favorites.removeWhere((p) => p.id == product.id);
    } else {
      _favorites.insert(0, product);
    }
    notifyListeners();
    await _saveToLocal();
    return !exists; // Tra ve trang thai moi (true la da thich, false la da bo thich)
  }

  /// Xoa khoi danh sach yeu thich
  Future<void> removeFavorite(String productId) async {
    _favorites.removeWhere((p) => p.id == productId);
    notifyListeners();
    await _saveToLocal();
  }

  /// Xoa toan bo
  Future<void> clearAll() async {
    _favorites.clear();
    notifyListeners();
    await _saveToLocal();
  }

  /// Load tu SharedPreferences
  Future<void> loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList('wishlist_ids') ?? [];
      if (ids.isNotEmpty) {
        _favorites.clear();
        for (var id in ids) {
          final found = MockData.products.cast<ProductModel?>().firstWhere(
                (p) => p?.id == id,
                orElse: () => null,
              );
          if (found != null && !_favorites.any((p) => p.id == id)) {
            _favorites.add(found);
          }
        }
      } else {
        // Mock default 2 san pham yeu thich ban dau de dep giao dien
        if (MockData.products.length >= 2) {
          _favorites.add(MockData.products[0]);
          _favorites.add(MockData.products[4]);
        }
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> _saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = _favorites.map((p) => p.id).toList();
      await prefs.setStringList('wishlist_ids', ids);
    } catch (_) {}
  }
}
