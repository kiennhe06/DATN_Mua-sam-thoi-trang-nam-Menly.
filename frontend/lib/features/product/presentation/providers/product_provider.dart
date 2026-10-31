import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/mock_data.dart';
import '../../../../core/network/api_client.dart';
import '../../../../models/banner_model.dart';
import '../../../../models/product_model.dart';

/// Provider quan ly San pham, Banner, Da xem gan day, Lich su tim kiem
/// Phu trach boi: Thanh Toan (AP-SP1, AP-BN1, TM11, TM02, TM03)
class ProductProvider extends ChangeNotifier {
  final ApiClient _api = ApiClient();

  List<ProductModel> _allProducts = [];
  List<ProductModel> _filteredProducts = [];
  List<BannerModel> _banners = [];
  List<ProductModel> _recentlyViewed = [];
  List<String> _searchHistory = [];

  bool _loading = false;
  String? _error;

  // Filter state
  String _selectedCategory = 'Tất cả';
  String _searchQuery = '';
  String _sortBy = 'newest'; // 'newest', 'price_asc', 'price_desc', 'best_seller'
  double _minPrice = 0;
  double _maxPrice = 1000000;

  ProductProvider() {
    init();
  }

  bool get isLoading => _loading;
  String? get error => _error;
  List<ProductModel> get products => _filteredProducts;
  List<BannerModel> get banners => _banners;
  List<ProductModel> get recentlyViewed => _recentlyViewed;
  List<String> get searchHistory => _searchHistory;

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;
  String get sortBy => _sortBy;
  double get minPrice => _minPrice;
  double get maxPrice => _maxPrice;

  /// Lay danh sach san pham moi nhat (TM11)
  List<ProductModel> get newProducts =>
      _allProducts.where((p) => p.isNew).toList();

  /// Lay danh sach san pham ban chay (TM11)
  List<ProductModel> get bestSellers =>
      _allProducts.where((p) => p.isBestSeller).toList();

  /// Danh muc san pham
  List<String> get categories => [
    'Tất cả',
    'Áo sơ mi',
    'Áo thun',
    'Quần jeans',
    'Quần tây',
    'Áo khoác',
  ];

  Future<void> init() async {
    await Future.wait([
      loadBanners(),
      loadProducts(),
      loadRecentlyViewed(),
      loadSearchHistory(),
    ]);
  }

  /// AP-BN1: Load banner quang cao trang chu
  Future<void> loadBanners() async {
    try {
      final res = await _api.dio.get('/banners');
      if (res.statusCode == 200 && res.data['data'] != null) {
        _banners = (res.data['data'] as List)
            .map((b) => BannerModel.fromJson(b))
            .toList();
      } else {
        _banners = MockData.banners;
      }
    } catch (_) {
      // Fallback mockup banners cho AP-BN1
      _banners = MockData.banners;
    }
    notifyListeners();
  }

