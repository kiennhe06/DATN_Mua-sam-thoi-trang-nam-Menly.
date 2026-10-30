import 'package:flutter/material.dart';
import '../../../../core/network/api_client.dart';

/// Danh sách sản phẩm
class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final _api = ApiClient();
  bool _loading = true;
  String? _error;
  List _products = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final res = await _api.dio.get('/products', queryParameters: {'limit': 30});
      setState(() {
        _products = (res.data['data'] as List?) ?? [];
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Menly - Sản phẩm')),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text('Lỗi tải dữ liệu:\n$_error', textAlign: TextAlign.center),
                ))
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.separated(
                    itemCount: _products.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (_, i) {
                      final p = _products[i] as Map;
                      final url = p['thumbnail_url'] as String?;
                      return ListTile(
                        leading: SizedBox(
                          width: 54,
                          height: 54,
                          child: (url != null && url.isNotEmpty)
                              ? Image.network(url, fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => const Icon(Icons.checkroom))
                              : const Icon(Icons.checkroom),
                        ),
                        title: Text(p['name']?.toString() ?? ''),
                        subtitle: Text('${p['price']} đ'),
                      );
                    },
                  ),
                ),
    );
  }
}
