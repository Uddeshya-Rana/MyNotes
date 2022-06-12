//TODO- necessary imports
import 'db_exceptions.dart';

//TODO- construct DB path



//TODO- define constants with same field name/column name as those in database

//create the user table IF NOT EXIST

const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
                              "id"	INTEGER NOT NULL,
                              "email"	TEXT NOT NULL UNIQUE,
                              PRIMARY KEY("id" AUTOINCREMENT)
                            );''' ;
//create the Notes table IF NOT EXIST
const createNotesTable= '''CREATE TABLE IF NOT EXISTS "notes" (
                              "id"	INTEGER NOT NULL,
                              "user_id"	INTEGER NOT NULL,
                              "text"	TEXT,
                              "is_synced_with_cloud"	INTEGER NOT NULL,
                              PRIMARY KEY("id" AUTOINCREMENT)
                            );''' ;

//to store names of database and tables
const dbName='notes.db';
const noteTable= 'note';
const userTable= 'user';

//for User table
const idColumn = 'id';
const emailColumn = 'email';
//for Notes table
const userIdColumn= 'user_id';
const textColumn= 'text';
const isSyncedWithCloudColumn= 'is_synced_with_cloud';

//TODO: Make a NotesService class to connect to the Database

/*
class NoteService {

 List<DatabaseNote> _notes = []; //creating a list stream

//creating a stream controller
 final _notesStreamController = StreamController<List<DatabaseNote>>.broadcast();

 Future<void> _cacheNotes() async{
  _notes = await getAllNotes().toList();
  _notesStreamController.add(_notes); //adding stream to our stream controller
 }

  Database? _db; //create a database object

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) {
      throw DatabaseIsNotOpen();
    } else {
      return db;
    }
  }

  //to create notes
  Future<DatabaseUser> createNote({required DatabaseUser}) async {
    final db = _getDatabaseOrThrow();

    //make sure owner exists in the database
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) {
      throw CouldNotFindUser();
    }
    //create the note
    const text = '';
    final noteId = await db.insert(noteTable{
    userIdColumn: owner.id,
    textColumn: Text,
    isSyncedWithCloudColumn: 1
    });

    final note = DatabaseNote(noteId, owner.id, text, isSyncedWithCloud);

    _notes.add(note); // add freshly created note to our stream
    return note;
  }

  //deleting note

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteNote();
    }else{
    _notes.removeWhere((note)=> note.id == id);
    _notesStreamController.add(_notes);
    }
  }

  //Delete all the notes
  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return await db.delete(noteTable);
    _notes=[];
    _notesStreamController.add(_notes);
  }

  //Fetching a specific note
  Future<DatabaseNote> getNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      limit: 1,
      where: 'id =?',
      whereArgs: [id],
    );
    if (notes.isEmpty) {
      throw CouldNotFindNote();
    } else {
      final note = DatabaseNote.fromRow(notes.first);
      //remove existing note with same id and fetch
      _notes.removeWhere((note)=> note.id ==id );
      _notes.add(note);
      _notesStreamController.add(_notes);
      return note;
    }
  }

  //fetching all notes

  Future<Iterable<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow));
  }

  //Update note
  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    final db = _getDatabaseOrThrow();

    //make sure note exists
    await getNote(id: note.id);

    db.update(noteTable, {
      textColumn: text,
      isSyncedWithCloudColumn: 0,
    });

    if (updatesCount == 0) {
      throw CouldNotUpdateNote();
    } else {
      final updatedNote= await getNote(id: note.id);
       _notes.removeWhere((updatedNote)=> note.id ==id );
      _notes.add(updatedNote);
      _notesStreamController.add(_notes);
      return updatedNote;
    }
  }

  //CLOSING OUR DATABASE
  Future<void> close() async {
    if (_db == null) {
      throw DatabaseIsNotOpen();
    } else {
      await db.close();
    }
  }

  //opening our database
  Future<void> open() async {
    if (_db != null) {
      throw DatabaseAlreadyOpenException();
    }
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      _db = await openDatabase(dbPath);
      //openDatabase will also create a database if it doesn't already exist

      await _db.execute(createUserTable);

      await _db.execute(createNotesTable);

      await _cacheNotes(); //calling the cache function to start our stream
    }
    on MissingPlatformDirectoryException() {
      throw UnableToGetDocumentDirectory();
    }
  }


  //delete user from database

  Future<void> deleteUSer({required String email}) async {
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email =?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) {
      throw CouldNotDeleteUser();
    }
  }

  //add user from database/ create user

  Future<void> createUSer({required String email}) async {
    final db = _getDatabaseOrThrow();
    //first of all check whether the user already exists
    final results = await db.query(
        userTable,
        limit: 1,
        where: 'email =?'
        whereArgs: [email.toLowerCase()],
    );
    if(results.isNotEmpty){
    throw UserAlreadyExists();
    }
    //if the user doesn't exist, create new user
    final userId= db.insert(userTable,{
    emailColumn: email.toLowerCase(),
    });
    return DatabaseUser(
    id: userId,
    email:
    email
    ,
    )
  }


  //fetch user from database

  Future<void> getUSer({required String email}) async {
    final db = _getDatabaseOrThrow();

    final results = await db.query(
        userTable,
        limit: 1,
        where: 'email =?'
        whereArgs: [email.toLowerCase()],
    );

    if(results.isEmpty){
    throw CouldNotFindUser();
    }else{
    return Database.fromRow(results.first);
    }


  }
//TODO- MAKE DataBaseUser class

}

 */

class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  //create a map to make a key(Strings) and value(objects-int,String,etc) pair which corresponds to the user table in database
  //this map passes value to the constructor of this class
  DatabaseUser.fromRow(Map<String, Object?> map)
      :
        id= map[idColumn] as int,
        email= map[emailColumn] as String;

//TODO- override toString method to return a database query

  @override
  String toString() => 'Person, ID = $id, email = $email';

  //TODO- do operator overloading of '==' operator using covariant which does not change the meaning of original operator
  @override
  bool operator ==(covariant DatabaseUser other) => id ==other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;


}

//TODO: make a database Note class and map it similar to databaseUser class

class DatabaseNote{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;
  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud
  });

  DatabaseNote.fromRow(Map<String, Object?> map)
  : id =map[idColumn] as int,
    userId = map[userIdColumn] as int,
    text= map[textColumn] as String,
    isSyncedWithCloud = (map[isSyncedWithCloudColumn] as int) ==1 ? true: false;

  @override
  String toString()=> 'Note, ID = $id, userId= $userId, isSyncedWithCloud = $isSyncedWithCloud';

  @override
  bool operator ==(covariant DatabaseNote other) => id ==other.id;

  @override
  int get hashCode => id.hashCode;
}