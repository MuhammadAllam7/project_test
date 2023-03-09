import 'package:cairo_cash/pages/main_page.dart';
import 'package:cairo_cash/pages/others/login_page.dart';
import 'package:cairo_cash/services/bloc/observer.dart';
import 'package:cairo_cash/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = MyBlocObserver();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  final prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('loggedIn') ?? false;
  String uid = prefs.getString('uid') ?? '';

  runApp(MyApp(isLoggedIn, uid));
}

class MyApp extends StatelessWidget {
  const MyApp(this.isLoggedIn, this.uid, {super.key});

  final bool isLoggedIn;
  final String uid;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CairoCash',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        scaffoldBackgroundColor: Color(appBackgroundColor),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      home: (!isLoggedIn || uid.isEmpty) ? const LoginPage() : MainPage(uid),
      debugShowCheckedModeBanner: false,
    );
  }
}

// with cubit

/*

class ProductSection {
  String name;
  List<String> items;

  ProductSection(this.name, this.items);
}

class Product {
  List<ProductSection> sections;

  Product(this.sections);
}

class ProductCubit extends Cubit<Product> {
  ProductCubit() : super(Product([
    ProductSection('Section 1', ['Item 1', 'Item 2']),
    ProductSection('Section 2', ['Item 3', 'Item 4']),
  ]));

  void addSection(String sectionName) {
    final List<ProductSection> updatedSections = List.from(state.sections);
    updatedSections.add(ProductSection(sectionName, []));
    emit(Product(updatedSections));
  }

  void addItem(int sectionIndex, String itemName) {
    final List<ProductSection> updatedSections = List.from(state.sections);
    updatedSections[sectionIndex].items.add(itemName);
    emit(Product(updatedSections));
  }
}

class App extends StatelessWidget {
  final _sectionController = TextEditingController();
  final _itemController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProductCubit(),
      child: MaterialApp(
        title: 'Product Sections and Items',
        home: Scaffold(
          appBar: AppBar(
            title: const Text('Product Sections and Items'),
            bottom: BlocBuilder<ProductCubit, Product>(
              builder: (context, product) => TabBar(
                isScrollable: true,
                tabs: product.sections
                    .map((section) => Tab(text: section.name))
                    .toList(),
              ),
            ),
          ),
          body: BlocBuilder<ProductCubit, Product>(
            builder: (context, product) => TabBarView(
              children: product.sections
                  .map((section) => GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 2,
                ),
                itemCount: section.items.length,
                itemBuilder: (BuildContext context, int itemIndex) {
                  return Card(
                    child: Center(
                      child: Text(section.items[itemIndex]),
                    ),
                  );
                },
              ))
                  .toList(),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _itemController,
                  decoration: const InputDecoration(hintText: 'Add item...'),
                ),
              ),
              BlocBuilder<ProductCubit, Product>(
                builder: (context, product) => ElevatedButton(
                  onPressed: () =>
                      context.read<ProductCubit>().addItem(
                          DefaultTabController.of(context)?.index ?? 0,
                          _itemController.text),
                  child: const Text('Add Item'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _sectionController,
                  decoration: const InputDecoration(hintText: 'Add section...'),
                ),
              ),
              BlocBuilder<ProductCubit, Product>(
                builder: (context, product) => ElevatedButton(
                  onPressed: () {
                    context.read<ProductCubit>().addSection(_sectionController.text);
                    _sectionController.clear();
                  },
                  child: const Text('Add Section'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

*/
