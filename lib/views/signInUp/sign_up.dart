import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_tracker/services/authentication.dart';

class SignUp extends StatefulWidget {

  final BaseAuth auth;
  final VoidCallback onSignedUp;
  @override
  _SignUpState createState() => _SignUpState();

  SignUp({this.auth, this.onSignedUp});
}

class _SignUpState extends State<SignUp> {
  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final formKey = new GlobalKey<FormState>();
  static String _email,_password,_firstName,_lastName;



  static var emailAddress=TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: "Enter a email address",
      labelText: "Email",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    validator: (value)=>isValidEmail(value) ? null : 'Please enter a valid email address',
    onSaved: (input)=>_email=input,
  );

  static bool isValidEmail(String input) {
    final RegExp regex = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");
    return regex.hasMatch(input);
  }

  static var password=TextFormField(
    keyboardType: TextInputType.emailAddress,
    autofocus: false,
    obscureText: true,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: "Enter assword",
      labelText: "Password",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    validator: (input)=>isValidPassword(input)?null:"Password lenght mus be 6 or more",
    onSaved: (input)=>_password=input,
  );

  static bool isValidPassword(String input){
    if(input.length<6 || input.trim().isEmpty)
      return false;
    return true;
  }

  static var firstName=TextFormField(
    keyboardType: TextInputType.text,
    autofocus: false,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: "Enter first name",
      labelText: "First Name",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    validator: (input)=>isValidPassword(input)?null:"First name is required",
    onSaved: (input)=>_firstName=input,
  );

  static bool isValidFirstName(String input){
    if(input.trim().isEmpty)
      return false;
    return true;
  }

  static var lastName=TextFormField(
    keyboardType: TextInputType.text,
    autofocus: false,
    maxLines: 1,
    decoration: InputDecoration(
      hintText: "Enter last name",
      labelText: "Last Name",
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
    ),
    validator: (input)=>isValidPassword(input)?null:"Last name is required",
    onSaved: (input)=>_lastName=input,
  );

  static bool isValidLasName(String input){
    if(input.trim().isEmpty)
      return false;
    return true;
  }

  static var logo=Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('assets/location.png'),
    ),
  );

  static var form=new Form(
    key:formKey,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        logo,
        SizedBox(height: 10.0,),
        firstName,
        SizedBox(height: 10.0,),
        lastName,
        SizedBox(height: 10.0,),
        emailAddress,
        SizedBox(height: 10.0,),
        password,
        SizedBox(height: 10.0,),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    return Container(
      child: form,
    );
  }
}
