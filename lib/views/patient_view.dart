import 'package:app_medical_monitor/models/device.dart';
import 'package:app_medical_monitor/models/patient.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/patient_service.dart';
import 'package:app_medical_monitor/views/device_monitor_view.dart';
import 'package:app_medical_monitor/views/patient_add_view.dart';
import 'package:app_medical_monitor/views/utils/date_format.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';

class PatientView extends StatefulWidget {
  final User _loggedUser;
  final Patient _patient;
  PatientView(this._loggedUser, this._patient, {Key? key}) : super(key: key);

  @override
  _PatientViewState createState() => _PatientViewState();
}

class _PatientViewState extends State<PatientView> {
  late Patient _patient;

  _handleNavigateMonitor(Device device) {
    return () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DeviceMonitorView(
              widget._loggedUser,
              device: device,
            ),
          ),
        );
  }

  _buildEditBtn(BuildContext context) => IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => PatientAddView(
                      widget._loggedUser,
                      editPatient: _patient,
                    ))).then((value) {
          setState(() {
            _patient = value ?? _patient;
          });
        });
      });

  _buildDeleteBtn(BuildContext context) {
    final _yesBtn = ElevatedButton(
      autofocus: true,
      onPressed: () async {
        try {
          await PatientService(token: widget._loggedUser.session!.token)
              .remove(_patient.id!);
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        } catch (err) {
          Navigator.of(context).pop();
          showErrorSnackBar(context);
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
    _patient = widget._patient;
  }

  _buildDeviceListBtn() => IconButton(
      icon: Icon(Icons.view_sidebar_outlined),
      tooltip: this._patient.devices.isEmpty
          ? "Sem dispositivos"
          : "Ver dispositivos",
      onPressed: this._patient.devices.isNotEmpty
          ? () async {
              buildOptionItem(Device device) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      onTap: _handleNavigateMonitor(device),
                      title: Text(
                        device.title,
                        style: TextStyle(color: Colors.white),
                      ),
                      leading: Icon(
                        Icons.view_sidebar_outlined,
                        color: Colors.white,
                      ),
                      tileColor: Colors.blue,
                    ),
                  );

              final deviceListOptions = this
                  ._patient
                  .devices
                  .map((device) => buildOptionItem(device))
                  .toList();

              showDialog(
                context: context,
                builder: (context) => SimpleDialog(
                  children: [...deviceListOptions],
                  title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Dispositivos"),
                        IconButton(
                            icon: Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                            onPressed: () => Navigator.of(context).pop())
                      ]),
                ),
              );
            }
          : null);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paciente"),
        actions: [
          _buildDeviceListBtn(),
          _buildEditBtn(context),
          _buildDeleteBtn(context),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Identificação UUID"),
            subtitle: Text(_patient.id!),
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text("Nome completo"),
            subtitle: Text(_patient.fullName),
          ),
          ListTile(
            leading: Icon(Icons.subtitles),
            title: Text("CPF"),
            subtitle: Text(_patient.cpf),
          ),
          ListTile(
            title: Text("Gênero"),
            subtitle: Text(_patient.gender.displayName),
          ),
          ListTile(
            title: Text("Data de nascimento"),
            subtitle: Text(formatDateInFullPTBR(this._patient.birthDate)),
          ),
          ListTile(
            title: Text("Status"),
            subtitle: Text(_patient.status.displayName),
          ),
          ListTile(
            title: Text("Leito"),
            subtitle:
                Text(_patient.bed.isEmpty ? "Nenhum leito" : _patient.bed),
          ),
          ListTile(
            title: Text("Prognóstico"),
            subtitle: Text(_patient.prognosis.isEmpty
                ? "Sem prognóstico"
                : _patient.prognosis),
          ),
          ListTile(
            title: Text("Observações"),
            subtitle:
                Text(_patient.note.isEmpty ? "Sem observações" : _patient.note),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Doenças:"),
              ..._buildItemList(
                  notFoundText: "Sem doenças", itemList: _patient.illnesses)
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Comorbidades:"),
              ..._buildItemList(
                  notFoundText: "Sem comorbidades",
                  itemList: _patient.comorbidities)
            ],
          ),
        ],
      ),
    );
  }
}
