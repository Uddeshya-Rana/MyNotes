import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud_services/cloud_note.dart';
import 'package:mynotes/services/cloud_services/firebase_cloud_storage_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:share_plus/share_plus.dart';

import '../../services/auth_service.dart';
import '../../utilities/dialogs/cannot_share_empty_note_dialog.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({Key? key}) : super(key: key);

  @override
  CreateUpdateNoteViewState createState() => CreateUpdateNoteViewState();
}

class CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {

  CloudNote? _note; //instance of cloud note

  late final FirebaseCloudStorageService _notesService;
  late final TextEditingController _textController;

  @override
  void initState(){
    _notesService= FirebaseCloudStorageService();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async{
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: note.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  //CREATE OR GET EXISTING NOTE
  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    //to get note in our widget as argument
    final widgetNote = context.getArgument<CloudNote>();

    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }

    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentUser!;
    final userId = currentUser.userId;
    final newNote = await _notesService.createNewNote(ownerUserId: userId!);
    _note = newNote;
    return newNote;
  }
  //DELETE NOTE IF TEXT IS EMPTY
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }
 //SAVE NOTE WHEN THERE IS SOME TEXT
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: note.documentId,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

   return Scaffold(
     appBar: AppBar(
       title: const Text('My Notes'),
       actions: [
         //Share Button
         IconButton(
             onPressed: () async {
               final text = _textController.text;
               if (_note == null || text.isEmpty){
                 await showCannotShareEmptyNoteDialog(context);
               }else{
                 Share.share(text);
               }
             },
             icon: const Icon(Icons.share),
         )
       ],
     ),
     body: FutureBuilder(
       future: createOrGetExistingNote(context),
       builder: (context,snapshot){
         switch (snapshot.connectionState){
           case ConnectionState.done:
             _setupTextControllerListener();
             return TextField(
               controller: _textController,
               keyboardType: TextInputType.multiline,
               maxLines: null,
             );
           default: return const CircularProgressIndicator();
         } //switch
       } //builder
     )
   );

  } //Widget build
} //CreateViewNotesViewState
