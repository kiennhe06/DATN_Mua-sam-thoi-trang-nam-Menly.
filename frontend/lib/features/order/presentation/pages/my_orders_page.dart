import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../models/order_model.dart';
import '../providers/order_provider.dart';
import 'order_detail_page.dart';
import 'vnpay_payment_page.dart';

/// Man hinh Don cua toi & Loc trang thai don (AP-DH2, TM07)
class MyOrdersPage extends StatelessWidget {
  const MyOrdersPage({super.key});

  final List<Map<String, String>> _statusTabs = const [
    {'key': 'all', 'label': 'Tất cả'},
    {'key': 'pending_payment', 'label': 'Chờ thanh toán'},
    {'key': 'processing', 'label': 'Đang xử lý'},
    {'key': 'shipping', 'label': 'Đang giao'},
    {'key': 'delivered', 'label': 'Đã giao'},
    {'key': 'canceled', 'label': 'Đã hủy'},
  ];

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
    final orders = orderProv.myFilteredOrders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // TM07: Thanh tab cuon ngang loc don hang theo trang thai
          Container(
            height: 48,
            color: Colors.white,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              itemCount: _statusTabs.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (ctx, i) {
                final tab = _statusTabs[i];
                final isSelected = orderProv.selectedStatusFilter == tab['key'];
                final count = orderProv.countByStatus(tab['key']!);

                return InkWell(
                  onTap: () => orderProv.setStatusFilter(tab['key']!),
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.black87 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          tab['label']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            fontSize: 13,
                          ),
                        ),
                        if (count > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white24 : Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$count',
                              style: TextStyle(
                                fontSize: 11,
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),

          // Danh sach don hang
          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long_outlined, size: 70, color: Colors.grey.shade400),
                        const SizedBox(height: 12),
                        const Text('Không có đơn hàng nào', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 6),
                        Text('Các đơn hàng phù hợp với bộ lọc sẽ xuất hiện ở đây',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
                      ],
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.all(12),
                    itemCount: orders.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (ctx, i) {
                      final order = orders[i];

                      return InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: order.id)),
                          );
                        },
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.all(14),
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
                              // Ma don hang va badge trang thai
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.shopping_bag_outlined, size: 18),
                                      const SizedBox(width: 6),
                                      Text(
                                        order.code,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(order.status).withValues(alpha: 0.12),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      order.status.label,
                                      style: TextStyle(
                                        color: _getStatusColor(order.status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(height: 18),

                              // Tom tat cac san pham
                              ...order.items.take(2).map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(6),
                                          child: Image.network(
                                            item.thumbnailUrl,
                                            width: 44,
                                            height: 44,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) => Container(
                                              width: 44,
                                              height: 44,
                                              color: Colors.grey.shade200,
                                              child: const Icon(Icons.checkroom, size: 20),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(item.productName,
                                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                                                  maxLines: 1,
                                                  overflow: TextOverflow.ellipsis),
                                              Text('Size ${item.size} • ${item.color} • SL: ${item.quantity}',
                                                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                                            ],
                                          ),
                                        ),
                                        Text('${item.unitPrice} đ',
                                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                      ],
                                    ),
                                  )),

                              if (order.items.length > 2)
                                Text(
                                  '+ ${order.items.length - 2} sản phẩm khác',
                                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontStyle: FontStyle.italic),
                                ),

                              const Divider(height: 16),

                              // Tong tien va nut hanh dong
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}',
                                        style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                                      ),
                                      Text(
                                        'Tổng: ${order.total} đ',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      if (order.paymentMethod == 'vnpay' && !order.isPaid && order.status != OrderStatus.canceled)
                                        Padding(
                                          padding: const EdgeInsets.only(right: 6),
                                          child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFF005BAA),
                                              foregroundColor: Colors.white,
                                              visualDensity: VisualDensity.compact,
                                              padding: const EdgeInsets.symmetric(horizontal: 10),
                                            ),
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(builder: (_) => VNPayPaymentPage(order: order)),
                                              );
                                            },
                                            child: const Text('Thanh toán', style: TextStyle(fontSize: 12)),
                                          ),
                                        ),
                                      OutlinedButton(
                                        style: OutlinedButton.styleFrom(
                                          visualDensity: VisualDensity.compact,
                                          side: const BorderSide(color: Colors.black87),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (_) => OrderDetailPage(orderId: order.id)),
                                          );
                                        },
                                        child: const Text('Xem chi tiết', style: TextStyle(fontSize: 12, color: Colors.black87)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
