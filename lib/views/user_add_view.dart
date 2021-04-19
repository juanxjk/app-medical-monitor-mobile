import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/user_service.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';

class UserAddView extends StatefulWidget {
  final User _loggedUser;
  final User? editUser;
  UserAddView(this._loggedUser, {Key? key, this.editUser}) : super(key: key);

  @override
  _UserAddViewState createState() => _UserAddViewState();
}

class _UserAddViewState extends State<UserAddView> {
  final _formKey = GlobalKey<FormState>();

  User _user = User(
    fullName: "",
    email: "",
    username: "",
  );

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.editUser != null) {
      _user = widget.editUser!;
      _isEditMode = true;
    }
  }

  final _getDecoration = ({String? labelText}) => InputDecoration(
        labelText: labelText,
      );

  Future<void> _handleSave() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        await UserService(token: widget._loggedUser.session!.token).save(_user);
        showSuccessSnackBar(context, message: "Usuário criado");
        Navigator.of(context).pop();
      } else
        showErrorSnackBar(context, message: "Campos inválidos");
    } catch (err) {
      print(err);
      showErrorSnackBar(context);
    }
  }

  Future<void> _handleEdit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        await UserService(token: widget._loggedUser.session!.token)
            .update(_user);
        showSuccessSnackBar(context, message: "Usuário atualizado.");
        Navigator.of(context).pop(_user);
      } else
        showErrorSnackBar(context, message: "Campos inválidos.");
    } catch (err, stack) {
      showErrorSnackBar(context);
    }
  }

  Widget _buildUserID() => _isEditMode
      ? ListTile(
          title: Text("Identificação"),
          subtitle: Text(_user.id ?? "Sem identificação"),
        )
      : SizedBox.shrink();

  Widget _buildFullNameTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _user.fullName,
              decoration: _getDecoration(labelText: "Nome completo"),
              onChanged: (newValue) {
                setState(() {
                  _user.fullName = newValue;
                });
              },
              validator: (String? value) {
                if (value?.isEmpty ?? true) return "Campo obrigatório";
              },
            ),
          ),
        ],
      );

  Widget _buildUsernameTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _user.username,
              decoration: _getDecoration(labelText: "Usuário"),
              onChanged: (newValue) {
                setState(() {
                  _user.username = newValue;
                });
              },
              validator: (String? value) {
                if (value?.isEmpty ?? true) return "Campo obrigatório";
              },
            ),
          ),
        ],
      );

  Widget _buildEmailTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _user.email,
              decoration: _getDecoration(labelText: "E-mail"),
              onChanged: (newValue) {
                setState(() {
                  _user.email = newValue;
                });
              },
              validator: (String? value) {
                if (value?.isEmpty ?? true) return "Campo obrigatório";
              },
            ),
          ),
        ],
      );

  Widget _buildPasswordTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              obscureText: true,
              initialValue: _user.password,
              decoration: _getDecoration(labelText: "Nova senha"),
              onChanged: (newValue) {
                setState(() {
                  _user.password = newValue;
                });
              },
            ),
          ),
        ],
      );

  Widget _buildPasswordConfirmTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              obscureText: true,
              initialValue: null,
              decoration: _getDecoration(labelText: "Confirmar nova senha"),
              validator: (String? value) {
                if (_user.password == null) return null;
                if (value != _user.password) return "Senhas diferentes";
              },
            ),
          ),
        ],
      );

  Widget _buildRoleDropdownField() => Row(
        children: [
          Flexible(
            child: DropdownButtonFormField<UserRole>(
              decoration: _getDecoration(labelText: "Função"),
              value: _user.role,
              onChanged: (newValue) {
                final newRole = newValue ?? _user.role;
                setState(() {
                  _user.role = newRole;
                });
              },
              items: [
                DropdownMenuItem(
                  value: UserRole.guest,
                  child: Text('Convidado'),
                ),
                DropdownMenuItem(
                  value: UserRole.patient,
                  child: Text('Paciente'),
                ),
                DropdownMenuItem(
                  value: UserRole.nurse,
                  child: Text('Enfermeiro'),
                ),
                DropdownMenuItem(
                  value: UserRole.doctor,
                  child: Text('Médico'),
                ),
                DropdownMenuItem(
                  value: UserRole.admin,
                  child: Text('Administrador'),
                ),
              ],
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? "Editar usuário" : "Adicionar novo usuário"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: _isEditMode ? _handleEdit : _handleSave,
        child: Icon(Icons.save),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(25, 0, 25, 75),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildUserID(),
                  _buildFullNameTextField(),
                  _buildEmailTextField(),
                  _buildUsernameTextField(),
                  _buildPasswordTextField(),
                  _buildPasswordConfirmTextField(),
                  _buildRoleDropdownField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
