import 'dart:convert' as convert;
import 'dart:io';
import 'package:http/http.dart' as http;

class RemoteDataSource {

  // static const String serverAddr = '';
  // static const String portNum = '';
  //
  // static const String baseUri = serverAddr + ':' + portNum;
  //
  // Map<String, String> header = {};
  //
  // Future<dynamic> requestTokenData() async {
  //
  //   const path = '/v1/user/';
  //
  //   // final params;
  //   //
  //   // final body;
  //
  //   final uri = Uri.https(baseUri,path);
  //
  //   final response = await http.get(uri, headers: header);
  //
  //   if(response.statusCode == 200){
  //     return;
  //   } else {
  //     throw('');
  //   }
  // }
  //
  // Future<void> addNoticeProtocol() async {
  //   var url =
  //   Uri.https('www.googleapis.com', '/books/v1/volumes', {'q': '{http}'});
  //
  //   // Await the http get response, then decode the json-formatted response.
  //
  //   var client = http.Client();
  //
  //   client.get(url,headers:);
  //
  //   client.patch(url, headers: , body: );
  //
  //   client.post(url,headers: ,body: ,encoding: );
  //
  //   client.close();
  //
  //   client.delete(url,headers: ,body: ,encoding: ,);
  //
  //   client.put(url,headers: ,body: ,encoding: ).then((value) => null);
  //
  //
  //   onRes
  //
  //   final response = client.get(url);
  //
  //   response
  //
  //   params;
  //
  //
  //
  //   var response = await http.get(url);
  //   if (response.statusCode == 200) {
  //     var jsonResponse =
  //     convert.jsonDecode(response.body) as Map<String, dynamic>;
  //     var itemCount = jsonResponse['totalItems'];
  //     print('Number of books about http: $itemCount.');
  //   } else {
  //     print('Request failed with status: ${response.statusCode}.');
  //   }
  // }

}