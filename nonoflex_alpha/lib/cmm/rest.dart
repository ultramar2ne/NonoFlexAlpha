import 'dart:html';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

abstract class ServerConfig {
  final String serverAddr;

  final String portNum;

  final String authToken;

  final String refreshToken;

  String get serverUri => serverAddr + ':' + portNum;

  ServerConfig({
    required this.serverAddr,
    required this.portNum,
    required this.authToken,
    required this.refreshToken,
  });
}

abstract class BlueApiServer {
  final ServerConfig serverConfig;

  BlueApiServer({required this.serverConfig});

  Future<dynamic> request(HttpBaseProtocol protocol) async {
    try {
      final client = http.Client();

      switch (protocol.requestType) {
        case HttpRequestType.get:
          final response = await http.get(
            Uri.http(serverConfig.serverUri, protocol.path, protocol.params),
            headers: protocol.headers,
          );
          if (response.statusCode == 200) {
            protocol.onSuccess(response);
          } else {
            protocol.onError(response);
          }
          break;

        case HttpRequestType.post:
          final response = await http.post(
            Uri.http(serverConfig.serverUri, protocol.path, protocol.params),
            body: protocol.body,
            headers: protocol.headers,
          );
          if (response.statusCode == 200) {
            protocol.onSuccess(response);
          } else {
            protocol.onError(response);
          }

          break;
        case HttpRequestType.patch:
          // TODO: Handle this case.
          break;
        case HttpRequestType.delete:
          // TODO: Handle this case.
          break;
      }
    } catch (e) {}

    return '';
  }
}

abstract class HttpBaseProtocol {
  // override 해서 요청 변경
  HttpRequestType get requestType => HttpRequestType.get;

  String get path => '';

  Map<String, String> get params => {};

  Map<String, String> get headers => {
        'Content-Type': 'Json',
      };

  String get body => '';

  Future<dynamic> onSuccess(http.Response response) async {
    return '';
  }

  Future<Exception> onError(http.Response response) async {
    throw (Exception(''));
  }
}

enum HttpRequestType {
  get,
  post,
  patch,
  delete,
}
