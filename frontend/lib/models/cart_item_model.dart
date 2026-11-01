import 'product_model.dart';

/// Item trong gio hang (AP-GH1)
class CartItemModel {
  final String id;
  final ProductModel product;
  final String variantId;
  final String size;
  final String color;
  int quantity;
  bool isSelected;

  CartItemModel({
    required this.id,
    required this.product,
    required this.variantId,
    required this.size,
    required this.color,
    this.quantity = 1,
    this.isSelected = true,
  });

  int get totalPrice => product.price * quantity;

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id']?.toString() ?? '',
      product: ProductModel.fromJson(Map<String, dynamic>.from(json['product'] ?? {})),
      variantId: json['variant_id']?.toString() ?? '',
      size: json['size']?.toString() ?? 'M',
      color: json['color']?.toString() ?? 'Đen',
      quantity: (json['quantity'] is num) ? (json['quantity'] as num).toInt() : 1,
      isSelected: json['is_selected'] ?? true,
    );
  }

  /// Parse du lieu tu backend API: GET /api/v1/cart
  factory CartItemModel.fromBackendJson(Map<String, dynamic> json) {
    final variant = json['product_variants'] as Map<String, dynamic>?;
    final productJson = variant?['products'] as Map<String, dynamic>?;

    return CartItemModel(
      id: 'cart-${json['variant_id']}',
      product: productJson != null
          ? ProductModel.fromJson(Map<String, dynamic>.from(productJson))
          : const ProductModel(
              id: '',
              name: 'Sản phẩm',
              slug: 'sp',
              price: 0,
              thumbnailUrl: '',
            ),
      variantId: json['variant_id']?.toString() ?? '',
      size: variant?['size']?.toString() ?? 'M',
      color: variant?['color']?.toString() ?? 'Đen',
      quantity: (json['quantity'] is num) ? (json['quantity'] as num).toInt() : 1,
      isSelected: true,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'product': product.toJson(),
    'variant_id': variantId,
    'size': size,
    'color': color,
    'quantity': quantity,
    'is_selected': isSelected,
  };
}

