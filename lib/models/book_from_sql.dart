class BookFromSql{
  int? _bookId;
  String? _bookName;
  String? _bookTitle;
  String? _bookType;
  int? _categoryId;
  int? _status;
  String? _base64;
  int? _upd;
  int? _dtime;

  BookFromSql(this._bookId, this._bookName, this._bookTitle, this._bookType, this._categoryId, this._status, this._base64, this._upd, this._dtime);

  int get book_id => _bookId!;
  String get book_name => _bookName!;
  String get book_title => _bookTitle!;
  String get book_type => _bookType!;
  int get category_id =>_categoryId!;
  int get status =>_status!;
  String get base64 => _base64!;  
  int get upd => _upd!;  
  int get dtime => _dtime!;  

  // Convert a BookFromSql object into a Map object
  // becouse SqlLite database works with Map object

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['book_id'] = _bookId;
    map['book_name'] = _bookName;
    map['book_title'] = _bookTitle;
    map['book_type'] = _bookType;
    map['category_id'] = _categoryId;
    map['status'] = _status;
    map['base64'] = _base64;
    map['upd'] = _upd;
    map['dtime'] = _dtime;

    return map;
  }

  //Extract a BookFromSql object from a Map object
  BookFromSql.fromMapObject(Map<String, dynamic> map){
    this._bookId = map['book_id'];
    this._bookName = map['book_name'];
    this._bookTitle = map['book_title'];
    this._bookType = map['book_type'];
    this._categoryId = map['category_id'];
    this._status = map['status'];
    this._base64 = map['base64'];
    this._upd = map['upd'];
    this._dtime = map['dtime'];
  }

}