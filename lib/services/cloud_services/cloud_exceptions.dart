
class CloudException implements Exception{
  const CloudException();
}

//create  -C
class CouldNotCreateNoteException extends CloudException{}
//read    -R
class CouldNotGetAllNotesException extends CloudException{}
//update  -U
class CouldNotUpdateNoteException extends CloudException{}
//delete  -D
class CouldNotDeleteNoteException extends CloudException{}





