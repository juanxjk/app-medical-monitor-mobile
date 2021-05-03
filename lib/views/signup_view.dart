import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignUpView extends StatefulWidget {
  SignUpView({Key? key}) : super(key: key);

  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  final _formKey = GlobalKey<FormState>();

  final User _editUser = User(
    fullName: "",
    username: "",
    email: "",
  );

  void _handleSubmit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        showSuccessSnackBar(context, message: "Usuário criado");
      } else
        showErrorSnackBar(context, message: "Campos inválidos.");
    } catch (err) {
      showErrorSnackBar(context);
    }
  }

  void _handleAbort() {
    Navigator.of(context).pop();
  }

  final _labelStyle = const TextStyle(
      fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold);

  final _fieldBoxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(5),
    boxShadow: [
      BoxShadow(
        color: Colors.black12,
        blurRadius: 6.0,
        offset: Offset(0, 2),
      ),
    ],
  );
  final _textFieldDecoration = InputDecoration(border: InputBorder.none);

  Widget _buildFullNameTextField() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: _fieldBoxDecoration,
        child: TextFormField(
          onChanged: (value) {
            this._editUser.fullName = value;
          },
          decoration: _textFieldDecoration,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value?.isEmpty ?? true) return "Campo obrigatório";
          },
        ),
      );

  Widget _buildUsernameTextField() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: _fieldBoxDecoration,
        child: TextFormField(
          onChanged: (value) {
            this._editUser.username = value;
          },
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s+"))],
          decoration: _textFieldDecoration,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value?.isEmpty ?? true) return "Campo obrigatório";
          },
        ),
      );
  Widget _buildEmailTextField() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: _fieldBoxDecoration,
        child: TextFormField(
          onChanged: (value) {
            this._editUser.email = value;
          },
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s+"))],
          validator: (value) {
            if (value?.isEmpty ?? true) return "Campo obrigatório";
            final pattern =
                r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
                r"{0,253}[a-zA-Z0-9])?)*$";
            RegExp regex = new RegExp(pattern);
            if (!regex.hasMatch(value!))
              return 'E-mail com formato inválido';
            else
              return null;
          },
          decoration: _textFieldDecoration,
          keyboardType: TextInputType.emailAddress,
        ),
      );
  Widget _buildPasswordTextField() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: _fieldBoxDecoration,
        child: TextFormField(
          onChanged: (value) {
            this._editUser.password = value;
          },
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s+"))],
          obscureText: true,
          textInputAction: TextInputAction.next,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value?.isEmpty ?? true) return "Campo obrigatório";
          },
          decoration: _textFieldDecoration,
        ),
      );
  Widget _buildPasswordConfirmTextField() => Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: _fieldBoxDecoration,
        child: TextFormField(
          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r"\s+"))],
          obscureText: true,
          textInputAction: TextInputAction.done,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          validator: (value) {
            if (value?.isEmpty ?? true) return "Campo obrigatório";
            if (value != this._editUser.password) return "Senha não coincide";
          },
          decoration: _textFieldDecoration,
        ),
      );

  Widget _buildButton({
    required String label,
    required void Function() onPressed,
    Color color = Colors.white,
    Color labelColor = Colors.black87,
  }) =>
      Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onPressed,
              style: ElevatedButton.styleFrom(
                  primary: color, padding: EdgeInsets.all(10)),
              // style: ButtonStyle(backgroundColor: Color(Colors.grey)),
              child: Text(
                label,
                style: TextStyle(
                    color: labelColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.blue,
          ),
          SingleChildScrollView(
            child: SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Nome completo", style: _labelStyle),
                      SizedBox(height: 5),
                      _buildFullNameTextField(),
                      SizedBox(height: 15),
                      Text("Usuário", style: _labelStyle),
                      SizedBox(height: 5),
                      _buildUsernameTextField(),
                      SizedBox(height: 15),
                      Text("E-mail", style: _labelStyle),
                      SizedBox(height: 5),
                      _buildEmailTextField(),
                      SizedBox(height: 15),
                      Text("Senha", style: _labelStyle),
                      SizedBox(height: 5),
                      _buildPasswordTextField(),
                      SizedBox(height: 15),
                      Text("Confirmar senha", style: _labelStyle),
                      SizedBox(height: 5),
                      _buildPasswordConfirmTextField(),
                      SizedBox(height: 15),
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          "Você será cadastrado como Convidado. Entre em contato"
                          " com um administrador para definir seu nível de acesso.",
                          style: TextStyle(
                              color: Colors.black87,
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.justify,
                        ),
                      ),
                      SizedBox(height: 15),
                      _buildButton(
                          label: "Cadastrar",
                          onPressed: _handleSubmit,
                          color: Colors.green,
                          labelColor: Colors.white),
                      SizedBox(height: 10),
                      _buildButton(
                          label: "Sair",
                          onPressed: _handleAbort,
                          color: Colors.red,
                          labelColor: Colors.white)
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
