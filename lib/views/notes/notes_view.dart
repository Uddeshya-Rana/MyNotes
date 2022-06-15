
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth_service.dart';
import 'package:mynotes/services/cloud_services/cloud_note.dart';
import 'package:mynotes/services/cloud_services/firebase_cloud_storage_service.dart';
import 'package:mynotes/views/notes/notes_list_view.dart';

import '../../constants/routes.dart';
import '../../enums/menu_action.dart';
import '../../utilities/dialogs/logout_dialog.dart';



class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {

  late final FirebaseCloudStorageService _notesService;
  String? get userId => AuthService.firebase().currentUser?.userId;

  @override
  void initState(){
    _notesService = FirebaseCloudStorageService();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Notes'),
        actions: [
          IconButton(
            //Navigates to create or update if plus icon is tapped
              onPressed: (){
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add)
          ),
          PopupMenuButton<MenuActionItems>(
              onSelected: (value) async {
                switch(value)
                {

                  case MenuActionItems.logout:
                    final shouldLogOut= await showLogOutDialog(context);
                    if(shouldLogOut)
                    {
                      await AuthService.firebase().logOut();
                      Navigator.of(context).pushNamedAndRemoveUntil(loginRoute, (route) => false);
                    }
                    break;
                }
              },
              itemBuilder: (context) =>[
                const PopupMenuItem<MenuActionItems>(
                  value: MenuActionItems.logout,
                  child: Text('Log Out'),
                )
              ] //itemBuilder
          ),

        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId!), //to get all notes inside stream
        builder: (context, snapshot){

          switch (snapshot.connectionState) {

            case ConnectionState.waiting:
            case ConnectionState.active:
              if(snapshot.hasData) {
                    final allNotes = snapshot.data as Iterable<CloudNote>;
                    //calls constructor of NotesListView
                    //returns the NotesViewList ListView widget
                    return NotesListView(
                        notes: allNotes,
                        onDeleteNote: (note) async{
                          await _notesService.deleteNote(documentId: note.documentId);
                        },
                        onTap: (note) {
                          Navigator.of(context).pushNamed(
                            createOrUpdateNoteRoute,
                            arguments: note,
                          );
                        },
                    );
                  } //if snap shot has data
              else{
                return const CircularProgressIndicator();
              }
            default: return const CircularProgressIndicator();
          } //switch

        } //builder

      )
    );
  }
}


