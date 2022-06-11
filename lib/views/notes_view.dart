
import 'package:flutter/material.dart';
import 'package:mynotes/services/auth_service.dart';

import '../constants/routes.dart';
import '../enums/menu_action.dart';


class NotesView extends StatefulWidget {
  const NotesView({Key? key}) : super(key: key);

  @override
  State<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main UI'),
        actions: [
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
      body: const Text('Welcome'),
    );
  }
}

Future<bool> showLogOutDialog(BuildContext context){
  return showDialog<bool>(
      context: context,
      builder: (context){
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(onPressed: (){
              Navigator.of(context).pop(false);
            },
                child: const Text('Cancel')
            ),
            TextButton(onPressed: (){
              Navigator.of(context).pop(true); //pops this screen
            },
                child: const Text('Log Out')
            ),
          ],
        );
      }
  ).then((value) => value?? false);

}
