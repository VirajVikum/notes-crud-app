import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crud_app/services/firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  final FirestoreService firestoreService = FirestoreService();

// text controller
final TextEditingController textController = TextEditingController();

  // open a dialog box to add note
  void openNoteBox() {
    showDialog(
      context: context,
     builder: (context)=> AlertDialog(
      content: TextField(
        controller: textController,
      ),
      actions: [
        // save button
        ElevatedButton(
          onPressed: () {
            // add a new note
            firestoreService.addNote(textController.text);

            // clear the note
            textController.clear();

            // close the box
            Navigator.pop(context);
          },
          child: Text("Add")
          )
     
     
      ],
    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Notes")),
      floatingActionButton: FloatingActionButton(onPressed: openNoteBox,
      child: const Icon(Icons.add),),
      body: StreamBuilder<QuerySnapshot>(
        stream: firestoreService.getNotesStream(),
        builder: (context, snapshot) {
          // if have data get all
          if (snapshot.hasData){
          List noteList = snapshot.data!.docs;

          // Display as a list
          return ListView.builder(
            itemCount: noteList.length,
            itemBuilder: (context, index){
            // get each individual doc
            DocumentSnapshot document = noteList[index];
            String docID = document.id;

            // get note from each doc
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            String noteText = data['note'];

            // display as a list tile

            return ListTile(
              title: Text(noteText),
            );

          },
          );
        }
        

        else {
          return const Text("No notes..");
        }
        },
      ),
    );
  }
}