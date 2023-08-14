import 'package:flutter/material.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:convert'; // it for jsonDecode

//my files
import 'package:flutter_one_epub/models/book.dart';
import 'package:flutter_one_epub/utils/database_helper.dart';
import 'package:flutter_one_epub/home_screen.dart';
import 'package:flutter_one_epub/pdfreader_screen.dart';

// it is for getting path
import 'package:path_provider/path_provider.dart';
//it is for File
import 'dart:io';
//it is for zip
import 'package:archive/archive.dart';


class EpubReaderScreen extends StatefulWidget {
  const EpubReaderScreen({super.key, required this.book_id});

  final int book_id;

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  @override
  void initState(){   
    unzipEpub(widget.book_id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(

      ),
    );
  }


  Future<void>unzipEpub(int bookid) async{
    String _dir = (await getApplicationDocumentsDirectory()).path;

    String book_url = "$_dir/$bookid.zip";
    if(await File(book_url).exists()==true)
    {
      // Read the Zip file from disk.
      var bytes = File("$_dir/$bookid.zip").readAsBytesSync();

      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(
        bytes,
        verify: true,
        password: "sazagan_92",
        );

      // Extract the contents of the Zip archive to disk.
      String extention = "";
      String PdfUrl = "";
      for (var file in archive) {
        String full_name = file.name;
        extention = full_name.substring(full_name.indexOf('.'));

        var fileName = '$_dir/$bookid$extention';
        PdfUrl = fileName;
        if (file.isFile) {
          var outFile = File(fileName);
          print('File::' + outFile.path);
          //_tempImages.add(outFile.path);
          outFile = await outFile.create(recursive: true);
          await outFile.writeAsBytes(file.content);
        }
      }
      if(extention=='.epub')
      {
        await  openEpub(bookid);
      }
      else
      {
        int timestamp = DateTime.now().millisecondsSinceEpoch;
        await DatabaseHelper().updateBookDtime(bookid, timestamp);
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => PdfReaderScreen(book_id: bookid, pdf_url: PdfUrl)),
          
        );
      }
      
    }
    else{
      print("zip file is not exist");
    }
  }

  openEpub(int bookid) async {
    EpubBook? book;
    String _dir = (await getApplicationDocumentsDirectory()).path;
    String book_Url = "$_dir/$bookid.epub";
    bool checker = await SessionManager().containsKey("$bookid");
    if(checker)
    {
      book  = EpubBook.fromJson( await SessionManager().get("$bookid"));
    }
    else{book = EpubBook(bookId: "", href: "", created: 54654, clf: "");}
    

    VocsyEpub.setConfig(
          //themeColor: Theme.of(context).primaryColor,
          identifier: "iosBook",
          scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
          allowSharing: true,
          enableTts: true,
          //nightMode: true,
    );

    VocsyEpub.locatorStream.listen((locator) async {
      //print('LOCATOR111-------------------------------------------------------: ${EpubLocator.fromJson(jsonDecode(locator))}');
      Map<String, dynamic> metabook = jsonDecode(locator);
      book = EpubBook(bookId: metabook['bookId'], href: metabook['href'], created: metabook['created'], clf: metabook['locations']['cfi']);
      
      await SessionManager().set("$bookid", book);   
      int timestamp = DateTime.now().millisecondsSinceEpoch;   
      await DatabaseHelper().updateBookDtime(bookid, timestamp);
      await deleteEpub(bookid);
      await Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => HomeScrenn()),
          );
    });

    VocsyEpub.open(
      book_Url,
      lastLocation: EpubLocator.fromJson({
        "bookId": book!.bookId,
        "href": book!.href,
        "created": book!.created,
        "locations": {
        "cfi": book!.clf
          }
        }), // first page will open up if the value is null
    );   

  }

  Future<void> deleteEpub(int book_id) async{

    String _dir = (await getApplicationDocumentsDirectory()).path;

    String book_url = "$_dir/$book_id.epub";
    if(await File(book_url).exists()==true)
    {
      await File(book_url).delete();
    }  
  }   

}