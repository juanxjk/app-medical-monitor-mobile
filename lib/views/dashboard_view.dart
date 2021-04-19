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
            Card(
              margin: EdgeInsets.fromLTRB(10, 25, 10, 25),
              child: Column(
                children: [
                  Text("Bem-vindo ${widget._loggedUser.fullName}"),
                  ListTile(
                    title: Text("Username"),
                    subtitle: Text(widget._loggedUser.username),
                  ),
                  ListTile(
                    title: Text("E-mail"),
                    subtitle: Text(widget._loggedUser.email),
                  ),
                  SizedBox(
                    height: 35,
                  )
                ],
              ),
            ),
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
