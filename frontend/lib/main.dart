import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/address/presentation/providers/address_provider.dart';
import 'features/cart/presentation/pages/cart_page.dart';
import 'features/cart/presentation/providers/cart_provider.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/order/presentation/pages/my_orders_page.dart';
import 'features/order/presentation/providers/order_provider.dart';
import 'features/product/presentation/pages/product_list_page.dart';
import 'features/product/presentation/providers/product_provider.dart';
import 'features/voucher/presentation/providers/voucher_provider.dart';
import 'features/wishlist/presentation/pages/wishlist_page.dart';
import 'features/wishlist/presentation/providers/wishlist_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MenlyApp());
}

class MenlyApp extends StatelessWidget {
  const MenlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => WishlistProvider()),
        ChangeNotifierProvider(create: (_) => AddressProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => VoucherProvider()),
      ],
      child: MaterialApp(
        title: 'Menly',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.black,
            primary: Colors.black87,
          ),
          scaffoldBackgroundColor: const Color(0xFFF8F9FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black87,
            elevation: 0,
            scrolledUnderElevation: 1,
          ),
        ),
        home: const MainNavigationShell(),
      ),
    );
  }
}

/// Khung dieu huong chinh voi BottomNavigationBar
class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    ProductListPage(),
    WishlistPage(),
    CartPage(),
    MyOrdersPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final wishlist = context.watch<WishlistProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (idx) => setState(() => _currentIndex = idx),
        indicatorColor: Colors.grey.shade200,
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          const NavigationDestination(
            icon: Icon(Icons.checkroom_outlined),
            selectedIcon: Icon(Icons.checkroom),
            label: 'Sản phẩm',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: wishlist.count > 0,
              label: Text('${wishlist.count}'),
              child: const Icon(Icons.favorite_border),
            ),
            selectedIcon: Badge(
              isLabelVisible: wishlist.count > 0,
              label: Text('${wishlist.count}'),
              child: const Icon(Icons.favorite, color: Colors.red),
            ),
            label: 'Yêu thích',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: cart.totalItemCount > 0,
              label: Text('${cart.totalItemCount}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: cart.totalItemCount > 0,
              label: Text('${cart.totalItemCount}'),
              child: const Icon(Icons.shopping_bag),
            ),
            label: 'Giỏ hàng',
          ),
          const NavigationDestination(
            icon: Icon(Icons.receipt_long_outlined),
            selectedIcon: Icon(Icons.receipt_long),
            label: 'Đơn hàng',
          ),
        ],
      ),
    );
  }
}
