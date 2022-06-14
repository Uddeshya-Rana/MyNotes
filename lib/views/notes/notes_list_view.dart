import 'package:flutter/material.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

import '../../services/cloud_services/cloud_note.dart';

typedef NoteCallback = void Function(CloudNote note); //defining a callback function

class NotesListView extends StatelessWidget {

  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          final note = notes.elementAt(index);
          return ListTile(
            onTap: () {
              onTap(note); //calling our NoteCallBack function
              //navigate to notes_view on tap
              //in the notes_view get the onTap and navigate to the create or update note route
            },
            title: Text(
                note.text,
                maxLines: 1,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
            ),
            trailing: IconButton(
                onPressed: () async{
                  final shouldDelete = await showDeleteDialog(context);
                  if(shouldDelete) {
                    onDeleteNote(note); //onDelete is defined in constructor calling of NotesListView inside NotesView class
                  }
                },
                icon: const Icon(Icons.delete),
            ),
          );
        }
    );
  }
}
