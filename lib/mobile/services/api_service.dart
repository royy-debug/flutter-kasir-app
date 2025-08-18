// import 'dart:async';

// import '../models/user.dart';
// import '../models/product.dart';
// import '../models/category.dart';
// import '../models/customer.dart';
// import '../models/sale.dart';
// import '../models/obat_detail.dart';

// /// Mock API Service – ganti dengan implementasi HTTP ke backend Anda.
// class ApiService {
//   static final ApiService _instance = ApiService._internal();
//   factory ApiService() => _instance;
//   ApiService._internal();

//   // Mock storage
//   final List<User> users = [
//     User(userId: 1, username: 'admin', role: 'admin', createdAt: DateTime.now()),
//     User(userId: 2, username: 'kasir', role: 'kasir', createdAt: DateTime.now()),
//   ];

//   final List<Category> categories = [
//     Category(categoryId: 1, name: 'Makanan'),
//     Category(categoryId: 2, name: 'Minuman'),
//   ];

//   late List<Product> products = [
//     Product(productId: 1, name: 'Roti', barcode: 'BR001', categoryId: 1, price: 10000, stock: 50, createdAt: DateTime.now()),
//     Product(productId: 2, name: 'Teh Botol', barcode: 'BR002', categoryId: 2, price: 7000, stock: 80, createdAt: DateTime.now()),
//   ];

//   final List<Customer> customers = [
//     Customer(customerId: 1, name: 'Pelanggan Umum'),
//   ];

//   final List<Sale> sales = [];
//   final List<SaleDetail> saleDetails = [];

//   Future<User?> login(String username, String password) async {
//     await Future.delayed(const Duration(milliseconds: 400));
//     // Karena mock, abaikan password, cocokkan username saja
//     try {
//       return users.firstWhere((u) => u.username == username);
//     } catch (_) {
//       return null;
//     }
//   }

//   Future<List<Product>> getProducts() async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     return products;
//   }

//   Future<List<Category>> getCategories() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     return categories;
//   }

//   Future<List<Customer>> getCustomers() async {
//     await Future.delayed(const Duration(milliseconds: 200));
//     return customers;
//   }

//   Future<Sale> createSale({
//     required int userId,
//     int? customerId,
//     required List<Map<String, dynamic>> items, // {productId, qty}
//     required double payment,
//   }) async {
//     await Future.delayed(const Duration(milliseconds: 300));
//     final newId = sales.length + 1;
//     double total = 0.0;
//     for (final it in items) {
//       final p = products.firstWhere((e) => e.productId == it['productId']);
//       total += p.price * (it['qty'] as int);
//     }
//     final change = payment - total;
//     final sale = Sale(
//       saleId: newId,
//       userId: userId,
//       customerId: customerId,
//       saleDate: DateTime.now(),
//       total: total,
//       payment: payment,
//       changeAmount: change,
//     );
//     sales.add(sale);

//     // details
//     for (final it in items) {
//       final p = products.firstWhere((e) => e.productId == it['productId']);
//       saleDetails.add(SaleDetail(
//         detailId: saleDetails.length + 1,
//         saleId: newId,
//         productId: p.productId,
//         quantity: it['qty'] as int,
//         price: p.price,
//         subtotal: p.price * (it['qty'] as int),
//       ));
//       // reduce stock
//       final idx = products.indexWhere((e) => e.productId == p.productId);
//       products[idx] = Product(
//         productId: p.productId,
//         name: p.name,
//         barcode: p.barcode,
//         categoryId: p.categoryId,
//         price: p.price,
//         stock: p.stock - (it['qty'] as int),
//         createdAt: p.createdAt,
//       );
//     }
//     return sale;
//   }
// }