import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAMcGK0n6KciVOzTrzH1OL4Fp94_Gkh1z4",
      authDomain: "songlist-3c748.firebaseapp.com",
      projectId: "songlist-3c748",
      storageBucket: "songlist-3c748.firebasestorage.app",
      messagingSenderId: "966871352059",
      appId: "1:966871352059:web:dc5d4600b3def4096b665e",
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Songs List App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SongsListScreen(),
    );
  }
}

class SongsListScreen extends StatefulWidget {
  const SongsListScreen({super.key});

  @override
  State<SongsListScreen> createState() => _SongsListScreenState();
}

class _SongsListScreenState extends State<SongsListScreen> {
  final CollectionReference songs = FirebaseFirestore.instance.collection(
    'songs',
  );
  List<Map<String, dynamic>> songsList = [];
  final TextEditingController songController = TextEditingController();
  @override
  void initState() {
    super.initState();
    fetchSongs();
  }

  Future<void> fetchSongs() async {
    QuerySnapshot snapshot = await songs.get();
    setState(() {
      songsList = snapshot.docs
          .map((doc) => {'id': doc.id, 'title': doc['title']})
          .toList();
    });
  }

  Future<void> addSong(String title) async {
    await songs.add({'title': title});
    fetchSongs(); // Refresh the list after adding
  }

  Future<void> deleteSong(String id) async {
    await songs.doc(id).delete();
    fetchSongs(); // Refresh the list after deletion
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Songs List')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: songController,
              decoration: InputDecoration(
                labelText: 'Enter Song Title',
                suffixIcon: IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    if (songController.text.isNotEmpty) {
                      addSong(songController.text);
                      songController
                          .clear(); // Clear the text field after adding
                    }
                  },
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: songsList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(songsList[index]['title']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      deleteSong(songsList[index]['id']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
