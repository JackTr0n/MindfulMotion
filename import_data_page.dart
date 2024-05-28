import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    title: 'Motivation of the Day',
    home: ImportDataPage(randomQuote: "Your random quote goes here."),
  ));
}

class ImportDataPage extends StatelessWidget {
  final String randomQuote;

  const ImportDataPage({Key? key, required this.randomQuote}) : super(key: key);

  Future<String> _getImageUrl() async {
    // Replace with your actual gs:// path
    String gsPath = 'gs://second-3688c.appspot.com/Aristotle.jpg';

    // Extract the file name and the folder structure from the gsPath
    String filePath = gsPath.replaceFirst('gs://second-3688c.appspot.com/', '');

    // Get the download URL from Firebase Storage
    String downloadURL = await FirebaseStorage.instance.ref(filePath).getDownloadURL();
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
            return Stack(
              children: [
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Image.network(
                    snapshot.data!,
                    width: 200,
                    height: 300,
                    fit: BoxFit.cover,
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(20),
                      child: Text(
                        randomQuote,
                        textAlign: TextAlign.center,
                        style: GoogleFonts.fraunces(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
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
