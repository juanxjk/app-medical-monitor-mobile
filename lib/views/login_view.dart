import 'package:flutter/material.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _rememberMe = false;

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _usernameFieldController =
      TextEditingController();
  final TextEditingController _passwordFieldController =
      TextEditingController();

  void _handleLogin() async {
  }

  void _handleSignUp() {
  }

  String? _validateUsername(String value) {
    if (value.isEmpty) return "Por favor, preencha seu username";
  }

  String? _validatePassword(String? value) {
    if (value!.isEmpty) return "Por favor, preencha sua senha";
  }

  static final _kLabelStyle = TextStyle(
    fontWeight: FontWeight.bold,
  );

  static final _kBoxDecorationStyle = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    final _bgGradient = Container(
      height: double.infinity,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF73AEF5),
            Color(0xFF61A4F1),
            Color(0xFF478DE0),
            Color(0xFF398AE5),
          ],
          stops: [0.1, 0.4, 0.7, 0.9],
        ),
      ),
    );

    final _logoImg = Container(
      height: 100,
      width: 150,
      margin: EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(color: Colors.grey),
      child: Center(
        child: Text("LOGO"),
      ),
    );

    final _usernameField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Usuário",
            style: _kLabelStyle,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: _kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
            controller: _usernameFieldController,
            decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(top: 14),
                prefixIcon: Icon(
                  Icons.person,
                  color: Colors.black54,
                ),
                hintText: "Coloque seu username"),
          ),
        ),
      ],
    );

    final _passwordField = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "Senha",
            style: _kLabelStyle,
          ),
        ),
        Container(
          alignment: Alignment.centerLeft,
          decoration: _kBoxDecorationStyle,
          height: 60.0,
          child: TextFormField(
              controller: _passwordFieldController,
              obscureText: true,
              cursorColor: Colors.white,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(top: 14),
                  prefixIcon: Icon(
                    Icons.lock,
                    color: Colors.black54,
                  ),
                  hintText: "Coloque sua senha"),
              validator: _validatePassword),
        ),
      ],
    );

    final _keepSession = Container(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: <Widget>[
          Theme(
            data: ThemeData(unselectedWidgetColor: Colors.white),
            child: Checkbox(
              value: _rememberMe,
              checkColor: Colors.green,
              activeColor: Colors.white,
              onChanged: (value) {
                setState(() {
                  _rememberMe = value ?? false;
                });
              },
            ),
          ),
          Text(
            'Mantenha conectado',
            style: _kLabelStyle,
          ),
        ],
      ),
    );

    final _loginButton = Container(
      padding: EdgeInsets.symmetric(vertical: 15.0),
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(15.0),
          elevation: 5.0,
          primary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
        ),
        onPressed: _handleLogin,
        child: Text(
          "Login",
          style: TextStyle(
            color: Color(0xFF527DAA),
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );

    final _signUpWidget = GestureDetector(
      onTap: _handleSignUp,
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'Não tem uma conta? ',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Cadastre-se',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          _bgGradient,
          Container(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _logoImg,
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _usernameField,
                      _passwordField,
                      _keepSession,
                      _loginButton,
                    ],
                  ),
                ),
                _signUpWidget,
              ],
            ),
          ),
        ],
      ),
    );
  }
}
