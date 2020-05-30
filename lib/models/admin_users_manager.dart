import 'package:faker/faker.dart';
import 'package:flutter/cupertino.dart';
import 'package:lojavirtual/models/user.dart';
import 'package:lojavirtual/models/user_manager.dart';

class AdminUsersManager extends ChangeNotifier{

  List<User> users = [];

  void updateUser(UserManager userManager){
    if(userManager.adminEnabled){
      _listenToUsers();
    }
  }

  void _listenToUsers(){
    const faker = Faker();

    for(int i = 0; i < 1000; i++){
      users.add(User(
        name: faker.person.name(),
        email: faker.internet.email()
      ));
    }

    users.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));

    notifyListeners();
  }

  List<String> get names => users.map((e) => e.name).toList();

}