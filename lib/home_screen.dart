import 'package:flutter/material.dart';
//import 'package:vocsy_epub_viewer/epub_viewer.dart';

//my files
import 'package:flutter_one_epub/my_functions/functions.dart';

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
      title: 'epub reader',
        home: Scaffold(
          appBar: AppBar(title: const Text('buyam epub')),
        body: Center(child: Column(children: [ElevatedButton(onPressed: () {openEpub(1115);}, child:const Text('Open Online E-pub'),)],)),              
        ),
      );
  }
}
