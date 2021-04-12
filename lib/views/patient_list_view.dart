import 'package:app_medical_monitor/models/patient.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/patient_service.dart';
import 'package:flutter/material.dart';

class PatientsListView extends StatefulWidget {
  final User _loggedUser;
  PatientsListView(this._loggedUser, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PatientsListViewState();
}

class _PatientsListViewState extends State<PatientsListView> {
  bool _hasMore = true;
  int _pageNumber = 1;
  bool _hasError = false;
  bool _isLoading = true;
  final int _defaultPatientsPerPageCount = 10;
  List<Patient> _patients = [];
  final int _nextPageThreshold = 1;

  Future<void> _fetchListPatients() async {
    try {
      final String token = widget._loggedUser.session!.token;

      final List<Patient> fetchPatients = await PatientService(token: token)
          .findAll(page: _pageNumber, size: _defaultPatientsPerPageCount);
      setState(() {
        _hasMore = fetchPatients.length == _defaultPatientsPerPageCount;
        _isLoading = false;
        _pageNumber = _pageNumber + 1;
        _patients.addAll(fetchPatients);
      });
    } catch (err, stack) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void _handleNavigatePatientAdd() {
  }

  Widget _buildPatientItem(Patient patient) => Card(
        color: Colors.blue.shade500,
        child: ListTile(
          onTap:(){},
          leading: Icon(Icons.person),
          title: Text(
            patient.fullName,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "CPF: ${patient.cpf} - Status: ${patient.status}",
            style: TextStyle(color: Colors.white60),
          ),
          trailing: Icon(
            Icons.chevron_right,
            color: Colors.white,
          ),
        ),
      );

  late final _error = Center(
      child: InkWell(
    onTap: _resetState,
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Text("Ocorreu um erro, pressione para tentar novamente"),
    ),
  ));

  late final _notFound = Center(
    child: InkWell(
      onTap: _resetState,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Text("Nenhum paciente encontrado, pressione para atualizar"),
      ),
    ),
  );

  final _loading = Center(
      child: Padding(
    padding: const EdgeInsets.all(8),
    child: CircularProgressIndicator(),
  ));

  Widget _getBody() {
    if (_patients.isEmpty) {
      if (_isLoading) return _loading;
      if (_hasError) return _error;
      return _notFound;
    } else {
      return ListView.builder(
          itemCount: _patients.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (_hasMore && index == _patients.length - _nextPageThreshold) {
              _fetchListPatients();
            }
            if (index == _patients.length) {
              if (_hasError)
                return _error;
              else
                return _loading;
            }
            final Patient patient = _patients[index];
            return _buildPatientItem(patient);
          });
    }
  }

  Future<void> _resetState() async {
    _hasMore = true;
    _pageNumber = 1;
    _hasError = false;
    _isLoading = true;
    _patients = [];
    _fetchListPatients();
  }

  @override
  void initState() {
    super.initState();
    _resetState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "Pacientes ${_hasMore ? "(${_patients.length}...)" : "(${_patients.length})"}"),
        actions: [
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNavigatePatientAdd,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
        ),
      ),
      body: RefreshIndicator(onRefresh: _resetState, child: _getBody()),
    );
  }
}
