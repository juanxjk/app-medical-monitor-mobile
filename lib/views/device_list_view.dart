import 'package:app_medical_monitor/models/device.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/device_service.dart';
import 'package:app_medical_monitor/views/device_view.dart';
import 'package:flutter/material.dart';

class DevicesListView extends StatefulWidget {
  final User _loggedUser;
  DevicesListView(this._loggedUser, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _DevicesListViewState();
}

class _DevicesListViewState extends State<DevicesListView> {
  bool _hasMore = true;
  int _pageNumber = 1;
  bool _hasError = false;
  bool _isLoading = true;
  final int _defaultDevicesPerPageCount = 10;
  List<Device> _devices = [];
  final int _nextPageThreshold = 1;

  Future<void> _fetchListDevices() async {
    try {
      final String token = widget._loggedUser.session!.token;

      final List<Device> fetchDevices = await DeviceService(token: token)
          .findAll(page: _pageNumber, size: _defaultDevicesPerPageCount);
      setState(() {
        _hasMore = fetchDevices.length == _defaultDevicesPerPageCount;
        _isLoading = false;
        _pageNumber = _pageNumber + 1;
        _devices.addAll(fetchDevices);
      });
    } catch (err, stack) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  void Function() _handleNavigateDeviceView(Device device) =>
      () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DeviceView(widget._loggedUser, device),
            ),
          ).then((value) => _resetState());

  void _handleNavigateDeviceAdd() {
  }

  Widget _buildDeviceItem(Device device) => Card(
        color: Colors.blue.shade500,
        child: ListTile(
          onTap: _handleNavigateDeviceView(device),
          leading: Icon(Icons.wifi_tethering),
          title: Text(
            device.title,
            style: TextStyle(color: Colors.white),
          ),
          subtitle: Text(
            "Status: ${device.status}",
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
        child: Text("Nenhum dispositivo encontrado, pressione para atualizar"),
      ),
    ),
  );

  final _loading = Center(
      child: Padding(
    padding: const EdgeInsets.all(8),
    child: CircularProgressIndicator(),
  ));

  Widget _getBody() {
    if (_devices.isEmpty) {
      if (_isLoading) return _loading;
      if (_hasError) return _error;
      return _notFound;
    } else {
      return ListView.builder(
          itemCount: _devices.length + (_hasMore ? 1 : 0),
          itemBuilder: (context, index) {
            if (_hasMore && index == _devices.length - _nextPageThreshold) {
              _fetchListDevices();
            }
            if (index == _devices.length) {
              if (_hasError)
                return _error;
              else
                return _loading;
            }
            final Device device = _devices[index];
            return _buildDeviceItem(device);
          });
    }
  }

  Future<void> _resetState() async {
    _hasMore = true;
    _pageNumber = 1;
    _hasError = false;
    _isLoading = true;
    _devices = [];
    _fetchListDevices();
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
            "Dispositivos ${_hasMore ? "(${_devices.length}...)" : "(${_devices.length})"}"),
        actions: [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleNavigateDeviceAdd,
        backgroundColor: Colors.green,
        child: Icon(
          Icons.add,
        ),
      ),
      body: RefreshIndicator(onRefresh: _resetState, child: _getBody()),
    );
  }
}
