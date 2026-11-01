import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menly_app/features/wishlist/presentation/providers/wishlist_provider.dart';
import 'package:menly_app/features/product/presentation/providers/product_provider.dart';
import 'product_detail_page.dart';
import 'search_page.dart';

/// Man hinh danh sach san pham (AP-SP1: Loc, Tim kiem, Sap xep; AP-YT1: Nut trai tim)
class ProductListPage extends StatelessWidget {
  const ProductListPage({super.key});

  void _showFilterModal(BuildContext context, ProductProvider prov) {
    String currentSort = prov.sortBy;
    RangeValues currentRange = RangeValues(prov.minPrice, prov.maxPrice);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
            return Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Bộ lọc & Sắp xếp', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      TextButton(
                        onPressed: () {
                          prov.resetFilters();
                          Navigator.pop(ctx);
                        },
                        child: const Text('Thiết lập lại', style: TextStyle(color: Colors.redAccent)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Sap xep theo
                  const Text('Sắp xếp theo:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: [
                      {'key': 'newest', 'label': 'Mới nhất'},
                      {'key': 'best_seller', 'label': 'Bán chạy nhất'},
                      {'key': 'price_asc', 'label': 'Giá tăng dần'},
                      {'key': 'price_desc', 'label': 'Giá giảm dần'},
                    ].map((item) {
                      final isSelected = currentSort == item['key'];
                      return ChoiceChip(
                        label: Text(item['label']!,
                            style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontSize: 12)),
                        selected: isSelected,
                        selectedColor: Colors.black87,
                        backgroundColor: Colors.grey.shade100,
                        onSelected: (_) => setState(() => currentSort = item['key']!),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),

                  // Khoang gia
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Khoảng giá:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      Text(
                        '${currentRange.start.toInt()} đ - ${currentRange.end.toInt()} đ',
                        style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ],
                  ),
                  RangeSlider(
                    values: currentRange,
                    min: 0,
                    max: 1000000,
                    divisions: 20,
                    activeColor: Colors.black87,
                    inactiveColor: Colors.grey.shade300,
                    labels: RangeLabels('${currentRange.start.toInt()}', '${currentRange.end.toInt()}'),
                    onChanged: (values) => setState(() => currentRange = values),
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black87,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        prov.setSortBy(currentSort);
                        prov.setPriceRange(currentRange.start, currentRange.end);
                        Navigator.pop(ctx);
                      },
                      child: const Text('Áp dụng bộ lọc', style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final productProv = context.watch<ProductProvider>();
    final wishlistProv = context.watch<WishlistProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sản phẩm Menly'),
        centerTitle: true,
        actions: [
          // Nut tim kiem (TM03)
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
            },
          ),
          // Nut bo loc & sap xep
          IconButton(
            icon: const Icon(Icons.tune),
            onPressed: () => _showFilterModal(context, productProv),
          ),
        ],
      ),
      body: Column(
        children: [
          // Thanh danh muc chips cuon ngang (AP-SP1)
          Container(
            height: 48,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: productProv.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final cat = productProv.categories[i];
                final isSelected = productProv.selectedCategory == cat;
                return ChoiceChip(
                  label: Text(
                    cat,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontSize: 13,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  selected: isSelected,
                  selectedColor: Colors.black87,
                  backgroundColor: Colors.grey.shade100,
                  onSelected: (_) => productProv.setCategory(cat),
                );
              },
            ),
          ),

          // Neu dang loc theo tu khoa hoac gia, hien thi thanh thong bao
          if (productProv.searchQuery.isNotEmpty || productProv.minPrice > 0 || productProv.maxPrice < 1000000)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              color: Colors.amber.shade50,
              child: Row(
                children: [
                  const Icon(Icons.filter_list, size: 16, color: Colors.orange),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'Đang lọc: ${productProv.searchQuery.isNotEmpty ? '"${productProv.searchQuery}" • ' : ''}${productProv.products.length} kết quả',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                  TextButton(
                    onPressed: () => productProv.resetFilters(),
                    style: TextButton.styleFrom(visualDensity: VisualDensity.compact, padding: EdgeInsets.zero),
                    child: const Text('Bỏ lọc', style: TextStyle(fontSize: 12, color: Colors.red)),
                  ),
                ],
              ),
            ),
          const Divider(height: 1),

          // Luoi san pham (AP-SP1)
          Expanded(
            child: productProv.isLoading
                ? const Center(child: CircularProgressIndicator())
                : productProv.products.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 70, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text('Không tìm thấy sản phẩm phù hợp',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black87,
                                foregroundColor: Colors.white,
                              ),
                              onPressed: () => productProv.resetFilters(),
                              child: const Text('Xem tất cả sản phẩm'),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => productProv.loadProducts(),
                        child: GridView.builder(
                          padding: const EdgeInsets.all(12),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.65,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          itemCount: productProv.products.length,
                          itemBuilder: (ctx, i) {
                            final p = productProv.products[i];
                            final isFav = wishlistProv.isFavorite(p.id);

                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => ProductDetailPage(product: p)),
                                );
                              },
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.grey.shade200),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.04),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Anh san pham + Heart Icon (AP-YT1)
                                    Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                          child: Image.network(
                                            p.thumbnailUrl,
                                            height: 160,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              height: 160,
                                              color: Colors.grey.shade200,
                                              child: const Icon(Icons.checkroom, size: 40),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 8,
                                          right: 8,
                                          child: CircleAvatar(
                                            radius: 16,
                                            backgroundColor: Colors.white.withValues(alpha: 0.9),
                                            child: IconButton(
                                              padding: EdgeInsets.zero,
                                              icon: Icon(
                                                isFav ? Icons.favorite : Icons.favorite_border,
                                                color: isFav ? Colors.red : Colors.black87,
                                                size: 18,
                                              ),
                                              onPressed: () => wishlistProv.toggleFavorite(p),
                                            ),
                                          ),
                                        ),
                                        if (p.isNew)
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: Colors.blue.shade700,
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: const Text('MỚI',
                                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                            ),
                                          ),
                                      ],
                                    ),

                                    // Thong tin
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            p.categoryName,
                                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            p.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${p.price} đ',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.redAccent,
                                              fontSize: 15,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              const Icon(Icons.star, color: Colors.amber, size: 14),
                                              const SizedBox(width: 2),
                                              Text(
                                                '${p.ratingAvg}',
                                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                '(${p.ratingCount})',
                                                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
