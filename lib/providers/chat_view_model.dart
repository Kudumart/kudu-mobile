import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:kudu/app/locator.dart';

import '../core/services/profile_service.dart';
import '../core/services/utility_storage_service.dart';
import 'package:http/http.dart' as http;

import '../data/api/endpoints.dart';
import '../models/chat/conversation_list.dart';
import '../models/chat/message_list_response.dart';
import '../models/chat/send_message_response.dart';

class ChatViewModel extends ChangeNotifier {
  final UserDataService userDataService = locator<UserDataService>();
  final storageService = StorageService();

  String get token{
    return 'Bearer ${storageService.getString('token')}';
  }

  Future<ConversationList?> getConversations() async {
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/conversations"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        ConversationList responseData = ConversationList.fromJson(data);
        return responseData;
      }catch(_){
        return null;
      }
    } else {
      return null;
    }
  }

  Future<SendMessageResponse?> sendMessage({String receiverId = "",String productId = "",String message = "",String? file}) async {
    var body = jsonEncode({
        "productId": productId,
        "receiverId": receiverId,
        "content": message,
        "fileUrl": file ?? "",
    });
    var response = await http.post(Uri.parse("${ApiEndpoint.baseUrl}/api/user/messages"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
      body: body,
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        SendMessageResponse sendMessageResponse = SendMessageResponse.fromJson(data);
        return sendMessageResponse;
      }catch(e){
        return null;
      }
    } else {
      return null;
    }
  }

  Future<MessageListResponse?> getMessages({String conversationId = ""}) async {
    var response = await http.get(Uri.parse("${ApiEndpoint.baseUrl}/api/user/messages?conversationId=$conversationId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        final data = json.decode(response.body);
        MessageListResponse responseData = MessageListResponse.fromJson(data);

        return responseData;
      }catch(_){
        return null;
      }
    } else {
      return null;
    }
  }

  Future<bool> deleteMessage({String messageId = ""}) async {
    var response = await http.delete(Uri.parse("${ApiEndpoint.baseUrl}/api/user/messages?messageId=$messageId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        return true;
      }catch(_){
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> markAsRead({String messageId = ""}) async {
    var response = await http.delete(Uri.parse("${ApiEndpoint.baseUrl}/api/user/mark/message/read?messageId=$messageId"),
      headers: {
        "Accept": "application/json",
        "Content-Type": "application/json",
        'Authorization': token,
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      try{
        return true;
      }catch(_){
        return false;
      }
    } else {
      return false;
    }
  }

  Future<String?> uploadFile({File? file}) async {
    try{
      if(file == null){
        return null;
      }
      final url = Uri.parse('https://api.cloudinary.com/v1_1/do2kojulq/upload');
      final request = http.MultipartRequest('POST', url)
        ..fields['upload_preset'] = 'kudumart'
        ..files.add(await http.MultipartFile.fromPath('file', file.path));
      final response = await request.send();

      if (response.statusCode == 200) {
        final responseData = await response.stream.toBytes();
        final responseString = String.fromCharCodes(responseData);
        final jsonMap = json.decode(responseString);
        final uploadedUrl = jsonMap['url'];

        return uploadedUrl;
      }else{
        return null;
      }
    }catch(_){
      return null;
    }
  }
}

class Debouncer {
  final int milliseconds;
  VoidCallback? action;
  Timer? timer;

  Debouncer({required this.milliseconds,this.timer,this.action});

  run(VoidCallback action) {
    if (timer != null) {
      timer!.cancel();
    }
    timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}