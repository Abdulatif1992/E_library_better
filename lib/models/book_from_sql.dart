class BookFromSql{
  int? _book_id;
  String? _book_name;
  String? _book_title;
  String? _book_url;
  String? _base64;
  int? _upd;

  BookFromSql(this._book_id, this._book_name, this._book_title, this._book_url, this._base64, this._upd);

  int get book_id => _book_id!;
  String get book_name => _book_name!;
  String get book_title => _book_title!;
  String get book_url =>_book_url!;
  String get base64 => _base64!;  
  int get upd => _upd!;  

  // Convert a BookFromSql object into a Map object
  // becouse SqlLite database works with Map object

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['book_id'] = _book_id;
    map['book_name'] = _book_name;
    map['book_title'] = _book_title;
    map['book_url'] = _book_url;
    map['base64'] = _base64;
    map['upd'] = _upd;

    return map;
  }

  //Extract a BookFromSql object from a Map object
  BookFromSql.fromMapObject(Map<String, dynamic> map){
    this._book_id = map['book_id'];
    this._book_name = map['book_name'];
    this._book_title = map['book_title'];
    this._book_url = map['book_url'];
    this._base64 = map['base64'];
    this._upd = map['upd'];
  }

}