// import 'package:flutter/material.dart';
// import '../widgets/app_bar.dart';
// import '../services/api_service.dart';
// import '../models/customer.dart';

// class CustomerScreen extends StatefulWidget {
//   static const routeName = '/customers';
//   const CustomerScreen({super.key});

//   @override
//   State<CustomerScreen> createState() => _CustomerScreenState();
// }

// class _CustomerScreenState extends State<CustomerScreen> {
//   final _api = ApiService();
//   List<Customer> _items = [];

//   final _name = TextEditingController();
//   final _phone = TextEditingController();
//   final _address = TextEditingController();

//   Future<void> _load() async {
//     final items = await _api.getCustomers();
//     setState(() { _items = items; });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _load();
//   }

//   void _addCustomerDialog() {
//     showDialog(
//       context: context,
//       builder: (_) => AlertDialog(
//         title: const Text('Tambah Pelanggan'),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(controller: _name, decoration: const InputDecoration(labelText: 'Nama')),
//               TextField(controller: _phone, decoration: const InputDecoration(labelText: 'HP')),
//               TextField(controller: _address, decoration: const InputDecoration(labelText: 'Alamat')),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
//           ElevatedButton(
//             onPressed: () {
//               setState(() {
//                 final newId = _items.length + 1;
//                 _items.add(Customer(customerId: newId, name: _name.text, phone: _phone.text, address: _address.text));
//               });
//               _name.clear(); _phone.clear(); _address.clear();
//               Navigator.pop(context);
//             },
//             child: const Text('Simpan'),
//           )
//         ],
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: CustomAppBar(titleText: 'Pelanggan'),
//       floatingActionButton: FloatingActionButton(onPressed: _addCustomerDialog, child: const Icon(Icons.add)),
//       body: ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: _items.length,
//         separatorBuilder: (_, __) => const SizedBox(height: 8),
//         itemBuilder: (_, i) {
//           final c = _items[i];
//           return Card(
//             child: ListTile(
//               title: Text(c.name),
//               subtitle: Text([c.phone, c.address].where((e) => (e ?? '').isNotEmpty).join(' • ')),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }