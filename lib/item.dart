class Item {
  int _id;
  String _kodeBarang;
  String _name;
  int _price;
  int _stok;


//getter dan setter stok
 int get stok => this._stok;
 set stok(int value) => this._stok = value;

//getter dan setter KodeBarang
  get kodeBarang => this._kodeBarang;

 set kodeBarang( value) => this._kodeBarang = value;


  int get id => _id;

  String get name => this._name;
  set name(String value) => this._name = value;


  get price => this._price;
  set price(value) => this._price = value;
// konstruktor versi 1
  Item(this._kodeBarang,this._name, this._price,this._stok);

// konstruktor versi 2: konversi dari Map ke Item
  Item.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._kodeBarang = map['kodeBarang'];
    this._name = map['name'];
    this._price = map['price'];
    this._stok = map['stok'];
  }
// konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['kodeBarang'] = kodeBarang;
    map['name'] = name;
    map['price'] = price;
    map['stok'] = stok;
    return map;
  }
}
