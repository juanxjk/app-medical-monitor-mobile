import 'package:app_medical_monitor/models/device.dart';
import 'package:app_medical_monitor/models/patient.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/device_service.dart';
import 'package:app_medical_monitor/views/patient_list_view.dart';
import 'package:app_medical_monitor/views/patient_view.dart';
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
              items: DeviceStatus.values
                  .map(
                    (value) => DropdownMenuItem<DeviceStatus>(
                      value: value,
                      child: Text(value.displayName),
                    ),
                  )
                  .toList(),
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

  _handleNavigateUserSelection() async {
    final Patient? returnPatient = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PatientsListView(
          widget._loggedUser,
          isSelectionMode: true,
        ),
      ),
    );

    setState(() {
      this._device.patient = returnPatient;
    });
  }

  void _showAlertDialog(Patient patient) {
    handlePatientLinkOff() {
      setState(() {
        this._device.patient = null;
      });
      Navigator.of(context).pop();
    }

    handlePatientViewBtn() async {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => PatientView(
            widget._loggedUser,
            patient,
          ),
        ),
      );
    }

    handleSwitchPatientBtn() async {
      await _handleNavigateUserSelection();
      Navigator.of(context).pop();
    }

    handleAbortModal() => Navigator.of(context).pop();

    final patientLinkOffBtn = RawMaterialButton(
      onPressed: handlePatientLinkOff,
      elevation: 2.0,
      fillColor: Colors.white,
      child: Icon(
        Icons.link_off,
        size: 30.0,
        color: Colors.red,
      ),
      padding: EdgeInsets.all(10.0),
      shape: CircleBorder(),
    );

    Widget buildFieldInfo({required String title, required String body}) =>
        ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            body,
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
        );

    final dialog = AlertDialog(
      title: Row(
        children: [
          Expanded(
            child: FittedBox(
              child: Text(
                patient.fullName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          patientLinkOffBtn
        ],
      ),
      contentPadding: EdgeInsets.zero,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          buildFieldInfo(
            title: 'Nome completo',
            body: patient.fullName,
          ),
          buildFieldInfo(
            title: 'CPF',
            body: patient.cpf,
          )
        ],
      ),
      actions: [
        TextButton(
          onPressed: handlePatientViewBtn,
          style: TextButton.styleFrom(
              backgroundColor: Colors.blue, primary: Colors.white),
          child: Text('VER PERFIL'),
        ),
        TextButton(
          onPressed: handleSwitchPatientBtn,
          style: TextButton.styleFrom(
              backgroundColor: Colors.blue, primary: Colors.white),
          child: Text("ALTERAR"),
        ),
        TextButton(
          onPressed: handleAbortModal,
          style: TextButton.styleFrom(
              backgroundColor: Colors.red, primary: Colors.white),
          child: Text("CANCELAR"),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => dialog);
  }

  Widget _buildPatientField() => ElevatedButton(
        onPressed: () async {
          if (this._device.patient != null) {
            _showAlertDialog(this._device.patient!);
          } else {
            _handleNavigateUserSelection();
          }
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.blue.shade400,
                ),
                child: Icon(
                  this._device.patient != null
                      ? Icons.person
                      : Icons.person_add,
                  color: Colors.white,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _device.patient?.fullName ?? "Associar um paciente",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      _device.patient?.cpf ?? "Aperte escolher um paciente",
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildDeviceID(),
                  _buildTitleTextField(),
                  _buildDescriptionTextField(),
                  _buildStatusDropdownField(),
                  _buildHeartRateCheckbox(),
                  _buildO2PulseCheckbox(),
                  _buildTempCheckbox(),
                  _buildPatientField(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
