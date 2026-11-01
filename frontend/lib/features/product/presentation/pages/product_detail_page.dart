import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menly_app/models/product_model.dart';
import 'package:menly_app/features/cart/presentation/providers/cart_provider.dart';
import 'package:menly_app/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:menly_app/features/product/presentation/providers/product_provider.dart';

/// Trang Chi tiet san pham (TM02: Da xem gan day, AP-YT1: Yeu thich, AP-GH1: Them vao gio)
class ProductDetailPage extends StatefulWidget {
  final ProductModel product;

  const ProductDetailPage({super.key, required this.product});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  late ProductModel _product;
  String _selectedSize = 'M';
  String _selectedColor = 'Đen';
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    // TM02: Tu dong them san pham vao danh sach da xem gan day va goi API GET /api/v1/products/:id
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      context.read<ProductProvider>().addToRecentlyViewed(_product);
      final detail = await context.read<ProductProvider>().fetchProductDetail(_product.id);
      if (detail != null && mounted) {
        setState(() {
          _product = detail;
          if (_product.variants.isNotEmpty) {
            _selectedSize = _product.variants.first.size;
            _selectedColor = _product.variants.first.color;
          }
        });
      }
    });

    if (_product.variants.isNotEmpty) {
      _selectedSize = _product.variants.first.size;
      _selectedColor = _product.variants.first.color;
    }
  }

  @override
  Widget build(BuildContext context) {
    final p = _product;
    final wishlist = context.watch<WishlistProvider>();
    final cart = context.read<CartProvider>();
    final isFav = wishlist.isFavorite(p.id);

    final availableSizes = p.variants.map((v) => v.size).toSet().toList();
    final availableColors = p.variants.map((v) => v.color).toSet().toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(p.name),
        actions: [
          // AP-YT1: Nut trai tim yeu thich
          IconButton(
            icon: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: isFav ? Colors.red : Colors.black87,
            ),
            onPressed: () async {
              final added = await wishlist.toggleFavorite(p);
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(added
                      ? 'Đã thêm "${p.name}" vào danh sách yêu thích'
                      : 'Đã xóa khỏi danh sách yêu thích'),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Anh san pham
            Image.network(
              p.thumbnailUrl,
              width: double.infinity,
              height: 380,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: double.infinity,
                height: 380,
                color: Colors.grey.shade200,
                child: const Icon(Icons.checkroom, size: 80, color: Colors.grey),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Danh muc va danh gia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          p.categoryName,
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade700, fontWeight: FontWeight.w600),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text('${p.ratingAvg} (${p.ratingCount} đánh giá)',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  // Ten san pham
                  Text(
                    p.name,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Gia tien
                  Text(
                    '${p.price} đ',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  const Divider(height: 24),

                  // Chon Size
                  const Text('Chọn kích cỡ (Size):', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: (availableSizes.isEmpty ? ['M', 'L', 'XL'] : availableSizes).map((size) {
                      final isSelected = _selectedSize == size;
                      return ChoiceChip(
                        label: Text(size, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
                        selected: isSelected,
                        selectedColor: Colors.black87,
                        backgroundColor: Colors.grey.shade100,
                        onSelected: (_) => setState(() => _selectedSize = size),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Chon Mau
                  const Text('Chọn màu sắc:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: (availableColors.isEmpty ? ['Đen', 'Trắng'] : availableColors).map((color) {
                      final isSelected = _selectedColor == color;
                      return ChoiceChip(
                        label: Text(color, style: TextStyle(color: isSelected ? Colors.white : Colors.black87)),
                        selected: isSelected,
                        selectedColor: Colors.black87,
                        backgroundColor: Colors.grey.shade100,
                        onSelected: (_) => setState(() => _selectedColor = color),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),

                  // Chon so luong
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Số lượng:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove, size: 18),
                              onPressed: () {
                                if (_quantity > 1) setState(() => _quantity--);
                              },
                            ),
                            Text('$_quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            IconButton(
                              icon: const Icon(Icons.add, size: 18),
                              onPressed: () {
                                if (_quantity < 20) setState(() => _quantity++);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 28),

                  // Mo ta chi tiet
                  const Text('Mô tả sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Text(
                    p.description,
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade800, height: 1.5),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Row(
            children: [
              // Nut trai tim
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(isFav ? Icons.favorite : Icons.favorite_border,
                      color: isFav ? Colors.red : Colors.black87),
                  onPressed: () => wishlist.toggleFavorite(p),
                ),
              ),
              const SizedBox(width: 12),
              // Nut them vao gio hang (AP-GH1)
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.add_shopping_cart),
                  label: const Text('Thêm vào giỏ hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                  onPressed: () {
                    cart.addToCart(p, size: _selectedSize, color: _selectedColor, quantity: _quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Đã thêm $_quantity x "${p.name}" vào giỏ hàng'),
                        backgroundColor: Colors.black87,
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
