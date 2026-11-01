import 'package:flutter/foundation.dart';
import '../../../../core/mock_data.dart';
import '../../../../models/cart_item_model.dart';
import '../../../../models/product_model.dart';
import '../../../../models/voucher_model.dart';

/// Provider quan ly Gio hang va Ap dung ma giam gia
/// Phu trach boi: Thanh Toan (AP-GH1, AP-VC1)
class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  VoucherModel? _appliedVoucher;
  final int _baseShippingFee = 25000;

  CartProvider() {
    // Khoi tao mot so san pham mau trong gio hang de trai nghiem ngay
    _initSampleCart();
  }

  void _initSampleCart() {
    if (MockData.products.length >= 2) {
      _items.add(CartItemModel(
        id: 'cart-1',
        product: MockData.products[0], // Áo sơ mi trắng
        variantId: 'v-01-m',
        size: 'M',
        color: 'Trắng',
        quantity: 1,
        isSelected: true,
      ));
      _items.add(CartItemModel(
        id: 'cart-2',
        product: MockData.products[3], // Áo polo
        variantId: 'v-04-l',
        size: 'L',
        color: 'Xanh Rêu',
        quantity: 2,
        isSelected: true,
      ));
    }
  }

  List<CartItemModel> get items => _items;
  VoucherModel? get appliedVoucher => _appliedVoucher;

  /// Tong so san pham trong gio
  int get totalItemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity);

  /// Cac san pham dang duoc tick chon
  List<CartItemModel> get selectedItems =>
      _items.where((i) => i.isSelected).toList();

  /// Co dang chon tat ca khong?
  bool get isAllSelected =>
      _items.isNotEmpty && _items.every((i) => i.isSelected);

  /// Tam tinh cua cac mon duoc chon
  int get selectedSubtotal =>
      selectedItems.fold(0, (sum, item) => sum + item.totalPrice);

  /// So tien giam gia tu voucher da ap dung (AP-VC1)
  int get discountAmount {
    if (_appliedVoucher == null) return 0;
    return _appliedVoucher!.calculateDiscount(selectedSubtotal);
  }

  /// Phi van chuyen
  int get shippingFee {
    if (selectedItems.isEmpty) return 0;
    // Neu co voucher FREESHIP va du dieu kien
    if (_appliedVoucher?.code == 'FREESHIP' && selectedSubtotal >= 300000) {
      return 0;
    }
    return _baseShippingFee;
  }

  /// Tong tien can thanh toan cuoi cung
  int get finalTotal {
    if (selectedItems.isEmpty) return 0;
    final total = selectedSubtotal - discountAmount + shippingFee;
    return total > 0 ? total : 0;
  }

  // =================== AP-GH1: THAO TÁC GIỎ HÀNG ===================

  /// Them san pham vao gio
  void addToCart(ProductModel product, {String size = 'M', String color = 'Đen', int quantity = 1}) {
    final existingIndex = _items.indexWhere(
      (item) => item.product.id == product.id && item.size == size && item.color == color,
    );

    if (existingIndex >= 0) {
      _items[existingIndex].quantity += quantity;
      if (_items[existingIndex].quantity > 20) {
        _items[existingIndex].quantity = 20;
      }
    } else {
      _items.insert(0, CartItemModel(
        id: 'cart-${DateTime.now().millisecondsSinceEpoch}',
        product: product,
        variantId: '${product.id}-$size-$color',
        size: size,
        color: color,
        quantity: quantity,
        isSelected: true,
      ));
    }
    notifyListeners();
  }

  /// Tang so luong (+1)
  void incrementQuantity(String cartItemId) {
    final index = _items.indexWhere((i) => i.id == cartItemId);
    if (index >= 0 && _items[index].quantity < 20) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  /// Giam so luong (-1)
  void decrementQuantity(String cartItemId) {
    final index = _items.indexWhere((i) => i.id == cartItemId);
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
        notifyListeners();
      } else {
        // Neu giam xuong 0 thi xoa mon
        removeItem(cartItemId);
      }
    }
  }

  /// Xoa mot mon khoi gio
  void removeItem(String cartItemId) {
    _items.removeWhere((i) => i.id == cartItemId);
    _checkVoucherEligibility();
    notifyListeners();
  }

  /// Chon / Bo chon 1 mon
  void toggleItemSelected(String cartItemId) {
    final index = _items.indexWhere((i) => i.id == cartItemId);
    if (index >= 0) {
      _items[index].isSelected = !_items[index].isSelected;
      _checkVoucherEligibility();
      notifyListeners();
    }
  }

  /// Chon tat ca / Bo chon tat ca
  void toggleSelectAll() {
    final targetState = !isAllSelected;
    for (var item in _items) {
      item.isSelected = targetState;
    }
    _checkVoucherEligibility();
    notifyListeners();
  }

  /// Xoa cac mon da duoc tick chon sau khi dat hang thanh cong
  void clearSelectedItems() {
    _items.removeWhere((i) => i.isSelected);
    _appliedVoucher = null;
    notifyListeners();
  }

  // =================== AP-VC1: ÁP DỤNG MÃ GIẢM GIÁ ===================

  /// Ap dung ma giam gia
  String? applyVoucher(VoucherModel voucher) {
    if (selectedSubtotal < voucher.minOrderValue) {
      return 'Đơn hàng tối thiểu phải từ ${voucher.minOrderValue} đ để áp dụng mã này';
    }
    _appliedVoucher = voucher;
    notifyListeners();
    return null; // Thanh cong
  }

  /// Nhap ma code truc tiep
  String? applyVoucherCode(String code) {
    final cleanCode = code.trim().toUpperCase();
    final voucher = MockData.vouchers.cast<VoucherModel?>().firstWhere(
      (v) => v?.code.toUpperCase() == cleanCode,
      orElse: () => null,
    );

    if (voucher == null) {
      return 'Mã giảm giá không tồn tại hoặc đã hết hạn';
    }
    return applyVoucher(voucher);
  }

  /// Huy ap dung ma giam gia
  void removeVoucher() {
    _appliedVoucher = null;
    notifyListeners();
  }

  void _checkVoucherEligibility() {
    if (_appliedVoucher != null && selectedSubtotal < _appliedVoucher!.minOrderValue) {
      _appliedVoucher = null;
    }
  }
}
