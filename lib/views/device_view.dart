import 'package:app_medical_monitor/models/device.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/device_service.dart';
import 'package:app_medical_monitor/views/device_add_view.dart';
import 'package:app_medical_monitor/views/device_monitor_view.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';

class DeviceView extends StatefulWidget {
  final User _loggedUser;
  final Device _device;
  DeviceView(this._loggedUser, this._device, {Key? key}) : super(key: key);

  @override
  _DeviceViewState createState() => _DeviceViewState();
}

class _DeviceViewState extends State<DeviceView> {
  late Device _device;

  _buildEditBtn(BuildContext context) => IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DeviceAddView(
                      widget._loggedUser,
                      editDevice: _device,
                    ))).then((value) {
          setState(() {
            _device = value ?? _device;
          });
        });
      });

  _buildLiveBtn(BuildContext context) => IconButton(
      icon: Icon(Icons.wifi_tethering),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceMonitorView(
              widget._loggedUser,
              device: _device,
            ),
          ),
        );
      });

  _buildDeleteBtn(BuildContext context) {
    final _yesBtn = ElevatedButton(
      autofocus: true,
      onPressed: () async {
        try {
          await DeviceService(token: widget._loggedUser.session!.token)
              .remove(_device.id!);
          Navigator.of(context).pop();
          showSuccessSnackBar(context,
              message: "Dispositivo removido com sucesso!");
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

  @override
  void initState() {
    super.initState();
    _device = widget._device;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dispositivo"),
        actions: [
          _buildLiveBtn(context),
          _buildEditBtn(context),
          _buildDeleteBtn(context),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("Identificação UUID"),
            subtitle: Text(_device.id!),
          ),
          ListTile(
            title: Text("Nome"),
            subtitle: Text(_device.title),
          ),
          ListTile(
            title: Text("Descrição"),
            subtitle: Text(_device.description.isEmpty
                ? "Sem descrição"
                : _device.description),
          ),
          ListTile(
            title: Text("Status"),
            subtitle: Text(_device.status.displayName),
          ),
          ListTile(
            leading: _device.canMeasureHeartRate
                ? Icon(Icons.check)
                : Icon(Icons.clear),
            title: Text("Pode medir batimentos cardíacos"),
          ),
          ListTile(
            leading: _device.canMeasureO2Pulse
                ? Icon(Icons.check)
                : Icon(Icons.clear),
            title: Text("Pode medir oximetria de pulso"),
          ),
          ListTile(
            leading:
                _device.canMeasureTemp ? Icon(Icons.check) : Icon(Icons.clear),
            title: Text("Pode medir temperatura"),
          ),
        ],
      ),
    );
  }
}
