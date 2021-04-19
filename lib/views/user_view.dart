import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/user_service.dart';
import 'package:app_medical_monitor/views/user_add_view.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';

class UserView extends StatefulWidget {
  final User _loggedUser;
  final User _user;
  UserView(this._loggedUser, this._user, {Key? key}) : super(key: key);

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  late User _user;

  _buildEditBtn(BuildContext context) => IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UserAddView(
                      widget._loggedUser,
                      editUser: _user,
                    ))).then((value) {
          setState(() {
            _user = value ?? _user;
          });
        });
      });

  _buildDeleteBtn(BuildContext context) {
    final _yesBtn = ElevatedButton(
      autofocus: true,
      onPressed: () async {
        try {
          await UserService(token: widget._loggedUser.session!.token)
              .remove(_user.id!);
          Navigator.of(context).pop();
          showSuccessSnackBar(context,
              message: "Usuário removido com sucesso!");
        } catch (err) {
          showErrorSnackBar(context);
        } finally {
          Navigator.of(context).pop();
        }
      },
      child: Text('Sim'),
    );

    final _noBtn = ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('Não'),
    );

    return IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    backgroundColor: Theme.of(context).errorColor,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                        Text(
                          "Deseja deletar?",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    actions: [_yesBtn, _noBtn],
                  ));
        });
  }

  List<Widget> _buildItemList({
    required String notFoundText,
    required List<String> itemList,
  }) {
    if (itemList.isEmpty) return [Text(notFoundText)];
    return itemList.asMap().entries.map((entry) {
      int index = entry.key;
      String comorbidity = entry.value;
      return ListTile(
        title: Text(comorbidity),
        leading: Icon(
          Icons.circle,
          size: 20,
        ),
      );
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _user = widget._user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Usuário"),
        actions: [
          _buildEditBtn(context),
          _buildDeleteBtn(context),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Identificação UUID"),
            subtitle: Text(_user.id!),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Nome completo"),
            subtitle: Text(_user.fullName),
          ),
          ListTile(
            leading: Icon(Icons.email),
            title: Text("E-mail"),
            subtitle: Text(_user.email),
          ),
          ListTile(
            title: Text("Usuário"),
            subtitle: Text(_user.username),
          ),
          ListTile(
            title: Text("Função"),
            subtitle: Text(_user.role.toString()),
          ),
          ListTile(
            title: Text("Conta verificada"),
            subtitle: Text(_user.isVerified ? "Sim" : "Não"),
          ),
        ],
      ),
    );
  }
}
