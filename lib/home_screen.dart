import 'package:flutter/material.dart';
//import 'package:vocsy_epub_viewer/epub_viewer.dart';

//my files
import 'package:flutter_one_epub/my_functions/functions.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScrenn extends StatefulWidget {
  const HomeScrenn({super.key});

  @override
  State<HomeScrenn> createState() => _HomeScrennState();
}

class _HomeScrennState extends State<HomeScrenn> {
 
  @override
  void initState() {
    super.initState();
  }

    
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title:'Epub reader',
        home: Scaffold(
          appBar: AppBar(title: const Text('Epub reader')), 
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
                        children: [
                          _myBooks(),
                          _myBooks(),
                          _firstTitle(),
                          _firstTitle()
                        ],
                      ),
                    ),
                  ),

                  _titleFromInternet(),

                  SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
                        _allBooks(),
                        _allBooks(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                        _titleFromInternet(),
                      ],
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

  Widget _myBooks(){
    try{
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
    on Exception catch (_) {
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

  Widget _titleFromInternet(){
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Icon(
            Icons.file_download_sharp,
            color: Colors.black,
            size: 36.0,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              'All books',
              style: GoogleFonts.roboto(
                fontSize: 22.0, fontWeight: FontWeight.normal
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _allBooks(){
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
            _imgBase64(),            
            _detail(),
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

  Widget _imgBase64(){
    try{
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
    on Exception catch (_) {
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

  Widget _detail(){
    double screenWidth = MediaQuery.of(context).size.width;
    return Flexible(
      child: Container(
        margin: EdgeInsets.only(top: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Salova agar mavzu uzun bo'lib ketsa qanaqa holat bo'ladi kuraylik", overflow: TextOverflow.ellipsis, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),),
            Container(width: screenWidth-200.0, height: 65.0 ,child: Text("salova Salova agar mavzu uzun bo'lib ketsa qanaqa holat bo'ladi kuraylik salova Salova agar mavzu uzun bo'lib ketsa qanaqa holat bo'ladi kuraylik salova Salova agar mavzu uzun bo'lib ketsa qanaqa holat bo'ladi kuraylik")),
            TextButton.icon(
              onPressed: () {
                  // Respond to button press
              },
              icon: Icon(Icons.file_open, size: 16),
              label: Text("detail"),
            )
            
          ],
        ),
      ),
    );
  }

}