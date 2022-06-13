
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud_services/cloud_exceptions.dart';
import 'package:mynotes/services/cloud_services/cloud_note.dart';
import 'package:mynotes/services/cloud_services/cloud_storage_constants.dart';

class FirebaseCloudStorageService {
  //singleton **
  //static final talks with private constructor
  static final FirebaseCloudStorageService _shared = FirebaseCloudStorageService
      ._sharedInstance();

  //private constructor
  FirebaseCloudStorageService._sharedInstance();

  //factory constructor talks with static final
  factory FirebaseCloudStorageService() => _shared;

  //**singleton

  //Grabbing all notes from cloud storage on firebase
  final notes = FirebaseFirestore.instance.collection(
      'notes'); //this returns a stream of notes

  //creating new notes
  void createNote({required String ownerUserId}) async {
    //Adding new note to the stream of notes
    notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
    });
  }

  //getting notes by ID
  Future<Iterable<CloudNote>> getNotes({required String ownerUserId}) async {
    try {
      return await notes.where(
          ownerUserIdFieldName,
          isEqualTo: ownerUserId
      ).get().then((value) =>
          value.docs.map(
                  (doc) =>
                  CloudNote(
                    documentId: doc.id,
                    ownerUserId: doc.data()[ownerUserIdFieldName] as String,
                    text: doc.data()[textFieldName] as String,
                  )
          ) //map
      ); //then

    } catch (e) {
      throw CouldNotGetAllNotesException();
    }
  } //getNotes

  //grabbing stream of all notes of a specific user
  Stream<Iterable<CloudNote>> allNotes({required String ownerUserId}) =>
      notes.snapshots().map((event) =>
          event.docs.map((doc) =>
              CloudNote.fromSnapshot(doc)).where((note) =>
          note.ownerUserId == ownerUserId));


  //Updating existing notes
  Future<void> updateNote({required String documentId, required String text,}) async {
    try {
      await notes.doc(documentId).update({textFieldName: text});
    } catch (e) {
      throw CouldNotUpdateNoteException();
    }
  }

  //Delete Notes
  Future<void> deleteNote({required String documentId}) async{
    try{
      await notes.doc(documentId).delete();
    }catch(e)
    {
      throw CouldNotDeleteNoteException();
    }

  }


}















