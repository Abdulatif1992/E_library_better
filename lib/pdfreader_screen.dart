import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';

// it is for pdf books
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:flutter_one_epub/models/book.dart';
import 'package:flutter_one_epub/home_screen.dart';

//it is for File
import 'dart:io';
//it is for zip
import 'package:archive/archive.dart';
// it is for getting path
import 'package:path_provider/path_provider.dart';

class PdfReaderScreen extends StatefulWidget {
  const PdfReaderScreen({super.key, required this.book_id, required this.pdf_url});

  final int book_id;
  final String pdf_url;

  @override
  State<PdfReaderScreen> createState() => _PdfReaderScreenState();
}

class _PdfReaderScreenState extends State<PdfReaderScreen> {

  late PdfViewerController _pdfViewerController;
  final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState(){   
    _pdfViewerController = PdfViewerController();
    getSession();
    super.initState();
  }

  void getSession() async {
    int bookId = widget.book_id;
    dynamic book = await SessionManager().get("$bookId");
    //User u = User.fromJson(await SessionManager().get("user"));
    if (book != null) {
      _pdfViewerController.jumpToPage(book['page']);

      // int page = book['page'];
      // print("key bor $book page raqami esa $page");
    } else {
      // print("key yo'q bu kitobda");
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
               elevation: 0.0,
        leading: _appBarBack(context),       
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.article_outlined,
              color: Colors.blue,
            ),
            onPressed: () {_pdfViewerKey.currentState?.openBookmarkView();},
          ),
          IconButton(
            icon: Icon(
              Icons.zoom_in,
              color: Colors.blue,
            ),
            onPressed: () {_pdfViewerController.zoomLevel = 1.2;},
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_up,
              color: Colors.blue,
            ),
            onPressed: () {_pdfViewerController.previousPage();},
          ),
          IconButton(
            icon: Icon(
              Icons.keyboard_arrow_down,
              color: Colors.blue,
            ),
            onPressed: () {_pdfViewerController.nextPage();},
          ),
          IconButton(
            icon: Icon(
              Icons.bookmark,
              color: Colors.blue,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        child: SfPdfViewer.file(
              File(widget.pdf_url),
              pageLayoutMode: PdfPageLayoutMode.single,
              pageSpacing: 0,
              controller: _pdfViewerController,
             ),
      ),
    );
  }

    Widget _appBarBack(BuildContext context){
    return IconButton(
      onPressed: () {
        var page = _pdfViewerController.pageNumber;
        PdfBook book = PdfBook(bookId: '${widget.book_id}',bookUrl: widget.pdf_url, page: page);        
        SessionManager().set("${widget.book_id}", book);   

        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => HomeScrenn()),
        );
      },
      icon: Icon(Icons.arrow_back, color: Colors.blue,),
    );    
  }

}



