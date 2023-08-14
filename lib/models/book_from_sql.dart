class BookFromSql{
  int? _book_id;
  String? _book_name;
  String? _book_title;
  String? _book_type;
  int? _category_id;
  int? _status;
  String? _base64;
  int? _upd;
  int? _dtime;

  BookFromSql(this._book_id, this._book_name, this._book_title, this._book_type, this._category_id, this._status, this._base64, this._upd, this._dtime);

  int get book_id => _book_id!;
  String get book_name => _book_name!;
  String get book_title => _book_title!;
  String get book_type => _book_type!;
  int get category_id =>_category_id!;
  int get status =>_status!;
  String get base64 => _base64!;  
  int get upd => _upd!;  
  int get dtime => _dtime!;  

  // Convert a BookFromSql object into a Map object
  // becouse SqlLite database works with Map object

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['book_id'] = _book_id;
    map['book_name'] = _book_name;
    map['book_title'] = _book_title;
    map['book_type'] = _book_type;
    map['category_id'] = _category_id;
    map['status'] = _status;
    map['base64'] = _base64;
    map['upd'] = _upd;
    map['dtime'] = _dtime;

    return map;
  }

  //Extract a BookFromSql object from a Map object
  BookFromSql.fromMapObject(Map<String, dynamic> map){
    this._book_id = map['book_id'];
    this._book_name = map['book_name'];
    this._book_title = map['book_title'];
    this._book_type = map['book_type'];
    this._category_id = map['category_id'];
    this._status = map['status'];
    this._base64 = map['base64'];
    this._upd = map['upd'];
    this._dtime = map['dtime'];
  }

}