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
  const EpubReaderScreen({super.key, required this.bookId});

  final int bookId;

  @override
  State<EpubReaderScreen> createState() => _EpubReaderScreenState();
}

class _EpubReaderScreenState extends State<EpubReaderScreen> {
  @override
  void initState(){   
    unzipEpub(widget.bookId);
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
    String dir = (await getApplicationDocumentsDirectory()).path;

    String bookUrl = "$dir/$bookid.zip";
    if(await File(bookUrl).exists()==true)
    {
      // Read the Zip file from disk.
      var bytes = File("$dir/$bookid.zip").readAsBytesSync();

      // Decode the Zip file
      final archive = ZipDecoder().decodeBytes(
        bytes,
        verify: true,
        password: "sazagan_92",
        );

      // Extract the contents of the Zip archive to disk.
      String extention = "";
      String pdfUrl = "";
      for (var file in archive) {
        String fullName = file.name;
        extention = fullName.substring(fullName.indexOf('.'));

        var fileName = '$dir/$bookid$extention';
        pdfUrl = fileName;
        if (file.isFile) {
          var outFile = File(fileName);
          //print('File::' + outFile.path);
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
          MaterialPageRoute(builder: (context) => PdfReaderScreen(bookId: bookid, pdfUrl: pdfUrl)),
          
        );
      }
      
    }
    else{
      //print("zip file is not exist");
    }
  }

  openEpub(int bookid) async {
    EpubBook? book;
    String dir = (await getApplicationDocumentsDirectory()).path;
    String bookUrl = "$dir/$bookid.epub";
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
            MaterialPageRoute(builder: (context) => const HomeScrenn()),
          );
    });

    VocsyEpub.open(
      bookUrl,
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

  Future<void> deleteEpub(int bookId) async{

    String dir = (await getApplicationDocumentsDirectory()).path;

    String bookUrl = "$dir/$bookId.epub";
    if(await File(bookUrl).exists()==true)
    {
      await File(bookUrl).delete();
    }  
  }   

}