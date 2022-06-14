
import 'package:flutter/material.dart';

Future<bool> showDeleteDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to Delete the note?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            },
                child: const Text('Cancel')
            ),
            TextButton(onPressed: (){
              Navigator.of(context).pop(true); //pops this screen
            },
                child: const Text('Delete')
            ),
          ],
        );
      }
  ).then((value) => value?? false);

}