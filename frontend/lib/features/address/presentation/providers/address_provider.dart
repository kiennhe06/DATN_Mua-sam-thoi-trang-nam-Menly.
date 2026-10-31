import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/mock_data.dart';
import '../../../../models/address_model.dart';

/// Provider quan ly So dia chi giao hang
/// Phu trach boi: Thanh Toan (AP-DC1)
class AddressProvider extends ChangeNotifier {
  List<AddressModel> _addresses = [];
  AddressModel? _selectedAddress;

  AddressProvider() {
    loadAddresses();
  }

  List<AddressModel> get addresses => _addresses;
  AddressModel? get selectedAddress => _selectedAddress ?? defaultAddress;

  /// Lay dia chi mac dinh
  AddressModel? get defaultAddress {
    try {
      return _addresses.firstWhere((a) => a.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  /// Chon dia chi de dat hang (AP-DC1)
  void selectAddress(AddressModel address) {
    _selectedAddress = address;
    notifyListeners();
  }

  /// Them dia chi moi
  Future<void> addAddress(AddressModel newAddr) async {
    if (newAddr.isDefault || _addresses.isEmpty) {
      _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
    }
    _addresses.insert(0, newAddr);
    notifyListeners();
    await _saveToLocal();
  }

  /// Cap nhat dia chi
  Future<void> updateAddress(AddressModel updated) async {
    final index = _addresses.indexWhere((a) => a.id == updated.id);
    if (index >= 0) {
      if (updated.isDefault) {
        _addresses = _addresses.map((a) => a.copyWith(isDefault: false)).toList();
      }
      _addresses[index] = updated;
      if (_selectedAddress?.id == updated.id) {
        _selectedAddress = updated;
      }
      notifyListeners();
      await _saveToLocal();
    }
  }

  /// Dat lam dia chi mac dinh
  Future<void> setDefaultAddress(String addressId) async {
    _addresses = _addresses.map((a) {
      return a.copyWith(isDefault: a.id == addressId);
    }).toList();
    notifyListeners();
    await _saveToLocal();
  }

  /// Xoa dia chi
  Future<void> deleteAddress(String addressId) async {
    _addresses.removeWhere((a) => a.id == addressId);
    if (_selectedAddress?.id == addressId) {
      _selectedAddress = defaultAddress;
    }
    // Neu xoa mat dia chi mac dinh thi lay thang dau tien lam mac dinh
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      _addresses[0] = _addresses[0].copyWith(isDefault: true);
    }
    notifyListeners();
    await _saveToLocal();
  }

  /// Load tu SharedPreferences
  Future<void> loadAddresses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString('saved_addresses');
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final List list = jsonDecode(jsonStr);
        _addresses = list.map((item) => AddressModel.fromJson(item)).toList();
      } else {
        _addresses = List.from(MockData.addresses);
      }
    } catch (_) {
      _addresses = List.from(MockData.addresses);
    }
    notifyListeners();
  }

  Future<void> _saveToLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _addresses.map((a) => a.toJson()).toList();
      await prefs.setString('saved_addresses', jsonEncode(list));
    } catch (_) {}
  }
}
