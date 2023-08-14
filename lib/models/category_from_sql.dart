class CategoryFromSql{
  int? _id;
  String? _category_name;

  CategoryFromSql(this._id, this._category_name);

  int get id => _id!;
  String get category_name => _category_name!; 

  // Convert a CategoryFromSql object into a Map object
  // becouse SqlLite database works with Map object

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['id'] = _id;
    map['category_name'] = _category_name;
    return map;
  }

  //Extract a BookFromSql object from a Map object
  CategoryFromSql.fromMapObject(Map<String, dynamic> map){
    this._id = map['id'];
    this._category_name = map['category_name'];
  }

}