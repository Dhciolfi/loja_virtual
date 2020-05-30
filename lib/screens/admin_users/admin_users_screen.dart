import 'package:alphabet_list_scroll_view/alphabet_list_scroll_view.dart';
import 'package:flutter/material.dart';
import 'package:lojavirtual/models/admin_users_manager.dart';
import 'package:provider/provider.dart';

class AdminUsersScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
      ),
      body: Consumer<AdminUsersManager>(
        builder: (_, adminUsersManager, __){
          return AlphabetListScrollView(
            itemBuilder: (_, index){
              return ListTile(
                title: Text(
                  adminUsersManager.users[index].name,
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: Colors.white
                  ),
                ),
                subtitle: Text(
                  adminUsersManager.users[index].email,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              );
            },
            highlightTextStyle: TextStyle(
              color: Colors.white,
              fontSize: 20
            ),
            indexedHeight: (index) => 80,
            strList: adminUsersManager.names,
            showPreview: true,
          );
        },
      ),
    );
  }
}
