class ItemModel {
  final String _title;
  final String _price;
  final String _quantity;

  ItemModel(this._title, this._price, this._quantity);

  String get quantity => _quantity;

  String get price => _price;

  String get title => _title;
}
