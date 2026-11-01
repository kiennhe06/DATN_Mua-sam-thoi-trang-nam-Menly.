import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menly_app/models/cart_item_model.dart';
import 'package:menly_app/features/voucher/presentation/widgets/voucher_select_sheet.dart';
import 'package:menly_app/features/cart/presentation/providers/cart_provider.dart';

/// Man hinh Gio hang (AP-GH1, AP-VC1)
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  void _showDeleteConfirmDialog(BuildContext context, CartProvider cart, CartItemModel item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xóa sản phẩm'),
        content: Text('Bạn có chắc muốn xóa "${item.product.name}" khỏi giỏ hàng?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            onPressed: () {
              cart.removeItem(item.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa sản phẩm khỏi giỏ hàng')),
              );
            },
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }

  void _openVoucherSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const VoucherSelectSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Giỏ hàng (${cart.totalItemCount})'),
        centerTitle: true,
      ),
      body: cart.items.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_bag_outlined, size: 84, color: Colors.grey.shade400),
                  const SizedBox(height: 16),
                  const Text(
                    'Giỏ hàng của bạn đang trống',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Hãy khám phá và chọn cho mình những món đồ ưng ý nhé!',
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                // Thanh chon tat ca
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  color: Colors.grey.shade100,
                  child: Row(
                    children: [
                      Checkbox(
                        value: cart.isAllSelected,
                        activeColor: Colors.black87,
                        onChanged: (_) => cart.toggleSelectAll(),
                      ),
                      const Text(
                        'Chọn tất cả',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                      ),
                      const Spacer(),
                      Text(
                        'Đã chọn: ${cart.selectedItems.length}',
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
                      ),
                    ],
                  ),
                ),

                // Danh sach san pham trong gio
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: cart.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final item = cart.items[i];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Checkbox tung mon
                            Checkbox(
                              value: item.isSelected,
                              activeColor: Colors.black87,
                              onChanged: (_) => cart.toggleItemSelected(item.id),
                            ),
                            // Anh san pham
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                item.product.thumbnailUrl,
                                width: 72,
                                height: 80,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 72,
                                  height: 80,
                                  color: Colors.grey.shade200,
                                  child: const Icon(Icons.checkroom),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Thong tin san pham
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          item.product.name,
                                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        icon: const Icon(Icons.delete_outline, size: 20, color: Colors.grey),
                                        onPressed: () => _showDeleteConfirmDialog(context, cart, item),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      'Phân loại: ${item.size} / ${item.color}',
                                      style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        '${item.product.price} đ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.redAccent,
                                          fontSize: 15,
                                        ),
                                      ),
                                      // Stepper tang giam so luong
                                      Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(color: Colors.grey.shade300),
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                              onTap: () => cart.decrementQuantity(item.id),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: Icon(Icons.remove, size: 16),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(horizontal: 8),
                                              child: Text(
                                                '${item.quantity}',
                                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () => cart.incrementQuantity(item.id),
                                              child: const Padding(
                                                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                child: Icon(Icons.add, size: 16),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Muc chon / xem ma giam gia (AP-VC1)
                InkWell(
                  onTap: () => _openVoucherSheet(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      border: Border(top: BorderSide(color: Colors.amber.shade200)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.confirmation_num_outlined, color: Colors.deepOrange, size: 22),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            cart.appliedVoucher != null
                                ? 'Mã đang dùng: ${cart.appliedVoucher!.code} (-${cart.discountAmount} đ)'
                                : 'Chọn hoặc nhập mã giảm giá Menly',
                            style: TextStyle(
                              color: cart.appliedVoucher != null ? Colors.deepOrange.shade900 : Colors.black87,
                              fontWeight: cart.appliedVoucher != null ? FontWeight.bold : FontWeight.normal,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: Colors.grey),
                      ],
                    ),
                  ),
                ),

                // Thanh tong tien & Dat hang co dinh duoi man hinh
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, -4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Tạm tính:', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                            Text('${cart.selectedSubtotal} đ', style: const TextStyle(fontWeight: FontWeight.w600)),
                          ],
                        ),
                        if (cart.discountAmount > 0) ...[
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Giảm giá voucher:', style: TextStyle(color: Colors.deepOrange.shade600, fontSize: 13)),
                              Text('-${cart.discountAmount} đ',
                                  style: TextStyle(color: Colors.deepOrange.shade600, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Phí vận chuyển:', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                            Text(
                              cart.shippingFee == 0 ? 'Miễn phí' : '${cart.shippingFee} đ',
                              style: TextStyle(
                                color: cart.shippingFee == 0 ? Colors.green : Colors.black87,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const Divider(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Tổng thanh toán:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                                Text(
                                  '${cart.finalTotal} đ',
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.black,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                              onPressed: cart.selectedItems.isEmpty
                                  ? null
                                  : () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Đang xử lý ${cart.selectedItems.length} món vào đơn hàng...'),
                                          backgroundColor: Colors.black87,
                                        ),
                                      );
                                    },
                              child: Text(
                                'Mua hàng (${cart.selectedItems.length})',
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
