import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

class JournalListPage extends StatefulWidget {
  @override
  _JournalListPageState createState() => _JournalListPageState();
}

class _JournalListPageState extends State<JournalListPage> {
  late Future<List<DocumentSnapshot>> _journalEntries;

  @override
  void initState() {
    super.initState();
    _journalEntries = _fetchJournalEntries();
  }

  Future<List<DocumentSnapshot>> _fetchJournalEntries() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('journals')
          .orderBy('timestamp', descending: true)
          .get();
      return querySnapshot.docs;
    } else {
      // No user signed in
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
              'Journal Entries',
            style: GoogleFonts.eczar(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: FutureBuilder(
        future: _journalEntries,
        builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            List<DocumentSnapshot> entries = snapshot.data ?? [];
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                // Access each journal entry data
                Map<String, dynamic> data = entries[index].data() as Map<String, dynamic>;
                String rose = data['rose'];
                String thorn = data['thorn'];
                String bud = data['bud'];
                Timestamp timestamp = data['timestamp'];

                // Format timestamp
                DateTime dateTime = timestamp.toDate();
                String formattedDate = '${dateTime.year}-${dateTime.month}-${dateTime.day}';

                // Build ListTile for each journal entry
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JournalDetailPage(
                          formattedDate: formattedDate,
                          rose: rose,
                          thorn: thorn,
                          bud: bud,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                      tileColor: Colors.white10,
                      title: Text(
                        'Date: $formattedDate',
                        style: TextStyle(
                          fontSize: 18, // Adjust the font size as needed
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 5), // Add spacing between texts
                          Text(
                            'Rose: $rose',
                            style: TextStyle(
                              fontSize: 16, // Adjust the font size as needed
                            ),
                          ),
                          Text(
                            'Thorn: $thorn',
                            style: TextStyle(
                              fontSize: 16, // Adjust the font size as needed
                            ),
                          ),
                          Text(
                            'Bud: $bud',
                            style: TextStyle(
                              fontSize: 16, // Adjust the font size as needed
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

class JournalDetailPage extends StatelessWidget {
  final String formattedDate;
  final String rose;
  final String thorn;
  final String bud;

  const JournalDetailPage({
    Key? key,
    required this.formattedDate,
    required this.rose,
    required this.thorn,
    required this.bud,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Journal Entry - $formattedDate',
            style: GoogleFonts.eczar(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(
                  color: Colors.red,
                  width: 2.0,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5.0,
                    offset: Offset(2,2)
                  )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Rose: $rose',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.brown,
                  width: 2.0,
                ),
                  boxShadow: const [
                    BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5.0,
                        offset: Offset(2,2)
                    )
                  ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Thorn: $thorn',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.brown,
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.green,
                  width: 2.0,
                ),
                  boxShadow: [
                  BoxShadow(
                  color: Colors.black26,
                  blurRadius: 5.0,
                  offset: Offset(2,2)
              )
                ]
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Bud: $bud',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.lora(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.green,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
