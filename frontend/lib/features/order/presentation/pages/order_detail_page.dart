import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/order_model.dart';
import '../providers/order_provider.dart';
import 'vnpay_payment_page.dart';

/// Man hinh Chi tiet don hang & Huy don (AP-DH2)
class OrderDetailPage extends StatelessWidget {
  final String orderId;

  const OrderDetailPage({super.key, required this.orderId});

  void _showCancelOrderDialog(BuildContext context, OrderProvider provider, OrderModel order) {
    String selectedReason = 'Tôi muốn đổi sản phẩm khác';
    final customReasonCtrl = TextEditingController();

    final reasons = [
      'Tôi muốn đổi sản phẩm khác',
      'Tôi muốn đổi kích cỡ / màu sắc',
      'Tìm thấy giá tốt hơn ở nơi khác',
      'Không còn nhu cầu mua nữa',
      'Thời gian giao hàng quá lâu',
      'Lý do khác',
    ];

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setState) {
          return AlertDialog(
            title: const Text('Hủy đơn hàng'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Bạn có chắc muốn hủy đơn hàng ${order.code}?'),
                  const SizedBox(height: 12),
                  const Text('Vui lòng chọn lý do hủy:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  const SizedBox(height: 6),
                  ...reasons.map((r) => InkWell(
                        onTap: () => setState(() => selectedReason = r),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              Icon(
                                selectedReason == r ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                                size: 20,
                                color: selectedReason == r ? Colors.black87 : Colors.grey,
                              ),
                              const SizedBox(width: 8),
                              Expanded(child: Text(r, style: const TextStyle(fontSize: 13))),
                            ],
                          ),
                        ),
                      )),
                  if (selectedReason == 'Lý do khác')
                    TextField(
                      controller: customReasonCtrl,
                      decoration: const InputDecoration(
                        hintText: 'Nhập lý do cụ thể...',
                        border: OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Đóng', style: TextStyle(color: Colors.grey)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
                onPressed: () {
                  final reason = selectedReason == 'Lý do khác'
                      ? customReasonCtrl.text.trim().isNotEmpty
                          ? customReasonCtrl.text.trim()
                          : 'Lý do khác'
                      : selectedReason;

                  final success = provider.cancelOrder(order.id, reason: reason);
                  Navigator.pop(ctx);
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đã hủy đơn hàng thành công!'), backgroundColor: Colors.green),
                    );
                  }
                },
                child: const Text('Xác nhận hủy'),
              ),
            ],
          );
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pendingPayment:
        return Colors.orange;
      case OrderStatus.processing:
        return Colors.blue;
      case OrderStatus.shipping:
        return Colors.purple;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.canceled:
      case OrderStatus.returned:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final orderProv = context.watch<OrderProvider>();
    final order = orderProv.getOrderById(orderId);

    if (order == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
        body: const Center(child: Text('Không tìm thấy thông tin đơn hàng')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết: ${order.code}'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header trang thai
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _getStatusColor(order.status).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: _getStatusColor(order.status).withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: _getStatusColor(order.status)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Trạng thái: ${order.status.label}',
                          style: TextStyle(
                            color: _getStatusColor(order.status),
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                        if (order.status == OrderStatus.canceled && order.cancelReason != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              'Lý do hủy: ${order.cancelReason}',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Thong tin nguoi nhan
            const Text('Địa chỉ nhận hàng', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 20, color: Colors.redAccent),
                      const SizedBox(width: 8),
                      Text(order.shipName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                      const SizedBox(width: 8),
                      Text('(${order.shipPhone})', style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.only(left: 28),
                    child: Text(order.shipAddress, style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Danh sach san pham
            const Text('Sản phẩm đã mua', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: order.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final item = order.items[i];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          item.thumbnailUrl,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            width: 60,
                            height: 60,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.checkroom),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.productName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text('Phân loại: ${item.size} / ${item.color}',
                                style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${item.unitPrice} đ',
                                    style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                                Text('x${item.quantity}',
                                    style: TextStyle(color: Colors.grey.shade700, fontSize: 13)),
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
            const SizedBox(height: 16),

            // Chi tiet thanh toan
            const Text('Chi tiết thanh toán', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phương thức:', style: TextStyle(color: Colors.grey.shade600)),
                      Text(
                        order.paymentMethod == 'vnpay' ? 'Thanh toán online VNPay' : 'Thanh toán khi nhận hàng (COD)',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Trạng thái thanh toán:', style: TextStyle(color: Colors.grey.shade600)),
                      Text(
                        order.isPaid ? 'Đã thanh toán' : 'Chưa thanh toán',
                        style: TextStyle(
                          color: order.isPaid ? Colors.green : Colors.orange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tạm tính:', style: TextStyle(color: Colors.grey.shade600)),
                      Text('${order.subtotal} đ'),
                    ],
                  ),
                  if (order.discountAmount > 0) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Giảm giá voucher:', style: TextStyle(color: Colors.deepOrange.shade600)),
                        Text('-${order.discountAmount} đ', style: TextStyle(color: Colors.deepOrange.shade600)),
                      ],
                    ),
                  ],
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Phí vận chuyển:', style: TextStyle(color: Colors.grey.shade600)),
                      Text('${order.shippingFee} đ'),
                    ],
                  ),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tổng số tiền:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                      Text(
                        '${order.total} đ',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Cac nut hanh dong
            if (order.paymentMethod == 'vnpay' && !order.isPaid && order.status != OrderStatus.canceled) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF005BAA),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.payment),
                  label: const Text('Thanh toán VNPay ngay', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => VNPayPaymentPage(order: order)),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
            ],

            // Nut huy don (AP-DH2)
            if (order.canCancel)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red,
                    side: const BorderSide(color: Colors.red),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: const Icon(Icons.cancel_outlined),
                  label: const Text('Hủy đơn hàng này', style: TextStyle(fontWeight: FontWeight.bold)),
                  onPressed: () => _showCancelOrderDialog(context, orderProv, order),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
