import 'package:flutter/material.dart';
import 'package:flutter_one_epub/authentication/login_page.dart';
import 'package:flutter_one_epub/home_screen.dart';
import 'dart:convert';

import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

//my files
import 'package:flutter_one_epub/utils/database_helper.dart';
import 'package:flutter_one_epub/models/book_from_sql.dart';
import 'package:flutter_one_epub/epubreader_screen.dart';
import 'package:flutter_one_epub/constants/constants.dart';

// animated icon
import 'package:animated_icon/animated_icon.dart';

// get
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';



class DetailScreen extends StatefulWidget {
  const DetailScreen({super.key, required this.book});

  final BookFromSql book;

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  DatabaseHelper databaseHelper = DatabaseHelper();

  bool isDownloadStarted = false;
  bool isDownloadFinish = false;

  final box = GetStorage();  

  @override
  void initState(){
    _checkDownload(widget.book.book_id);
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
               elevation: 0.0,
        leading: _appBarBack(),
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Center(
          child: Column(
            children: [
              Row(
                children: [
                  Center(
                    child: Image.memory(
                        base64Decode('${widget.book.base64}'),
                        height: 200.0,
                        width: 160.0,   
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 5.0),
                    width: screenWidth-200.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.book.book_name, 
                        style: const TextStyle(fontSize: 22, color: Colors.blueGrey),),
                        Visibility(
                          visible: !isDownloadFinish,
                          child: _visible()
                        ),
                        Visibility(
                          visible: isDownloadFinish,
                          child: ElevatedButton(onPressed: () {
                            Navigator.push(
                                context, 
                                MaterialPageRoute(builder: (context) => EpubReaderScreen(book_id: widget.book.book_id)),
                              );                            
                            }, child: const Text("     Open   "),
                          ),
                        ),                                 
                      ],
                    ),
                  ),
                ],
              ),              
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 20.0),
                    child: const Text("Book Description",
                      style: TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 22,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  const Divider(color: Colors.black),
                  Container(height: screenHeight*0.5, 
                  child: Text("${widget.book.book_title}",
                    style: const TextStyle(fontSize: 16),
                  ),),
                  
                ],
              ),
            ],
          ),
        ),
      ), 
    );
  }

  Widget _visible(){
    if(isDownloadStarted){
      return AnimateIcon(
          key: UniqueKey(),
          onTap: () {},
          iconType: IconType.continueAnimation,
          height: 70,
          width: 70,                                   
          animateIcon: AnimateIcons.iPhoneSpinner,
          color: Colors.blue,
      );
    }
    else{
      return ElevatedButton(onPressed: () {_download(widget.book.book_id);}, child: Text("Download"));
    }
  }

  Widget _appBarBack(){
    if(isDownloadFinish){
      return IconButton(
        onPressed: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => const HomeScrenn()),
          );
        },
        icon: const Icon(Icons.arrow_back, color: Colors.blue,),
      );
    }
    else{
      return IconButton(
          onPressed: () {
            Navigator.pop(
              context, 
              MaterialPageRoute(builder: (context) => const HomeScrenn()),
            );
          },
          icon: const Icon(Icons.arrow_back, color: Colors.blue,),
        );
    }
  }

  Future<void> _download(int bookId) async {

    setState(() {
        isDownloadFinish = false;
        isDownloadStarted = true;        
      });  
    
    String filePath = await downloadFile(
        '${siteUrl}download/$bookId', '$bookId.zip');

    if(filePath=='Unauthenticated')
    {
      Get.to(() => const LoginPage());
    }
    else if(filePath=='Error')
    {
      print('something is wrong please try again');
    }
    else if(filePath=='This is a paid book')
    {
      Get.snackbar(
          'Error',
          'This is a paid book',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isDownloadFinish = false;
        setState(() {
          isDownloadFinish = isDownloadFinish;
        });
      //print('This is a paid book');

    }
    else{
      await updateDb(bookId);
      await _checkDownload(bookId);
      print('Fayl yuklandi: $filePath');
    }

    
    
  }

  Future<String> downloadFile(String url, String filename) async {   
    final token = box.read('token');

    var request = await http.get(
      Uri.parse(url), 
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        }
      );
    // print(request.statusCode);
    // print(token);
    if(request.statusCode==200)
    {
      var bytes = request.bodyBytes;
      var dir = await getApplicationDocumentsDirectory();
      File file = File('${dir.path}/$filename');
      await file.writeAsBytes(bytes);
      return file.path;
    }
    else{
      if(json.decode(request.body)['message']=='Unauthenticated.') {return 'Unauthenticated';}
      else if(json.decode(request.body)['message']=='This is a paid book'){return 'This is a paid book';}
      else {return 'Error';}
    }
    
  }

  Future<void> updateDb(int book_id) async{
    String _dir = (await getApplicationDocumentsDirectory()).path;

    String book_url = "$_dir/$book_id.zip";
    if(await File(book_url).exists()==true)
    {
      int timestamp = DateTime.now().millisecondsSinceEpoch;
      await databaseHelper.updateBookUpd(book_id);
      await databaseHelper.updateBookDtime(book_id, timestamp);
    }
    else{}
  }

  Future<void> _checkDownload(int book_id) async{
    String _dir = (await getApplicationDocumentsDirectory()).path;

    String book_url = "$_dir/$book_id.zip";

    if(widget.book.upd==1){
      isDownloadFinish = true;
      setState(() {
        isDownloadFinish = isDownloadFinish;
      });
    }
    else if(await File(book_url).exists()==true){
      isDownloadFinish = true;
        setState(() {
          isDownloadFinish = isDownloadFinish;
          isDownloadStarted = false;
        });

      
    }
  }

  
}