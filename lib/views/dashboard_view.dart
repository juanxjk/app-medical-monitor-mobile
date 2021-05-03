import 'package:app_medical_monitor/components/button_card.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/views/device_list_view.dart';
import 'package:app_medical_monitor/views/patient_list_view.dart';
import 'package:app_medical_monitor/views/user_list_view.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class DashboardView extends StatefulWidget {
  final User _loggedUser;

  DashboardView(this._loggedUser, {Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  void _handleNavigatePatientListView() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PatientsListView(widget._loggedUser)));
  }

  void _handleNavigateUserListView() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => UsersListView(widget._loggedUser)));
  }

  void _handleNavigateDeviceListView() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => DevicesListView(widget._loggedUser)));
  }

  void _handleNavigateSettingsView() {
    showErrorSnackBar(context,
        message: "Indisponível, está em desenvolvimento.");
  }

  void _handleLogout() {
    Navigator.pop(context);
    showErrorSnackBar(context, message: "Desconectado.");
  }

  _buildIsVerifiedAlert(bool isVerified) => isVerified
      ? SizedBox.shrink()
      : Container(
          padding: EdgeInsets.all(15),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), color: Colors.orange),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Icon(
                  Icons.error,
                  color: Colors.white,
                ),
              ),
              Text(
                "Conta não verificada!",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        );

  Widget _buildWelcomeCard() {
    const textColor = Colors.white;
    const bodyColor = Colors.white54;
    final welcomeStyle = const TextStyle(fontSize: 16, color: textColor);
    final titleStyle = const TextStyle(fontSize: 26, color: textColor);
    final labelStyle = const TextStyle(
        fontSize: 18, color: textColor, fontWeight: FontWeight.bold);
    final bodyStyle = const TextStyle(fontSize: 16, color: bodyColor);

    return Card(
      color: Colors.blue,
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5),
                  child: Text("Bem-vindo, ", style: welcomeStyle),
                ),
                Row(
                  children: [
                    Expanded(
                      child:
                          Text(widget._loggedUser.fullName, style: titleStyle),
                    )
                  ],
                ),
              ],
            ),
          ),
          ListTile(
            title: Text("Username", style: labelStyle),
            subtitle: Text(widget._loggedUser.username, style: bodyStyle),
            leading: Icon(Icons.person, color: Colors.white),
          ),
          ListTile(
            title: Text("Função", style: labelStyle),
            subtitle:
                Text(widget._loggedUser.role.displayName, style: bodyStyle),
            leading: Icon(Icons.label, color: textColor),
          ),
          ListTile(
            title: Text("E-mail", style: labelStyle),
            subtitle: Text(widget._loggedUser.email, style: bodyStyle),
            leading: Icon(Icons.email, color: textColor),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Dashboard"),
          actions: [
            IconButton(
              onPressed: _handleNavigateSettingsView,
              icon: Icon(Icons.settings),
            ),
            TextButton.icon(
              onPressed: _handleLogout,
              icon: Icon(Icons.exit_to_app),
              style: TextButton.styleFrom(primary: Colors.white),
              label: Text("Logout"),
            )
          ],
        ),
        body: ListView(
          children: [
            _buildIsVerifiedAlert(widget._loggedUser.isVerified),
            _buildWelcomeCard(),
            GridView.count(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 3,
              crossAxisSpacing: 4.0,
              mainAxisSpacing: 8.0,
              children: [
                ButtonCard(
                    icon: Icons.people,
                    label: "Usuários",
                    onTap: _handleNavigateUserListView),
                ButtonCard(
                    icon: Icons.devices,
                    label: "Dispositivos",
                    onTap: _handleNavigateDeviceListView),
                ButtonCard(
                    icon: Icons.people,
                    label: "Pacientes",
                    onTap: _handleNavigatePatientListView),
              ],
            ),
          ],
        ));
  }
}
