import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:friend_tracker/services/authentication.dart';

class SignIn extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  SignIn({this.auth, this.onSignedIn});

  @override
  _SignInState createState() => _SignInState();
}

enum FormMode { LOGIN, SIGNUP }

class _SignInState extends State<SignIn> {
  //ScaffoldKey and FormKEy
  static final scaffoldKey = new GlobalKey<ScaffoldState>();
  static final formKey = new GlobalKey<FormState>();

  //variable
  static String _email,_password;
  FormMode _formMode = FormMode.LOGIN;
  bool _isIos;
  bool _isLoading;
  String _errorMessage;

  //TextEditingController
  static TextEditingController emailTextController=new TextEditingController();
  static TextEditingController passwordTextController=new TextEditingController();

  // Check if form is valid before perform login or signup
  bool _validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  _validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (_validateAndSave()) {
      String userId = "";
      try {
        if (_formMode == FormMode.LOGIN) {
          userId = await widget.auth.signIn(_email, _password);
          print('Signed in: $userId');
        } else {
          //userId = await widget.auth.signUp(_email, _password);
          //print('Signed up user: $userId');
        }
        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.onSignedIn();
        }

      } catch (e) {
        print('Error: $e');
        setState(() {
          _isLoading = false;
          if (_isIos) {
            _errorMessage = e.details;
          } else
            _errorMessage = e.message;
        });
      }
    }
  }

  void _changeFormToSignUp() {
    formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.SIGNUP;
    });
  }

  void _changeFormToLogin() {
    formKey.currentState.reset();
    _errorMessage = "";
    setState(() {
      _formMode = FormMode.LOGIN;
    });
  }


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
    controller: emailTextController,
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
    controller: passwordTextController,
  );

  static bool isValidPassword(String input){
    if(input.length<6 || input.trim().isEmpty)
      return false;
    return true;
  }

  static var logo=Hero(
    tag: 'hero',
    child: CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 48.0,
      child: Image.asset('assets/location4.jpg',height: MediaQuery.of(_context).size.height*.5,width: MediaQuery.of(_context).size.width*.5,),
    ),
  );

  Widget _showSecondaryButton() {
    return new FlatButton(
      child: _formMode == FormMode.LOGIN
          ? new Text('Create an account',
          style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300))
          : new Text('Have an account? Sign in',
          style:
          new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
      onPressed: _formMode == FormMode.LOGIN
          ? _changeFormToSignUp
          : _changeFormToLogin,
    );
  }

  Widget _showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
            color: Colors.blue,
            child: _formMode == FormMode.LOGIN
                ? new Text('Login',
                style: new TextStyle(fontSize: 20.0, color: Colors.white))
                : new Text('Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: _validateAndSubmit,
          ),
        ));
  }

  Widget _showErrorMessage() {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  _showBody() {
    return Container(
      padding: EdgeInsets.all(16.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            logo,
            SizedBox(height: 10.0,),
            emailAddress,
            SizedBox(height: 10.0,),
            password,
            SizedBox(height: 10.0,),
            _showPrimaryButton(),
            SizedBox(height: 10.0,),
            _showSecondaryButton(),
            SizedBox(height: 10.0,),
            _showErrorMessage(),
            SizedBox(height: 10.0,),
          ],
        ),
      ),
    );
  }

  Widget _showCircularProgress(){
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    } return Container(height: 0.0, width: 0.0,);

  }


  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  static BuildContext _context;
  @override
  Widget build(BuildContext context) {
    _context=context;
    _isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
      ),
      body: Stack(
        children: <Widget>[
          _showBody(),
          _showCircularProgress(),
        ],
      ),
    );
  }
}
