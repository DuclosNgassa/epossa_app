import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:epossa_app/model/transfer.dart';
import 'package:epossa_app/model/transferDto.dart';
import 'package:epossa_app/model/transfer_bilan.dart';
import 'package:epossa_app/services/sharedpreferences_service.dart';
import 'package:epossa_app/util/constant_field.dart';
import 'package:epossa_app/util/rest_endpoints.dart';
import 'package:http/http.dart' as http;

class TransferService {
  SharedPreferenceService _sharedPreferenceService =
      new SharedPreferenceService();

  Future<Transfer> create(TransferDTO transfer) async {
    HttpClientRequest request =
        await HttpClient().postUrl(Uri.parse(URL_TRANSFERS))
          ..headers.contentType = ContentType.json
          ..write(jsonEncode(transfer));
    HttpClientResponse response = await request.close();

    if (response.statusCode == HttpStatus.ok) {
      String reply = await response.transform(utf8.decoder).join();
      Map userMap = jsonDecode(reply);
      return Transfer.fromJson(userMap);
    } else if (response.statusCode == HttpStatus.notFound) {
      return null;
    } else {
      throw Exception(
          'Failed to save a Transfer. Error: ${response.toString()}');
    }
  }

  Future<List<Transfer>> readBySender(String senderPhone) async {
    //Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    //final response = await http.Client().get('$URL_TRANSFERS_BY_SENDER$senderPhone', headers: headers);
    List<Transfer> transferList = new List();
    double sumTransferSent = 0.0;
    final response =
        await http.Client().get('$URL_TRANSFERS_BY_SENDER$senderPhone');
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> transfers = jsonDecode(response.body);
      transferList = await transfers.map<Transfer>((json) {
        Transfer transferMap = Transfer.fromJson(json);
        sumTransferSent += transferMap.amount;
        return transferMap;
      }).toList();
      //save all tranfers sent localy
      await _sharedPreferenceService.save(
          SUM_TRANSFER_SENT, sumTransferSent.toString());

      return transferList;
    } else if (response.statusCode == HttpStatus.notFound) {
      return transferList;
    } else {
      throw Exception('Failed to load Transfers by sender from the internet');
    }
  }

  Future<List<Transfer>> readByReceiver(String receiverPhone) async {
    //Map<String, String> headers = await _sharedPreferenceService.getHeaders();

    //final response = await http.Client().get('$URL_TRANSFERS_BY_RECEIVER$receiverPhone', headers: headers);
    List<Transfer> transferList = new List();
    double sumTransferReceived = 0.0;
    final response =
        await http.Client().get('$URL_TRANSFERS_BY_RECEIVER$receiverPhone');
    if (response.statusCode == HttpStatus.ok) {
      List<dynamic> transfers = jsonDecode(response.body);
      transferList = await transfers.map<Transfer>((json) {
        Transfer transferMap = Transfer.fromJson(json);
        sumTransferReceived += transferMap.amount;
        return transferMap;
      }).toList();
      //save all tranfers sent localy
      await _sharedPreferenceService.save(
          SUM_TRANSFER_RECEIVED, sumTransferReceived.toString());

      return transferList;
    } else if (response.statusCode == HttpStatus.notFound) {
      return transferList;
    } else {
      throw Exception('Failed to load Transfers by sender from the internet');
    }
  }

  Future<List<Transfer>> fetchTransfer() async {
    List<Transfer> transferList = new List();

    for (int i = 0; i <= 10; i++) {
      Transfer transfer = new Transfer(
          i,
          new DateTime.now(),
          '0023767655567' + i.toString(),
          '00237654458989' + i.toString(),
          double.parse("1000" + i.toString()),
          'Chausurehvhgvghvhjvjvvhvkvhvhjvjvhvhvhvk jvkjvvkjvhj hgvhvghvhjvjv g ghvjhgvghvhgv  hvhvhvkhvvvzfuozuofu' +
              i.toString());

      transferList.add(transfer);
    }

    return transferList;
  }

  Future<TransferBilan> getTransferBilan() async {
    //this both calls save sumTransferSent and sumTransferReceived
    await readByReceiver(LOGED_USER_PHONE);
    await readBySender(LOGED_USER_PHONE);

    String sumSent = await _sharedPreferenceService.read(SUM_TRANSFER_SENT);
    String sumReceived =
        await _sharedPreferenceService.read(SUM_TRANSFER_RECEIVED);

    TransferBilan transferBilan = TransferBilan();
    transferBilan.sumTransferSent = double.parse(sumSent ?? 0.0);
    transferBilan.sumTransferReceived = double.parse(sumReceived ?? 0.0);
    transferBilan.difference =
        transferBilan.sumTransferReceived - transferBilan.sumTransferSent;

    return transferBilan;
  }

  Future<List<Transfer>> fetchReceived() async {
    List<Transfer> transferList = new List();

    for (int i = 0; i <= 10; i++) {
      Transfer transfer = new Transfer(
          i,
          new DateTime.now(),
          '0023767655567' + i.toString(),
          '00237654458989' + i.toString(),
          double.parse("1000" + i.toString()),
          'Chausurehvhgvghvhjvjvvhvkvhvhjvjvhvhvhvk jvkjvvkjvhj ' +
              i.toString());

      transferList.add(transfer);
    }

    return transferList;
  }

  List<Transfer> sortDescending(List<Transfer> transfers) {
    transfers.sort((transfer1, transfer2) =>
        transfer1.created_at.isAfter(transfer2.created_at) ? 0 : 1);

    return transfers;
  }

  Future<Transfer> convertResponseToTransferUpdate(
      Map<String, dynamic> json) async {
    if (json["data"] == null) {
      return null;
    }

    //await _sharedPreferenceService.save(AUTHENTICATION_TOKEN, json["token"]);

    return Transfer(
      json["data"]["id"],
      DateTime.parse(json["data"]["created_at"]),
      json["data"]["sender"],
      json["data"]["receiver"],
      double.parse(json["data"]["amount"]),
      json["data"]["description"],
    );
  }
}
