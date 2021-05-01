import 'package:app_medical_monitor/models/device.dart';
import 'package:app_medical_monitor/models/user.dart';
import 'package:app_medical_monitor/services/mqtt.dart' as mqtt_service;
import 'package:app_medical_monitor/views/utils/snackbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import "package:flutter/material.dart";
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class DeviceMonitorView extends StatefulWidget {
  final User _loggedUser;
  final Device _device;
  DeviceMonitorView(this._loggedUser, {required Device device})
      : this._device = device;

  @override
  _DeviceMonitorViewState createState() => _DeviceMonitorViewState();
}

class _DeviceMonitorViewState extends State<DeviceMonitorView> {
  late MqttServerClient _mqttClient;

  MonitorStatus _monitorStatus = MonitorStatus.connecting;
  double? _oximeterValue;
  DateTime? _oximeterChangeDate;
  double? _heartRateValue;
  DateTime? _heartRateChangeDate;
  double? _temperatureValue;
  DateTime? _temperatureChangeDate;

// Functions & Handles =========================================================
  void _handleClose() {
    Navigator.pop(context);
  }

  _connectMQTTClient() async {
    setState(() {
      _monitorStatus = MonitorStatus.connecting;
    });
    void onConnected() {
      showSuccessSnackBar(context, message: "Conectado.");
      setState(() {
        _monitorStatus = MonitorStatus.connected;
      });
    }

    void onDisconnected() {
      showErrorSnackBar(context, message: "Desconectado.");
      setState(() {
        _monitorStatus = MonitorStatus.disconnected;
      });
    }

    _mqttClient = await mqtt_service.connectMQTTClient(
      clientID: widget._loggedUser.id!,
      onConnected: onConnected,
      onDisconnected: onDisconnected,
    );

    final String deviceID = widget._device.id!;
    final String oximeterTopic = "devices/$deviceID/oximeter";
    final String heartRateTopic = "devices/$deviceID/heart-rate";
    final String temperatureTopic = "devices/$deviceID/temperature";

    if (widget._device.canMeasureO2Pulse)
      _mqttClient.subscribe(oximeterTopic, MqttQos.exactlyOnce);
    if (widget._device.canMeasureHeartRate)
      _mqttClient.subscribe(heartRateTopic, MqttQos.exactlyOnce);
    if (widget._device.canMeasureTemp)
      _mqttClient.subscribe(temperatureTopic, MqttQos.exactlyOnce);

    _mqttClient.updates
        ?.listen((List<MqttReceivedMessage<MqttMessage>> events) {
      final recMess = events[0].payload as MqttPublishMessage;
      final topic = events[0].topic;
      final message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message!);

      final lastUpdateDate = DateTime.now();
      setState(() {
        if (topic == oximeterTopic) {
          _oximeterValue = double.parse(message);
          _oximeterChangeDate = lastUpdateDate;
        }
        if (topic == heartRateTopic) {
          _heartRateValue = double.parse(message);
          _heartRateChangeDate = lastUpdateDate;
        }
        if (topic == temperatureTopic) {
          _temperatureValue = double.parse(message);
          _temperatureChangeDate = lastUpdateDate;
        }
      });
    });
  }

// Styles & Decorations ========================================================
  _getTitleStyle() =>
      TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700);
  _getInfoValueStyle({double? fontSize}) =>
      TextStyle(color: Colors.white, fontSize: fontSize ?? 18);
  _getMonitorValueStyle() => TextStyle(color: Colors.white, fontSize: 48);
  _getMonitorValueTypeStyle() => TextStyle(color: Colors.white, fontSize: 26);
  _getMonitorValueDateStyle() => TextStyle(color: Colors.white54, fontSize: 14);

  _getCardDecoration() => BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 5))
        ],
      );
  _getCardPadding() => EdgeInsets.symmetric(horizontal: 15, vertical: 15);
  _getCardMargin() => EdgeInsets.symmetric(vertical: 10, horizontal: 15);

