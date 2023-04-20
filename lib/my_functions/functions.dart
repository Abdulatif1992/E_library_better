import 'package:vocsy_epub_viewer/epub_viewer.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'dart:convert'; // it for jsonDecode
import 'package:google_fonts/google_fonts.dart';

//my files
import 'package:flutter_one_epub/models/book.dart';

openEpub(int bookid) async {
  EpubBook? book;
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

    VocsyEpub.locatorStream.listen((locator) {
      //print('LOCATOR111-------------------------------------------------------: ${EpubLocator.fromJson(jsonDecode(locator))}');
      Map<String, dynamic> metabook = jsonDecode(locator);
      book = EpubBook(bookId: metabook['bookId'], href: metabook['href'], created: metabook['created'], clf: metabook['locations']['cfi']);
      SessionManager().set("$bookid", book);      
    });

    await VocsyEpub.openAsset('assets/book/javascript.epub',
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