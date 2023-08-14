import 'package:flutter/material.dart';
import 'package:flutter_one_epub/category_screen.dart';
import 'package:flutter_one_epub/models/category_from_sql.dart';
import 'package:flutter_one_epub/utils/database_helper_category.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';

//it is for tuple function
import 'package:tuple/tuple.dart';
//it is for http
import 'package:http/http.dart';
// it is for checking internet connection
import 'package:internet_connection_checker/internet_connection_checker.dart';

//my files
import 'package:flutter_one_epub/models/book_from_sql.dart';
import 'package:flutter_one_epub/utils/database_helper.dart';
import 'package:flutter_one_epub/detail_screen.dart';
import 'package:flutter_one_epub/epubreader_screen.dart';
import 'package:flutter_one_epub/pdfreader_screen.dart';


class HomeScrenn extends StatefulWidget {
  const HomeScrenn({super.key});

  @override
  State<HomeScrenn> createState() => _HomeScrennState();
}

class _HomeScrennState extends State<HomeScrenn> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  DatabaseHelperCategory databaseHelperCategory = DatabaseHelperCategory();
  var bookList = List<BookFromSql>.empty();
  var bookListDownloaded = List<BookFromSql>.empty();
  var categoryList = List<CategoryFromSql>.empty();
  // int count = 0;
  // int countDownloaded = 0;

 
  @override
  void initState(){
    _getData();
    checkInternet();
    super.initState();    
  }

    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(      
      home: Scaffold( 
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _firstTitle(),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    //color: Colors.pink,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 171, 207, 240),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: bookListDownloaded.map((book) => InkWell(
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => EpubReaderScreen(book_id: book.book_id)),
                          );
                        },
                        child: _myBooks(book.book_id, book.base64),
                      )).toList(),                   
                    ),
                  ),
                ),

                _categoriesTitle(),

                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  child: Container(
                    //color: Colors.pink,
                    decoration: BoxDecoration(
                      color: Color.fromARGB(50, 171, 207, 240),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: categoryList.map((category) => InkWell(   
                        onTap: () {
                          Navigator.push(
                            context, 
                            MaterialPageRoute(builder: (context) => CategoryScreen(cat_id: category.id, cat_name: category.category_name)),
                          );
                        },                     
                        child: _myCategories(category.category_name),
                      )).toList(),                   
                    ),
                  ),
                ),

                _titleFromInternet(),               

                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: bookList.map((book) => InkWell(
                      child: _allBooks(book),
                    )).toList(),
                  ),
                )
              ],
            ),
          ),
        ),            
      ),
    );
  }

  Widget _firstTitle(){
    try {
      return Padding(
        padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
        child: Row(
          children: [
            Icon(
              Icons.menu_book,
              color: Colors.blueGrey,
              size: 26.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'My books',
                style: GoogleFonts.roboto(
                  fontSize: 22.0, fontWeight: FontWeight.bold, color: Colors.blueGrey
                ),
              ),
            ),
          ],
        ),
      );
    } on Exception catch (_) {
      return Padding(
        padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
        child: Row(
          children: [
            Icon(
              Icons.menu_book,
              color: Colors.black,
              size: 36.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'My books',
                style: GoogleFonts.roboto(
                  fontSize: 28.0, fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      );
    }

    
  }

  Widget _categoriesTitle(){
    try {
      return Padding(
        padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
        child: Row(
          children: [
            Icon(
              Icons.article_outlined,
              color: Colors.blueGrey,
              size: 26.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Categories',
                style: GoogleFonts.roboto(
                  fontSize: 22.0, fontWeight: FontWeight.normal, color: Colors.blueGrey
                ),
              ),
            ),
          ],
        ),
      );
    } on Exception catch (_) {
      return Padding(
        padding: EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
        child: Row(
          children: [
            Icon(
              Icons.menu_book,
              color: Colors.black,
              size: 36.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Categories',
                style: GoogleFonts.roboto(
                  fontSize: 28.0, fontWeight: FontWeight.bold
                ),
              ),
            ),
          ],
        ),
      );
    }

    
  }

  Widget _myBooks(int book_id, String base64){
    try{
      return Container(
        margin: EdgeInsets.all(5),
        height: 200,
        width: 160,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.memory(
                base64Decode("$base64"),
                height: 200.0,
                width: 160.0,   
            ),
        )
      );
    }
    on Exception catch (_) {
      updateBook(book_id);
      return Container(
        margin: EdgeInsets.all(5),
        height: 200,
        width: 160,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset('assets/img/No_image.png',
                height: 200.0,
                width: 160.0,   
            ),
        )
      );
    }
  }

  Widget _myCategories(String cat_name){    
    return Container(
      margin: EdgeInsets.all(8),
      height: 25.0,
      child: ClipRRect(        
          borderRadius: BorderRadius.circular(10.0),
          child: Container(
            //margin: EdgeInsets.all(2.0),
            padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 6.0),
            color: Colors.lightBlue,
            child: Text(
              '$cat_name',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.w600, // light
                fontStyle: FontStyle.italic, // italic
              ),
            ),
          ),
      ),      
    );
  }

  Widget _titleFromInternet(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.file_download_sharp,
            color: Colors.blueGrey,
            size: 26.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'All books',
              style: GoogleFonts.roboto(
                fontSize: 22.0, fontWeight: FontWeight.normal, color: Colors.blueGrey
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _allBooks(BookFromSql book){
    try{
      return Container(
        //color: Colors.pink,
        margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
        height: 150.0,
        decoration: BoxDecoration(
          color: Color.fromARGB(50, 171, 207, 240),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            _imgBase64(book.book_id ,book.base64),            
            _detail(book),
            _detailIcon(book.upd, book.book_type),
          ],
        ),
      );
    }
    on Exception catch(_){
      return Container(
        //color: Colors.pink,        
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 171, 207, 240),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Text("Paka salom")
          ],
        ),
      );
    }
  }

  Widget _imgBase64(int book_id, String base64){
    try{
      return Container(
        margin: EdgeInsets.all(5),
        height: 150,
        width: 120,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.memory(
                base64Decode("$base64"),
                height: 150.0,
                width: 120.0,   
            ),
        )
      );
    }
    on Exception catch (_) {
      updateBook(book_id);
      return Container(
        margin: EdgeInsets.all(5),
        height: 150,
        width: 120,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(12.0),
            child: Image.asset('assets/img/No_image.png',
                height: 150.0,
                width: 120.0,   
            ),
        )
      );
    }
  }

  Widget _detail(BookFromSql book){
    double screenWidth = MediaQuery.of(context).size.width;
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${book.book_name}", overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
            Container(width: screenWidth-200.0, height: 65.0 ,child: Text(book.book_title)),
            TextButton.icon(
              onPressed: () {
                  // Respond to button press
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => DetailScreen(book: book)),
                    );
              },
              icon: Icon(Icons.file_open, size: 16),
              label: const Text("detail", style: TextStyle(fontSize: 18.0),),
            )
            
          ],
        ),
      ),
    );
  }

  Widget _detailIcon(int upd, String btype){
    if(upd==1){
      return Container(
      width: 30.0,
      height: 80.0,
      decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 1.5, color: Colors.grey),
            ),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          btype=="pdf"? Text(btype):Text(''),
          Icon(Icons.done_all, color: Colors.green,),
        ],
      ),
    );
    }
    else{
      return Container(
      width: 30.0,
      height: 80.0,
      decoration: BoxDecoration(
            border: Border(
              left: BorderSide(width: 1.5, color: Colors.grey),
            ),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          btype=="pdf"? Text(btype):Text(''),
          Icon(Icons.file_download, color: Colors.red,),
        ],
      ),
    );
    }
  }

  //save data to database
  // void _save() async {
  //   //BookFromSql book = BookFromSql(_book_id, _book_name, _book_title, _book_url, _base64);
  //   BookFromSql book = BookFromSql(1116, "My check javascripti", "title ham borda", "assets/book/javascript.epub", "blablabla",0);
  //   int? result; 
  //   result = await databaseHelper.insertBook(book);
  //   if(result != 0){
  //     print('success');
  //   }
  //   else{print('problem');}

  // }

  void _getCount() async {
    int? result;
    result = await databaseHelper.getCount();
    print(result);
  }

  // get bookList from sqflite
  Future<void> _getData() async {
    bookList = await databaseHelper.getBookList();
    bookListDownloaded = await databaseHelper.getBookListDowloaded();
    categoryList = await databaseHelperCategory.getCategoryList();
    setState(() {
      categoryList = categoryList;
      bookList = bookList;
      bookListDownloaded = bookListDownloaded;      
    });
  }

  Future<Tuple2<List?, String?>> getBooksId() async {
    try {
      Response response = await post(
              Uri.http('uzfootball.000webhostapp.com', '/api/booksid'),
              headers: {"Keep-Alive": "timeout=5, max=1"})
          .timeout(const Duration(seconds: 5));
      //print(response.statusCode);
      if (response.statusCode == 200) {
        List booksId = jsonDecode(response.body) as List;
        return Tuple2(booksId, null);
      } else {
        return Tuple2(null, 'xatolik response');
      }
    } catch (e) {
      return Tuple2(null, 'xatolik try tuple');
    }
  }

  Future<bool> getCategories(List catsId) async {
    try {
      Response response = await post(
              Uri.http('uzfootball.000webhostapp.com', '/api/getcategories/$catsId'),
              headers: {"Keep-Alive": "timeout=5, max=1"})
          .timeout(const Duration(seconds: 5));
      //print(response.statusCode);
      if (response.statusCode == 200) {
        List<dynamic> categories = await jsonDecode(response.body);
        categories.forEach((data) => {
          databaseHelperCategory.insertCategory(CategoryFromSql(data['id'], data['name'])),
        });
      return true;  
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> checkInternet() async {
    bool check = await InternetConnectionChecker().hasConnection;
    if (check) {
      List oldCats = await databaseHelperCategory.getCategoryList();
      List oldCatsId = [0];
      for (var i = 0; i < oldCats.length; i++) {
        oldCatsId.add(oldCats[i].id);
      }      
      bool getcategories = await getCategories(oldCatsId);
      var booksId = await getBooksId();
      if (booksId.item2 == null) {
        List oldBooksId = [];
        List mainBooksId = [0];
        for (var i = 0; i < bookList.length; i++) {
          oldBooksId.add(bookList[i].book_id);
        }
        //contains function tells us the list already has the element or not
        for (var i = 0; i < booksId.item1!.length; i++) {
          if (oldBooksId.contains(booksId.item1![i]) == false) {
            mainBooksId.add(booksId.item1![i]);
          }
        }
        bool check = await getAllBooks(mainBooksId);
      } else {
        print(booksId.item2);
      }
    } else {
      print('No Internet');
    }
  }

  //get book from API and save it to sqflite
  // Future<bool> getOneBook(int book_id) async {
  //   try {
  //     Response response = await post(
  //             Uri.http('uzfootball.000webhostapp.com', '/api/getbook/$book_id'),
  //             headers: {"Keep-Alive": "timeout=5, max=1"})
  //         .timeout(const Duration(seconds: 5));
  //     if (response.statusCode == 200) {
  //       int timestamp = DateTime.now().millisecondsSinceEpoch;
  //       Map<String, dynamic> data = await jsonDecode(response.body);
  //       BookFromSql book = BookFromSql(data['book_id'], data['book_name'], data['book_title'], data['book_url'], data['base64'], 0, timestamp);
  //       await databaseHelper.insertBook(book);
  //       await  _getData();
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } catch (e) {
  //     return false;
  //   }
  // }

  Future<bool> getAllBooks(List books_id) async {
    try {
      Response response = await post(
              Uri.http('uzfootball.000webhostapp.com', '/api/getbooks/$books_id'),
              headers: {"Keep-Alive": "timeout=5, max=1"})
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        List<dynamic> books = await jsonDecode(response.body);
        books.forEach((data) => {
          databaseHelper.insertBook(BookFromSql(data['book_id'], data['book_name'], data['book_title'], data['book_type'], data['cat_id'], data['status'], data['base64'], 0, DateTime.now().millisecondsSinceEpoch))
          //databaseHelper.insertBook(BookFromSql(_book_id, _book_name, _book_title, _book_type,  _status, _base64, _upd, _dtime))
        });
        await  _getData();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<void> updateBook(int book_id) async {
    try{
      Response response = await post(
              Uri.http('uzfootball.000webhostapp.com', '/api/getbook/$book_id'),
              headers: {"Keep-Alive": "timeout=5, max=1"})
          .timeout(const Duration(seconds: 5));
      if (response.statusCode == 200) {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        Map<String, dynamic> data = await jsonDecode(response.body);
        BookFromSql book = BookFromSql(data['book_id'], data['book_name'], data['book_title'], data['book_type'], data['cat_id'], data['status'], data['base64'], 0, timestamp);
        await databaseHelper.updateBook(book);
        await  _getData();
      } 
    }catch (e) {
      print("xatolik");
    }

  }

  Future<void> updateTime(int book_id) async {
    DateTime now = DateTime.now();
    int timestamp = now.millisecondsSinceEpoch;
    print(now);
    print(timestamp);
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    print(date);
    _getData();

  }

  



}