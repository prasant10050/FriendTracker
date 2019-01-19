import 'dart:async';
import 'package:friend_tracker/Model/User.dart';


class UserBloc {
  User user;

  StreamController<User> userController = StreamController<User>();

  StreamSink<User> get inUser => userController.sink;

  Stream<User> get outUser => userController.stream;


  UserBloc(){
    user=new User();
    userController.stream.listen(handleUser);
  }

  void handleUser(User user) {
    inUser.add(user);
  }

  void dispose() {
    userController.close();
  }
}