  /// AP-SP1: Load san pham voi bo loc & tim kiem
  Future<void> loadProducts() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final res = await _api.dio.get('/products', queryParameters: {'limit': 50});
      if (res.statusCode == 200 && res.data['data'] != null) {
        _allProducts = (res.data['data'] as List)
            .map((p) => ProductModel.fromJson(p))
            .toList();
      } else {
        _allProducts = List.from(MockData.products);
      }
    } catch (_) {
      // Fallback mockup products
      _allProducts = List.from(MockData.products);
    }

    _applyFilters();
    _loading = false;
    notifyListeners();
  }

  /// AP-SP1: Bo loc theo danh muc
  void setCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  /// AP-SP1 & TM03: Tim kiem theo tu khoa
  void setSearchQuery(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  /// AP-SP1: Sap xep
  void setSortBy(String sort) {
    _sortBy = sort;
    _applyFilters();
    notifyListeners();
  }

  /// AP-SP1: Khoang gia
  void setPriceRange(double min, double max) {
    _minPrice = min;
    _maxPrice = max;
    _applyFilters();
    notifyListeners();
  }

  /// Reset bo loc
  void resetFilters() {
    _selectedCategory = 'Tất cả';
    _searchQuery = '';
    _sortBy = 'newest';
    _minPrice = 0;
    _maxPrice = 1000000;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    List<ProductModel> result = List.from(_allProducts);

    // Filter theo category
    if (_selectedCategory != 'Tất cả') {
      result = result.where((p) => p.categoryName.toLowerCase().contains(_selectedCategory.toLowerCase())).toList();
    }

    // Filter theo search query
    if (_searchQuery.trim().isNotEmpty) {
      final q = _searchQuery.toLowerCase().trim();
      result = result.where((p) {
        return p.name.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.categoryName.toLowerCase().contains(q);
      }).toList();
    }

    // Filter theo khoang gia
    result = result.where((p) => p.price >= _minPrice && p.price <= _maxPrice).toList();

    // Sap xep
    switch (_sortBy) {
      case 'price_asc':
        result.sort((a, b) => a.price.compareTo(b.price));
        break;
      case 'price_desc':
        result.sort((a, b) => b.price.compareTo(a.price));
        break;
      case 'best_seller':
        result.sort((a, b) => (b.isBestSeller ? 1 : 0).compareTo(a.isBestSeller ? 1 : 0));
        break;
      case 'newest':
      default:
        result.sort((a, b) => (b.isNew ? 1 : 0).compareTo(a.isNew ? 1 : 0));
        break;
    }

    _filteredProducts = result;
  }

  // =================== TM02: ĐÃ XEM GẦN ĐÂY ===================

  /// TM02: Them san pham vao danh sach da xem gan day
  Future<void> addToRecentlyViewed(ProductModel product) async {
    _recentlyViewed.removeWhere((p) => p.id == product.id);
    _recentlyViewed.insert(0, product);
    if (_recentlyViewed.length > 10) {
      _recentlyViewed = _recentlyViewed.sublist(0, 10);
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = _recentlyViewed.map((p) => p.id).toList();
      await prefs.setStringList('recently_viewed_ids', ids);
    } catch (_) {}
  }

  /// TM02: Doc lich su da xem tu local
  Future<void> loadRecentlyViewed() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final ids = prefs.getStringList('recently_viewed_ids') ?? [];
      if (ids.isNotEmpty) {
        _recentlyViewed = ids
            .map((id) => _allProducts.cast<ProductModel?>().firstWhere(
                  (p) => p?.id == id,
                  orElse: () => MockData.products.cast<ProductModel?>().firstWhere(
                    (p) => p?.id == id,
                    orElse: () => null,
                  ),
                ))
            .whereType<ProductModel>()
            .toList();
      }
    } catch (_) {}
    notifyListeners();
  }

  /// TM02: Xoa lich su da xem
  Future<void> clearRecentlyViewed() async {
    _recentlyViewed.clear();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('recently_viewed_ids');
    } catch (_) {}
  }

  // =================== TM03: GỢI Ý & LỊCH SỬ TÌM KIẾM ===================

  /// TM03: Load lich su tim kiem tu local
  Future<void> loadSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _searchHistory = prefs.getStringList('search_history') ?? [
        'Áo sơ mi trắng',
        'Quần jeans slimfit',
        'Áo khoác bomber',
        'Áo polo nam',
      ];
    } catch (_) {
      _searchHistory = ['Áo sơ mi', 'Áo thun', 'Quần jeans'];
    }
    notifyListeners();
  }

  /// TM03: Luu tu khoa vao lich su tim kiem
  Future<void> addSearchKeyword(String keyword) async {
    final term = keyword.trim();
    if (term.isEmpty) return;

    _searchHistory.remove(term);
    _searchHistory.insert(0, term);
    if (_searchHistory.length > 8) {
      _searchHistory = _searchHistory.sublist(0, 8);
    }
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', _searchHistory);
    } catch (_) {}
  }

  /// TM03: Xoa 1 tu khoa trong lich su
  Future<void> removeSearchKeyword(String keyword) async {
    _searchHistory.remove(keyword);
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('search_history', _searchHistory);
    } catch (_) {}
  }

  /// TM03: Xoa toan bo lich su tim kiem
  Future<void> clearSearchHistory() async {
    _searchHistory.clear();
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('search_history');
    } catch (_) {}
  }

  /// TM03: Lay danh sach goi y tu dong khi dang go
  List<String> getSuggestions(String query) {
    if (query.trim().isEmpty) return [];
    final q = query.toLowerCase().trim();
    final suggestions = <String>{};

    for (var p in _allProducts) {
      if (p.name.toLowerCase().contains(q)) {
        suggestions.add(p.name);
      }
      if (p.categoryName.toLowerCase().contains(q)) {
        suggestions.add(p.categoryName);
      }
    }
    return suggestions.take(5).toList();
  }
}
