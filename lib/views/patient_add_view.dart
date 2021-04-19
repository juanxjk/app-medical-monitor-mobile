import 'package:app_medical_monitor/models/patient.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/patient_service.dart';
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

  late final _buildPatientID = ListTile(
    title: Text("Identificação"),
    subtitle: Text(_patient.id ?? "Sem identificação"),
  );

  late final _fullNameTextField = Row(
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

  late final _cpfTextField = Row(
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

  late final _genderDropdownField = Row(
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
          items: [
            DropdownMenuItem(
              value: GenderType.masculine,
              child: Text('Masculino'),
            ),
            DropdownMenuItem(
              value: GenderType.feminine,
              child: Text('Feminino'),
            ),
          ],
        ),
      ),
    ],
  );

  late final _statusDropdownField = Row(
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
          items: [
            DropdownMenuItem(
              value: PatientStatus.none,
              child: Text('Nenhum'),
            ),
            DropdownMenuItem(
              value: PatientStatus.waiting,
              child: Text('Em espera'),
            ),
            DropdownMenuItem(
              value: PatientStatus.treatment,
              child: Text('Em tratamento'),
            ),
            DropdownMenuItem(
              value: PatientStatus.discharged,
              child: Text('Com alta'),
            ),
          ],
        ),
      ),
    ],
  );

  late final _birthDateField = Row(
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
        label: Text("${_patient.birthDate.day}/" +
            "${_patient.birthDate.month}/" +
            "${_patient.birthDate.year}"),
      ),
    ],
  );

  late final _bedTextField = Row(
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

  late final _prognosisTextField = Row(
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

  late final _noteTextField = Row(
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

  _buildMenuAdd({required String title, required List<String> list}) {
    _buildList({required List<String> list}) {
      return list.asMap().entries.map((entry) {
        int index = entry.key;
        String illness = entry.value;
        return ListTile(
          title: Text(illness),
          leading: Icon(
            Icons.circle,
            size: 20,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              setState(() {
                list.removeAt(index);
              });
            },
          ),
        );
      }).toList();
    }

    final inputController = TextEditingController();

    _handleAddItem() {
      String newValue = inputController.value.text;
      if (newValue.isNotEmpty)
        setState(() {
          list.add(newValue);
          inputController.clear();
        });
    }

    return Column(
      children: [
        Row(
          children: [
            Flexible(
              child: TextFormField(
                controller: inputController,
                onFieldSubmitted: (value) {
                  _handleAddItem();
                },
                decoration: _getDecoration(labelText: title),
              ),
            ),
            IconButton(
              icon: Icon(Icons.add),
              onPressed: _handleAddItem,
            ),
          ],
        ),
        ..._buildList(list: list)
      ],
    );
  }

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
                  _isEditMode == true ? _buildPatientID : SizedBox.shrink(),
                  _fullNameTextField,
                  _cpfTextField,
                  _genderDropdownField,
                  _statusDropdownField,
                  _birthDateField,
                  _bedTextField,
                  _prognosisTextField,
                  _noteTextField,
                  _buildMenuAdd(
                      title: "Adicionar doença existente",
                      list: _patient.illnesses),
                  _buildMenuAdd(
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
