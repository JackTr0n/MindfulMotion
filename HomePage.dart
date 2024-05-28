import 'package:flutter/material.dart';
import 'journal_screen.dart';
import 'import_data_page.dart';
import 'journal_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:convert';
import 'dart:math';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget{
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>{
  @override
  int _selectedIndex = 0;
  final PageController _pageController = PageController();
  String randomQuote = '';

  @override
  void initState(){
    super.initState();
    importData();
  }

  @override
  void dispose(){
    _pageController.dispose();
    super.dispose();
  }


  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> importData() async{
      final Reference storageReference = FirebaseStorage.instance.refFromURL('https://firebasestorage.googleapis.com/v0/b/second-3688c.appspot.com/o/quotes.json?alt=media&token=cd502ff9-9800-45f7-a576-501a745a6ba8');
      final fileData = await storageReference.getData();
      print(fileData);
      if(fileData != null) {
        String jsonString = utf8.decode(fileData);
        List<dynamic> jsonData = json.decode(jsonString)['quotes'];

        Random random = Random();
        int randomIndex = random.nextInt(jsonData.length);
        Map<String, dynamic> randomQuoteData = jsonData[randomIndex];

        setState(() {
          randomQuote = '"${randomQuoteData['quote']}" - ${randomQuoteData['author']}';
        });
      } else {
        setState(() {
          randomQuote = 'Failed to fetch file data';
        });
      }
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index){
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          ImportDataPage(randomQuote: randomQuote),
          JournalPage(),
          JournalListPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.format_quote, color: Colors.black,), label: 'Quotes'),
          BottomNavigationBarItem(icon: Icon(Icons.edit, color: Colors.black,), label: 'Journal'),
          BottomNavigationBarItem(icon: Icon(Icons.menu_book, color: Colors.black,), label: 'Journal List'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}