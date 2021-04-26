import 'package:app_medical_monitor/components/menu_add.dart';
import 'package:app_medical_monitor/models/patient.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/patient_service.dart';
import 'package:app_medical_monitor/views/utils/date_format.dart';
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/material.dart';

class PatientAddView extends StatefulWidget {
  final User _loggedUser;
  final Patient? editPatient;
  PatientAddView(this._loggedUser, {Key? key, this.editPatient})
      : super(key: key);

  @override
  _PatientAddViewState createState() => _PatientAddViewState();
}

class _PatientAddViewState extends State<PatientAddView> {
  final _formKey = GlobalKey<FormState>();

  Patient _patient = Patient(
    fullName: "",
    gender: GenderType.masculine,
    cpf: "",
    birthDate: DateTime.now(),
    illnesses: List.empty(growable: true),
    comorbidities: List.empty(growable: true),
  );

  bool _isEditMode = false;

  @override
  void initState() {
    super.initState();
    if (widget.editPatient != null) {
      _patient = widget.editPatient!;
      _isEditMode = true;
    }
  }

  final _getDecoration = ({String? labelText}) => InputDecoration(
        labelText: labelText,
      );

  Future<void> _handleSave() async {
    try {
      if (_formKey.currentState?.validate() ?? false) {
        await PatientService(token: widget._loggedUser.session!.token)
            .save(_patient);
        showSuccessSnackBar(context, message: "Paciente criado");
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
        await PatientService(token: widget._loggedUser.session!.token)
            .update(_patient);
        showSuccessSnackBar(context, message: "Paciente atualizado.");
        Navigator.of(context).pop(_patient);
      } else
        showErrorSnackBar(context, message: "Campos inválidos.");
    } catch (err, stack) {
      showErrorSnackBar(context);
    }
  }

  Widget _buildPatientID() => ListTile(
        title: Text("Identificação"),
        subtitle: Text(_patient.id ?? "Sem identificação"),
      );

  Widget _buildFullNameTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _patient.fullName,
              decoration: _getDecoration(labelText: "Nome completo"),
              onChanged: (newValue) {
                setState(() {
                  _patient.fullName = newValue;
                });
              },
              validator: (String? value) {
                if (value?.isEmpty ?? true) return "Campo obrigatório";
              },
            ),
          ),
        ],
      );

  Widget _buildCPFTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _patient.cpf,
              decoration: _getDecoration(labelText: "CPF"),
              onChanged: (newValue) {
                setState(() {
                  _patient.cpf = newValue;
                });
              },
              validator: (String? value) {
                if (value?.isEmpty ?? true) return "Campo obrigatório";
              },
            ),
          ),
        ],
      );

  Widget _buildGenderDropdownField() => Row(
        children: [
          // TextField(),
          Flexible(
            child: DropdownButtonFormField<GenderType>(
              decoration: _getDecoration(labelText: "Gênero"),
              value: _patient.gender,
              onChanged: (newValue) {
                final newGender = newValue ?? _patient.gender;
                setState(() {
                  _patient.gender = newGender;
                });
              },
              items: GenderType.values
                  .map(
                    (value) => DropdownMenuItem<GenderType>(
                      value: value,
                      child: Text(value.displayName),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      );

  Widget _buildStatusDropdownField() => Row(
        children: [
          Flexible(
            child: DropdownButtonFormField<PatientStatus>(
              decoration: _getDecoration(labelText: "Status"),
              value: _patient.status,
              onChanged: (newValue) {
                final newStatus = newValue ?? _patient.status;
                setState(() {
                  _patient.status = newStatus;
                });
              },
              items: PatientStatus.values
                  .map((value) => DropdownMenuItem<PatientStatus>(
                        value: value,
                        child: Text(value.displayName),
                      ))
                  .toList(),
            ),
          ),
        ],
      );

  Widget _buildBirthDateField() => Padding(
        padding: EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Data de nascimento: "),
                ElevatedButton.icon(
                  onPressed: () async {
                    final newDate = await showDatePicker(
                      context: context,
                      initialDate: _patient.birthDate,
                      firstDate: DateTime.now().subtract(Duration(days: 54750)),
                      lastDate: DateTime.now(),
                    );
                    final date = newDate ?? _patient.birthDate;
                    setState(() {
                      _patient.birthDate = date;
                    });
                  },
                  icon: Icon(Icons.calendar_today),
                  label: Text(formatDateInFullPTBR(this._patient.birthDate)),
                ),
              ],
            )
          ],
        ),
      );

  Widget _buildBedTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _patient.bed,
              onChanged: (newValue) {
                setState(() {
                  _patient.bed = newValue;
                });
              },
              decoration: _getDecoration(labelText: "Leito"),
            ),
          ),
        ],
      );

  Widget _buildPrognosisTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _patient.prognosis,
              onChanged: (newValue) {
                setState(() {
                  _patient.prognosis = newValue;
                });
              },
              decoration: _getDecoration(labelText: "Prognóstico"),
            ),
          ),
        ],
      );

  Widget _buildNoteTextField() => Row(
        children: [
          Flexible(
            child: TextFormField(
              initialValue: _patient.note,
              maxLines: null,
              onChanged: (newValue) {
                setState(() {
                  _patient.note = newValue;
                });
              },
              decoration: _getDecoration(labelText: "Observações"),
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(_isEditMode ? "Editar paciente" : "Adicionar novo paciente"),
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
                  _isEditMode == true ? _buildPatientID() : SizedBox.shrink(),
                  _buildFullNameTextField(),
                  _buildCPFTextField(),
                  _buildGenderDropdownField(),
                  _buildStatusDropdownField(),
                  _buildBirthDateField(),
                  _buildBedTextField(),
                  _buildPrognosisTextField(),
                  _buildNoteTextField(),
                  MenuAdd(
                      title: "Adicionar doença existente",
                      list: _patient.illnesses),
                  MenuAdd(
                      title: "Adicionar comorbidade existente",
                      list: _patient.comorbidities),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
