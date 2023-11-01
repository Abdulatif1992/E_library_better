import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:convert';


//my files
import 'package:flutter_one_epub/models/book_from_sql.dart';
import 'package:flutter_one_epub/utils/database_helper.dart';
import 'package:flutter_one_epub/detail_screen.dart';


class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key, required this.catId, required this.catName});

  final int catId;
  final String catName;

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  DatabaseHelper databaseHelper = DatabaseHelper();
  var bookList = List<BookFromSql>.empty();

  @override
  void initState(){
    _getData();
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, 
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _firstTitle(widget.catName),

                SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  physics: const BouncingScrollPhysics(),
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


  // get bookList from sqflite
  Future<void> _getData() async {
    
    bookList = await databaseHelper.getBookListCategoried(widget.catId);
    setState(() {
      bookList = bookList;     
    });
  }

  Widget _firstTitle(String catName){
    try {
      return Padding(
        padding: const EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 12.0),
        child: Row(
          children: [
            const Icon(
              Icons.menu_book,
              color: Colors.blueGrey,
              size: 26.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                catName,
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
        padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 12.0),
        child: Row(
          children: [
            const Icon(
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

  Widget _allBooks(BookFromSql book){
    try{
      return Container(
        //color: Colors.pink,
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        height: 150.0,
        decoration: BoxDecoration(
          color: const Color.fromARGB(50, 171, 207, 240),
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
          color: const Color.fromARGB(255, 171, 207, 240),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: const [
            Text("Paka salom")
          ],
        ),
      );
    }
  }

    Widget _imgBase64(int bookId, String base64){
    try{
      return Container(
        margin: const EdgeInsets.all(5),
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
      return Container(
        margin: const EdgeInsets.all(5),
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
        margin: const EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(book.book_name, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
            Container(width: screenWidth-200.0, height: 60.0 ,child: Text(book.book_title)),
            TextButton.icon(
              onPressed: () {
                  // Respond to button press
                  Navigator.push(
                    context, 
                    MaterialPageRoute(builder: (context) => DetailScreen(book: book)),
                    );
              },
              icon: const Icon(Icons.file_open, size: 16),
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
      decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1.5, color: Colors.grey),
            ),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          btype=="pdf"? Text(btype):const Text(''),
          const Icon(Icons.done_all, color: Colors.green,),
        ],
      ),
    );
    }
    else{
      return Container(
      width: 30.0,
      height: 80.0,
      decoration: const BoxDecoration(
            border: Border(
              left: BorderSide(width: 1.5, color: Colors.grey),
            ),
          ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          btype=="pdf"? Text(btype):const Text(''),
          const Icon(Icons.file_download, color: Colors.red,),
        ],
      ),
    );
    }
  }

}