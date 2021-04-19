import 'package:app_medical_monitor/models/device.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/device_service.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';

class DeviceAddView extends StatefulWidget {
  final User _loggedUser;
  final Device? editDevice;
  DeviceAddView(this._loggedUser, {Key? key, this.editDevice})
      : super(key: key);

  @override
  _DeviceAddViewState createState() => _DeviceAddViewState();
}

class _DeviceAddViewState extends State<DeviceAddView> {
  final _formKey = GlobalKey<FormState>();

  Device _device = Device(
    title: "",
  );

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.editDevice != null) {
      _device = widget.editDevice!;
      _isEditMode = true;
    }
  }

  final _getDecoration = ({String? labelText}) => InputDecoration(
        labelText: labelText,
      );

  Future<void> _handleSave() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        await DeviceService(token: widget._loggedUser.session!.token)
            .save(_device);
        showSuccessSnackBar(context, message: "Dispositivo criado");
        Navigator.of(context).pop();
      } else
        showErrorSnackBar(context, message: "Campos inválidos");
    } catch (err) {
      showErrorSnackBar(context);
    }
  }

  Future<void> _handleEdit() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        await DeviceService(token: widget._loggedUser.session!.token)
            .update(_device);
        showSuccessSnackBar(context, message: "Dispositivo atualizado.");
        Navigator.of(context).pop(_device);
      } else
        showErrorSnackBar(context, message: "Campos inválidos.");
    } catch (err, stack) {
      showErrorSnackBar(context);
    }
  }

  Widget _buildDeviceID() => _isEditMode
      ? ListTile(
          title: Text("Identificação"),
          subtitle: Text(_device.id ?? "Sem identificação"),
        )
      : SizedBox.shrink();

  Widget _buildTitleTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _device.title,
              decoration: _getDecoration(labelText: "Nome"),
              onChanged: (newValue) {
                setState(() {
                  _device.title = newValue;
                });
              },
              validator: (String? value) {
                if (value?.isEmpty ?? true) return "Campo obrigatório";
              },
            ),
          ),
        ],
      );

  Widget _buildDescriptionTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _device.description,
              decoration: _getDecoration(labelText: "Descrição"),
              onChanged: (newValue) {
                setState(() {
                  _device.description = newValue;
                });
              },
            ),
          ),
        ],
      );

  Widget _buildStatusDropdownField() => Row(
        children: [
          Flexible(
            child: DropdownButtonFormField<DeviceStatus>(
              decoration: _getDecoration(labelText: "Status"),
              value: _device.status,
              onChanged: (newValue) {
                final newStatus = newValue ?? _device.status;
                setState(() {
                  _device.status = newStatus;
                });
              },
              items: [
                DropdownMenuItem(
                  value: DeviceStatus.none,
                  child: Text('Nenhum'),
                ),
                DropdownMenuItem(
                  value: DeviceStatus.active,
                  child: Text('Em uso'),
                ),
                DropdownMenuItem(
                  value: DeviceStatus.maintenance,
                  child: Text('Em manutenção'),
                ),
                DropdownMenuItem(
                  value: DeviceStatus.inactive,
                  child: Text('Inativado'),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildHeartRateCheckbox() => CheckboxListTile(
        title: Text("Pode medir batimentos cardíacos"),
        value: _device.canMeasureHeartRate,
        onChanged: (newValue) {
          setState(() {
            _device.canMeasureHeartRate = newValue ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Colors.green,
        activeColor: Colors.white,
        selectedTileColor: Colors.black54,
      );

  Widget _buildO2PulseCheckbox() => CheckboxListTile(
        title: Text("Pode medir oximetria de pulso"),
        value: _device.canMeasureO2Pulse,
        onChanged: (newValue) {
          setState(() {
            _device.canMeasureO2Pulse = newValue ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Colors.green,
        activeColor: Colors.white,
        selectedTileColor: Colors.black54,
      );

  Widget _buildTempCheckbox() => CheckboxListTile(
        title: Text("Pode medir temperatura"),
        value: _device.canMeasureTemp,
        onChanged: (newValue) {
          setState(() {
            _device.canMeasureTemp = newValue ?? false;
          });
        },
        controlAffinity: ListTileControlAffinity.leading,
        checkColor: Colors.green,
        activeColor: Colors.white,
        selectedTileColor: Colors.black54,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            _isEditMode ? "Editar dispositivo" : "Adicionar novo dispositivo"),
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
                  _buildDeviceID(),
                  _buildTitleTextField(),
                  _buildDescriptionTextField(),
                  _buildStatusDropdownField(),
                  _buildHeartRateCheckbox(),
                  _buildO2PulseCheckbox(),
                  _buildTempCheckbox(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
