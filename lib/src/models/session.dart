import 'dart:convert';

import 'package:flutter/foundation.dart';

class SessionList {
  final List<Session> sessions;
  final int sum;
  SessionList({
    required this.sessions,
    required this.sum,
  });

  factory SessionList.fromMap(Map<String, dynamic> map) {
    return SessionList(
      sessions: List<Session>.from(map['sessions']?.map((x) => Session.fromMap(x))),
      sum: map['sum'],
    );
  }

  factory SessionList.fromJson(String source) => SessionList.fromMap(json.decode(source));

  @override
  String toString() => 'SessionList(sessions: $sessions, sum: $sum)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is SessionList &&
      listEquals(other.sessions, sessions) &&
      other.sum == sum;
  }

  @override
  int get hashCode => sessions.hashCode ^ sum.hashCode;
}


class Session {
  final String id;
  final String userId;
  final int expire;
  final String ip;
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
  final bool current;
  Session({
    required this.id,
    required this.userId,
    required this.expire,
    required this.ip,
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
    required this.current,
  });

  Session copyWith({
    String? id,
    String? userId,
    int? expire,
    String? ip,
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
    bool? current,
  }) {
    return Session(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      expire: expire ?? this.expire,
      ip: ip ?? this.ip,
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
      current: current ?? this.current,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'expire': expire,
      'ip': ip,
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
      'current': current,
    };
  }

  factory Session.fromMap(Map<String, dynamic> map) {
    return Session(
      id: map['\$id'],
      userId: map['userId'],
      expire: map['expire'],
      ip: map['ip'],
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
      current: map['current'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Session.fromJson(String source) => Session.fromMap(json.decode(source));

  @override
  String toString() {
    return 'Session(id: $id, userId: $userId, expire: $expire, ip: $ip, osCode: $osCode, osName: $osName, osVersion: $osVersion, clientType: $clientType, clientCode: $clientCode, clientName: $clientName, clientVersion: $clientVersion, clientEngine: $clientEngine, clientEngineVersion: $clientEngineVersion, deviceName: $deviceName, deviceBrand: $deviceBrand, deviceModel: $deviceModel, countryCode: $countryCode, countryName: $countryName, current: $current)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
  
    return other is Session &&
      other.id == id &&
      other.userId == userId &&
      other.expire == expire &&
      other.ip == ip &&
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
      other.countryName == countryName &&
      other.current == current;
  }

  @override
  int get hashCode {
    return id.hashCode ^
      userId.hashCode ^
      expire.hashCode ^
      ip.hashCode ^
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
      countryName.hashCode ^
      current.hashCode;
  }
}