// Widgets =====================================================================
  Widget _buildInfoCard() {
    Widget buildItem({
      required String title,
      required String subtitle,
      double? subtitleFontSize,
      Widget? subtitleIcon,
    }) =>
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Column(
            children: [
              Text(
                title,
                style: _getTitleStyle(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  subtitleIcon ?? SizedBox.shrink(),
                  Expanded(
                    child: Text(
                      subtitle,
                      style: _getInfoValueStyle(fontSize: subtitleFontSize),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )
            ],
          ),
        );

    String currentPatient = 'Nenhum paciente';
    if (widget._device.patient != null)
      currentPatient = '${widget._device.patient!.fullName}'
          ' (${widget._device.patient!.cpf})';

    return Container(
      padding: _getCardPadding(),
      margin: _getCardMargin(),
      decoration: _getCardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildItem(
              title: widget._device.title,
              subtitle: widget._device.id!,
              subtitleFontSize: 16),
          buildItem(title: 'Paciente monitorado', subtitle: currentPatient),
          buildItem(
              title: 'Conexão',
              subtitle: '${_monitorStatus.displayName.toUpperCase()}'),
        ],
      ),
    );
  }

  Widget _buildMonitorCard({
    required String title,
    bool isVisible = true,
    double? value,
    DateTime? lastUpdateDate,
    required String valueType,
  }) {
    if (!isVisible) return SizedBox.shrink();

    return Container(
      padding: _getCardPadding(),
      margin: _getCardMargin(),
      decoration: _getCardDecoration(),
      child: Column(
        children: [
          Text(
            title,
            style: _getTitleStyle(),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  value?.toString() ?? "--",
                  style: _getMonitorValueStyle(),
                ),
              ),
              Text(
                valueType,
                style: _getMonitorValueTypeStyle(),
              ),
            ],
          ),
          lastUpdateDate != null
              ? Text(
                  "Última atualização: $lastUpdateDate",
                  style: _getMonitorValueDateStyle(),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildReconnectBtn() => _monitorStatus == MonitorStatus.disconnected
      ? ElevatedButton(
          onPressed: () {
            _mqttClient.doAutoReconnect(force: true);
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.all(14.0),
            elevation: 4.0,
            primary: Colors.orange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(29.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Desconectado do servidor.",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
              Text(
                "Aperte para tentar novamente.",
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ))
      : SizedBox.shrink();

  @override
  void initState() {
    super.initState();
    _connectMQTTClient();
  }

  @override
  void dispose() {
    _mqttClient.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _handleClose,
        backgroundColor: Colors.red,
        child: Icon(Icons.close),
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _buildInfoCard(),
              _buildMonitorCard(
                title: "Oxímetro de pulso",
                value: _oximeterValue,
                lastUpdateDate: _oximeterChangeDate,
                valueType: "%",
                isVisible: widget._device.canMeasureO2Pulse,
              ),
              _buildMonitorCard(
                title: "Batimentos cardíacos",
                value: _heartRateValue,
                lastUpdateDate: _heartRateChangeDate,
                valueType: "BPM",
                isVisible: widget._device.canMeasureHeartRate,
              ),
              _buildMonitorCard(
                title: "Temperatura",
                value: _temperatureValue,
                lastUpdateDate: _temperatureChangeDate,
                valueType: "°C",
                isVisible: widget._device.canMeasureTemp,
              ),
              _buildReconnectBtn()
            ],
          ),
          Center(
            child: _buildReconnectBtn(),
          ),
        ],
      ),
    );
  }
}

enum MonitorStatus { connecting, connected, reconnecting, disconnected }

extension MonitorStatusExtension on MonitorStatus {
  String get name => describeEnum(this);
  String get displayName {
    switch (this) {
      case MonitorStatus.connected:
        return "conectado";
      case MonitorStatus.connecting:
        return "conectando";
      case MonitorStatus.reconnecting:
        return "reconectando";
      case MonitorStatus.disconnected:
        return "desconectado";
    }
  }
}
