import 'package:flutter/foundation.dart';
import '../../../../core/mock_data.dart';
import '../../../../models/voucher_model.dart';

/// Provider quan ly Khuyen mai & Gom ma giam gia
/// Phu trach boi: Thanh Toan (TM10)
class VoucherProvider extends ChangeNotifier {
  List<VoucherModel> _vouchers = [];
  final Set<String> _collectedVoucherIds = {};

  VoucherProvider() {
    _vouchers = List.from(MockData.vouchers);
  }

  List<VoucherModel> get vouchers => _vouchers;

  /// Kiem tra da luu voucher chua
  bool isCollected(String voucherId) => _collectedVoucherIds.contains(voucherId);

  /// Thu thap / Luu voucher (TM10)
  void collectVoucher(String voucherId) {
    _collectedVoucherIds.add(voucherId);
    notifyListeners();
  }
}

