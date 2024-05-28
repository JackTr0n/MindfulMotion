import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart'; // for Firebase Authentication
import 'package:firebase_storage/firebase_storage.dart';
class JournalEntry{
  String rose;
  String thorn;
  String bud;

  JournalEntry({required this.rose, required this.thorn, required this.bud});
}

class JournalPage extends StatefulWidget{
  @override
  _JournalPageState createState() => _JournalPageState();
}


class _JournalPageState extends State<JournalPage>{
  final TextEditingController _roseController = TextEditingController();
  final TextEditingController _thornController = TextEditingController();
  final TextEditingController _budController = TextEditingController();

  void _saveJournal() async {
    String rose = _roseController.text;
    String thorn = _thornController.text;
    String bud = _budController.text;

    if (rose.isNotEmpty && thorn.isNotEmpty && bud.isNotEmpty) {
      try {
        User? user = FirebaseAuth.instance.currentUser;
        if(user != null){
          String userId = user.uid;
          await FirebaseFirestore.instance.collection('users').doc(userId).collection('journals').add({
            'rose': rose,
            'thorn': thorn,
            'bud': bud,
            'timestamp': Timestamp.now(),
          });
        }
        // Clear text fields after saving
        _roseController.clear();
        _thornController.clear();
        _budController.clear();

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Journal saved successfully!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save journal. Please try again.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please fill in all fields.')),
      );
    }
  }

  Future<String> _getImageUrl() async {
    // Fetch the image URL from Firebase Storage
    // Replace 'path_to_your_image' with your actual image path in Firebase Storage
    String gsPath = 'gs://second-3688c.appspot.com/RoseThornBud.jpg';
    String imagePath = gsPath.replaceFirst('gs://second-3688c.appspot.com/', '');
    String downloadURL = await FirebaseStorage.instance.ref(imagePath).getDownloadURL();
    return downloadURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: _getImageUrl(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error loading image'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('No image available'));
          } else {
            return Column(
              children: [
                // Image with curved and shadowed bottom
                Container(
                  width: double.infinity,
                  height: 240, // Adjust height as needed
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(45),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10.0,
                        spreadRadius: 2.0,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextField(
                          controller: _roseController,
                          decoration: InputDecoration(
                            labelText: 'Rose - a highlight or small win from the day',
                            labelStyle: GoogleFonts.cormorant(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.red,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        TextField(
                          controller: _thornController,
                          decoration: InputDecoration(
                            labelText: 'Thorn - a challenge you experienced',
                            labelStyle: GoogleFonts.cormorant(
                              color: Colors.brown,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.brown,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        TextField(
                          controller: _budController,
                          decoration: InputDecoration(
                            labelText: 'Bud - new ideas that have bloomed',
                            labelStyle: GoogleFonts.cormorant(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              borderSide: BorderSide(
                                color: Colors.green,
                                width: 2.0,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 30.0),
                        ElevatedButton(
                          onPressed: _saveJournal,
                          child: Text(
                            'Save Journal',
                            style: GoogleFonts.lato(
                              textStyle: TextStyle(color: Colors.black),
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                            foregroundColor: MaterialStateProperty.all<Color>(Colors.black),
                            overlayColor: MaterialStateProperty.all<Color>(Colors.black12),
                            padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                            ),
                            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30), // Button border radius
                                side: BorderSide.none, // No border
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(
    title: 'Rose, Thorn, Bud Journal',
    home: JournalPage(),
  ));
}