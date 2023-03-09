import 'package:flutter/material.dart';

import '../../utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage(this.uid, {super.key});

  final String uid;

  @override
  State<HomePage> createState() => _HomePageState(uid);
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  _HomePageState(this.uid);

  final String uid;

  final Product _product = Product([]);

  final _sectionController = TextEditingController();
  final _itemTitleController = TextEditingController();
  final _itemPriceController = TextEditingController();
  final _itemQuantityController = TextEditingController();

  late TabController _tabController;

  final formKey = GlobalKey<FormState>();
  final sectionFormKey = GlobalKey<FormState>();

  @override
  void initState() {
    print(uid);
    super.initState();
    _tabController =
        TabController(length: _product.sections.length, vsync: this);
  }

  void _addSection(BuildContext context) {
    if (sectionFormKey.currentState!.validate()) {
      setState(() {
        _product.sections.add(ProductSection(_sectionController.text, []));
        _tabController =
            TabController(length: _product.sections.length, vsync: this);
        _sectionController.clear();
        Navigator.of(context).pop();
      });
    }
  }

  void _addItem(int sectionIndex, BuildContext context) {
    if (formKey.currentState!.validate()) {
      setState(() {
        _product.sections[sectionIndex].items.add(ProductItem(
            _itemTitleController.text,
            int.parse(_itemPriceController.text),
            int.parse(_itemQuantityController.text)));
        _itemTitleController.clear();
        _itemPriceController.clear();
        _itemQuantityController.clear();
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 14,
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 60,
                      margin: const EdgeInsets.only(top: 6, bottom: 14),
                      child: TabBar(
                        controller: _tabController,
                        indicator: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            border: Border.all(
                              color: Colors.deepOrange,
                              width: 3,
                            )),
                        isScrollable: true,
                        tabs: _product.sections
                            .map((section) => Tab(text: section.name))
                            .toList(),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              alignment: Alignment.center,
                              backgroundColor: Color(appBackgroundColor),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                width: 200,
                                height: 171,
                                child: Form(
                                  key: sectionFormKey,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Section title can\'t be empty';
                                          }
                                          return null;
                                        },
                                        controller: _sectionController,
                                        style: const TextStyle(
                                            color: Colors.white70),
                                        decoration: InputDecoration(
                                          labelText: 'Section Title',
                                          labelStyle: const TextStyle(
                                              color: Colors.white70),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            minimumSize:
                                                const Size.fromHeight(40)),
                                        onPressed: () {
                                          _addSection(context);
                                        },
                                        child: const Text('Save'),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          });
                    },
                    child: const Text('Add Section'),
                  ),
                ],
              ),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: _product.sections
                      .map((section) => GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4,
                                    childAspectRatio: (1.9 / 1),
                                    mainAxisSpacing: 10,
                                    crossAxisSpacing: 10),
                            itemCount: section.items.length,
                            itemBuilder: (BuildContext context, int itemIndex) {
                              return item(
                                  title: section.items[itemIndex].title,
                                  price: '${section.items[itemIndex].price}EG',
                                  qty:
                                      '${section.items[itemIndex].quantity} item');
                            },
                          ))
                      .toList(),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        if (_product.sections.isEmpty) {
                          return AlertDialog(
                            title: const Text('Add Sections First!'),
                            content: const Text(
                                'You should add a section before adding items'),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('ok'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          );
                        }
                        return Dialog(
                          backgroundColor: Color(appBackgroundColor),
                          child: Container(
                            width: 500,
                            height: 270,
                            padding: const EdgeInsets.all(16),
                            child: Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  TextFormField(
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Title can\'t be empty';
                                      }
                                      return null;
                                    },
                                    controller: _itemTitleController,
                                    style:
                                        const TextStyle(color: Colors.white70),
                                    decoration: InputDecoration(
                                      labelText: 'Item Title',
                                      labelStyle: const TextStyle(
                                          color: Colors.white70),
                                      border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: 229,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Price can\'t be empty';
                                            } else if (!(int.tryParse(value) !=
                                                null)) {
                                              return 'Price can\'t be text, only numbers';
                                            }
                                            return null;
                                          },
                                          controller: _itemPriceController,
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          decoration: InputDecoration(
                                            labelText: 'Item Price',
                                            labelStyle: const TextStyle(
                                                color: Colors.white70),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      SizedBox(
                                        width: 229,
                                        child: TextFormField(
                                          validator: (value) {
                                            if (value == null ||
                                                value.isEmpty) {
                                              return 'Quantity can\'t be empty';
                                            } else if (!(int.tryParse(value) !=
                                                null)) {
                                              return 'Quantity can\'t be text, only numbers';
                                            }
                                            return null;
                                          },
                                          controller: _itemQuantityController,
                                          style: const TextStyle(
                                              color: Colors.white70),
                                          decoration: InputDecoration(
                                            labelText: 'Item Quantity',
                                            labelStyle: const TextStyle(
                                                color: Colors.white70),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                        minimumSize: const Size.fromHeight(40)),
                                    onPressed: () {
                                      _addItem(_tabController.index, context);
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: const Text('Add Item'),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          flex: 5,
          child: Column(
            children: [
              orderedItemsHeader(
                title: 'Order',
                subTitle: 'Table 8',
                action: Container(),
              ),
              Expanded(
                child: ListView(
                  children: [
                    orderedItem(
                      title: 'Original Burger',
                      qty: '2',
                      price: '\$5.99',
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    color: const Color(0xff1f2029),
                  ),
                  child: ListView(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Sub Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '40.32 Eg',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Tax',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '4.32 Eg',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 20),
                        height: 2,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Total',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Text(
                            '44.64 Eg',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.deepOrange,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {},
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.print),
                            SizedBox(width: 6),
                            Text('Print Bills')
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget orderedItem({
    required String title,
    required String qty,
    required String price,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xff131721),
      ),
      child: Row(
        children: [
          Container(
            height: 60,
            width: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  '26 Eg',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
          Text(
            '$qty x',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget item({
    required String title,
    required String price,
    required String qty,
  }) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: const Color(0xff131721),
      ),
      child: Column(
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                price,
                style: const TextStyle(
                  color: Colors.deepOrange,
                  fontSize: 20,
                ),
              ),
              Text(
                qty,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget section({required String title, required bool isActive}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const Color(0xff1f2029),
        border: isActive
            ? Border.all(color: Colors.deepOrangeAccent, width: 3)
            : Border.all(color: const Color(0xff1f2029), width: 3),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.fastfood,
            size: 25,
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget orderedItemsHeader({
    required String title,
    required String subTitle,
    required Widget action,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Cairo Cash',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Pos System',
              style: TextStyle(
                color: Colors.white54,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(flex: 1, child: Container(width: double.infinity)),
        Expanded(flex: 5, child: action),
      ],
    );
  }
}

class ProductSection {
  String name;
  List<ProductItem> items;

  ProductSection(this.name, this.items);
}

class ProductItem {
  String title;
  int price;
  int quantity;

  ProductItem(this.title, this.price, this.quantity);
}

class Product {
  List<ProductSection> sections;

  Product(this.sections);
}
