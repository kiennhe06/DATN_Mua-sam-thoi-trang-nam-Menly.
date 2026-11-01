import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:menly_app/core/mock_data.dart';
import 'package:menly_app/features/cart/presentation/providers/cart_provider.dart';

/// Bottom Sheet chon hoac nhap ma giam gia khi dat hang (AP-VC1)
class VoucherSelectSheet extends StatefulWidget {
  const VoucherSelectSheet({super.key});

  @override
  State<VoucherSelectSheet> createState() => _VoucherSelectSheetState();
}

class _VoucherSelectSheetState extends State<VoucherSelectSheet> {
  final _codeController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  void _applyInputCode(CartProvider cart) {
    setState(() => _errorMessage = null);
    final error = cart.applyVoucherCode(_codeController.text);
    if (error != null) {
      setState(() => _errorMessage = error);
    } else {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã áp dụng mã giảm giá thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final vouchers = MockData.vouchers;

    return Container(
      padding: EdgeInsets.only(
        top: 20,
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mã giảm giá Menly',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // O nhap ma truc tiep
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _codeController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Nhập mã voucher (VD: WELCOME10)',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    isDense: true,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
                onPressed: () => _applyInputCode(cart),
                child: const Text('Áp dụng'),
              ),
            ],
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 13),
              ),
            ),
          const SizedBox(height: 16),
          const Text(
            'Mã giảm giá có sẵn cho bạn:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(height: 8),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: vouchers.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (ctx, i) {
                final v = vouchers[i];
                final isSelected = cart.appliedVoucher?.id == v.id;
                final isEligible = cart.selectedSubtotal >= v.minOrderValue;

                return InkWell(
                  onTap: () {
                    final err = cart.applyVoucher(v);
                    if (err != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(err), backgroundColor: Colors.orange),
                      );
                    } else {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Đã chọn voucher: ${v.code}'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    }
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Colors.black
                            : isEligible
                                ? Colors.grey.shade300
                                : Colors.grey.shade200,
                        width: isSelected ? 2 : 1,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected
                          ? Colors.amber.shade50
                          : isEligible
                              ? Colors.white
                              : Colors.grey.shade50,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: isEligible ? Colors.orange.shade100 : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.confirmation_num_outlined,
                            color: isEligible ? Colors.deepOrange : Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    v.code,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                  ),
                                  if (isSelected)
                                    Container(
                                      margin: const EdgeInsets.only(left: 8),
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.green,
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: const Text('Đang dùng',
                                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Text(v.title, style: TextStyle(fontSize: 13, color: Colors.grey.shade800)),
                              const SizedBox(height: 4),
                              Text(
                                'Đơn tối thiểu ${v.minOrderValue} đ • HSD: ${v.endDate.day}/${v.endDate.month}/${v.endDate.year}',
                                style: TextStyle(fontSize: 11, color: isEligible ? Colors.grey.shade600 : Colors.red),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                          color: isSelected ? Colors.deepOrange : Colors.grey,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (cart.appliedVoucher != null) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  cart.removeVoucher();
                  Navigator.pop(context);
                },
                child: const Text('Bỏ chọn mã giảm giá'),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
