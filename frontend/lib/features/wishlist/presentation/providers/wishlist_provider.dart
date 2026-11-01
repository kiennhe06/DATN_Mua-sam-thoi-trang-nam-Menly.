import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:menly_app/core/mock_data.dart';
import 'package:menly_app/core/network/api_client.dart';
import 'package:menly_app/models/product_model.dart';

/// Provider quan ly Danh sach yeu thich (Wishlist) & Nut trai tim
/// Ket noi truc tiep cac API backend da hoan thien (AP-YT1):
/// - GET /api/v1/wishlist (Lay danh sach yeu thich cua toi)
/// - POST /api/v1/wishlist/:productId (Them vao yeu thich)
/// - DELETE /api/v1/wishlist/:productId (Bo yeu thich)
/// - GET /api/v1/wishlist/check/:productId (Kiem tra da yeu thich chua)
class WishlistProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();
  final List<ProductModel> _favorites = [];
  bool _isLoading = false;

  WishlistProvider() {
    loadFavorites();
  }

  List<ProductModel> get favorites => _favorites;
  int get count => _favorites.length;
  bool get isLoading => _isLoading;

  /// Kiem tra xem 1 san pham co dang trong danh sach yeu thich khong
  bool isFavorite(String productId) {
    return _favorites.any((p) => p.id == productId);
  }

  /// Toggle trai tim yeu thich (Them hoac Xoa) - Dong bo voi Backend
  Future<bool> toggleFavorite(ProductModel product) async {
    final exists = isFavorite(product.id);

    if (exists) {
      _favorites.removeWhere((p) => p.id == product.id);
      notifyListeners();
      await _saveToLocal();

      // Goi API backend DELETE /api/v1/wishlist/:productId
      try {
        await _api.dio.delete('/wishlist/${product.id}');
      } catch (_) {}
      return false;
    } else {
      _favorites.insert(0, product);
      notifyListeners();
      await _saveToLocal();

      // Goi API backend POST /api/v1/wishlist/:productId
      try {
        await _api.dio.post('/wishlist/${product.id}');
      } catch (_) {}
      return true;
    }
  }

  /// Xoa khoi danh sach yeu thich
  Future<void> removeFavorite(String productId) async {
    _favorites.removeWhere((p) => p.id == productId);
    notifyListeners();
    await _saveToLocal();

    try {
      await _api.dio.delete('/wishlist/$productId');
    } catch (_) {}
  }

  /// Xoa toan bo
  Future<void> clearAll() async {
    final ids = _favorites.map((p) => p.id).toList();
    _favorites.clear();
    notifyListeners();
    await _saveToLocal();

    for (var id in ids) {
      try {
        await _api.dio.delete('/wishlist/$id');
      } catch (_) {}
    }
  }

  /// Load tu Backend API GET /api/v1/wishlist (kem fallback SharedPreferences)
  Future<void> loadFavorites() async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await _api.dio.get('/wishlist');
      if (res.statusCode == 200 && res.data['data'] != null) {
        final list = res.data['data'] as List;
        final List<ProductModel> loaded = [];

        for (var item in list) {
          if (item['products'] != null) {
            loaded.add(ProductModel.fromJson(Map<String, dynamic>.from(item['products'])));
          }
        }

        if (loaded.isNotEmpty) {
          _favorites.clear();
          _favorites.addAll(loaded);
          await _saveToLocal();
          _isLoading = false;
          notifyListeners();
          return;
        }
      }
    } catch (_) {
      // Backend offline hoac chua dang nhap -> Dung local cache
    }

    // Fallback load tu SharedPreferences
    await _loadFromLocal();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> _loadFromLocal() async {
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
        if (MockData.products.length >= 2) {
          _favorites.add(MockData.products[0]);
          _favorites.add(MockData.products[4]);
        }
      }
    } catch (_) {}
  }

  Future<void> _saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = _favorites.map((p) => p.id).toList();
      await prefs.setStringList('wishlist_ids', ids);
    } catch (_) {}
  }
}
