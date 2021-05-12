import 'dart:convert';

import 'package:flutter/foundation.dart';

class LogList {
  final List<Log> logs;
  LogList({
    required this.logs,
  });

  factory LogList.fromMap(Map<String, dynamic> map) {
    return LogList(
      logs: List<Log>.from(map['logs']?.map((x) => Log.fromMap(x))),
    );
  }


  @override
  String toString() => 'LogList(logs: $logs)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is LogList &&
      listEquals(other.logs, logs);
  }

  @override
  int get hashCode => logs.hashCode;
}

class Log {
  final String event;
  final String ip;
  final int time;
  final String osCode;
  final String osName;
  final String osVersion;
  final String clientType;
  final String clientCode;
  final String clientName;
  final String clientVersion;
  final String clientEngine;
  final String clientEngineVersion;
  final String deviceName;
  final String deviceBrand;
  final String deviceModel;
  final String countryCode;
  final String countryName;
  Log({
    required this.event,
    required this.ip,
    required this.time,
    required this.osCode,
    required this.osName,
    required this.osVersion,
    required this.clientType,
    required this.clientCode,
    required this.clientName,
    required this.clientVersion,
    required this.clientEngine,
    required this.clientEngineVersion,
    required this.deviceName,
    required this.deviceBrand,
    required this.deviceModel,
    required this.countryCode,
    required this.countryName,
  });

  Log copyWith({
    String? event,
    String? ip,
    int? time,
    String? osCode,
    String? osName,
    String? osVersion,
    String? clientType,
    String? clientCode,
    String? clientName,
    String? clientVersion,
    String? clientEngine,
    String? clientEngineVersion,
    String? deviceName,
    String? deviceBrand,
    String? deviceModel,
    String? countryCode,
    String? countryName,
  }) {
    return Log(
      event: event ?? this.event,
      ip: ip ?? this.ip,
      time: time ?? this.time,
      osCode: osCode ?? this.osCode,
      osName: osName ?? this.osName,
      osVersion: osVersion ?? this.osVersion,
      clientType: clientType ?? this.clientType,
      clientCode: clientCode ?? this.clientCode,
      clientName: clientName ?? this.clientName,
      clientVersion: clientVersion ?? this.clientVersion,
      clientEngine: clientEngine ?? this.clientEngine,
      clientEngineVersion: clientEngineVersion ?? this.clientEngineVersion,
      deviceName: deviceName ?? this.deviceName,
      deviceBrand: deviceBrand ?? this.deviceBrand,
      deviceModel: deviceModel ?? this.deviceModel,
      countryCode: countryCode ?? this.countryCode,
      countryName: countryName ?? this.countryName,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'event': event,
      'ip': ip,
      'time': time,
      'osCode': osCode,
      'osName': osName,
      'osVersion': osVersion,
      'clientType': clientType,
      'clientCode': clientCode,
      'clientName': clientName,
      'clientVersion': clientVersion,
      'clientEngine': clientEngine,
      'clientEngineVersion': clientEngineVersion,
      'deviceName': deviceName,
      'deviceBrand': deviceBrand,
      'deviceModel': deviceModel,
      'countryCode': countryCode,
      'countryName': countryName,
    };
  }

  factory Log.fromMap(Map<String, dynamic> map) {
    return Log(
      event: map['event'],
      ip: map['ip'],
      time: map['time'],
      osCode: map['osCode'],
      osName: map['osName'],
      osVersion: map['osVersion'],
      clientType: map['clientType'],
      clientCode: map['clientCode'],
      clientName: map['clientName'],
      clientVersion: map['clientVersion'],
      clientEngine: map['clientEngine'],
      clientEngineVersion: map['clientEngineVersion'],
      deviceName: map['deviceName'],
      deviceBrand: map['deviceBrand'],
      deviceModel: map['deviceModel'],
      countryCode: map['countryCode'],
      countryName: map['countryName'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Log.fromJson(String source) => Log.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Logs(event: $event, ip: $ip, time: $time, osCode: $osCode, osName: $osName, osVersion: $osVersion, clientType: $clientType, clientCode: $clientCode, clientName: $clientName, clientVersion: $clientVersion, clientEngine: $clientEngine, clientEngineVersion: $clientEngineVersion, deviceName: $deviceName, deviceBrand: $deviceBrand, deviceModel: $deviceModel, countryCode: $countryCode, countryName: $countryName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Log &&
        other.event == event &&
        other.ip == ip &&
        other.time == time &&
        other.osCode == osCode &&
        other.osName == osName &&
        other.osVersion == osVersion &&
        other.clientType == clientType &&
        other.clientCode == clientCode &&
        other.clientName == clientName &&
        other.clientVersion == clientVersion &&
        other.clientEngine == clientEngine &&
        other.clientEngineVersion == clientEngineVersion &&
        other.deviceName == deviceName &&
        other.deviceBrand == deviceBrand &&
        other.deviceModel == deviceModel &&
        other.countryCode == countryCode &&
        other.countryName == countryName;
  }

  @override
  int get hashCode {
    return event.hashCode ^
        ip.hashCode ^
        time.hashCode ^
        osCode.hashCode ^
        osName.hashCode ^
        osVersion.hashCode ^
        clientType.hashCode ^
        clientCode.hashCode ^
        clientName.hashCode ^
        clientVersion.hashCode ^
        clientEngine.hashCode ^
        clientEngineVersion.hashCode ^
        deviceName.hashCode ^
        deviceBrand.hashCode ^
        deviceModel.hashCode ^
        countryCode.hashCode ^
        countryName.hashCode;
  }
}
