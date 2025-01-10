import '../../../data/api/model_success.dart';

/// [ChatTestApi] provides function similar to [ApiClient]
class ChatTestApi {
  /// [sendGetRequest] function signature is the same as ApiClient.sendGetRequest
  static Future<ApiSuccessResponse> sendGetRequest(String endpoint,
      {Map<String, dynamic>? queryParameters,
      BodyReader? readResponseBody,
      bool authenticate = true}) async {
    await Future.delayed(const Duration(seconds: 1));
    return ApiSuccessResponse(message: "Success", body: {
      "id": "55d867f8-0b51-4232-a863-499698120c96",
      "productId": "c157d610-5e25-4f63-b585-070378d54f0b",
      "senderId": "d76398b3-6c76-429d-a404-45d065f10916",
      "receiverId": "fd374dcd-ea9e-42e0-a264-fc05ab4a2463",
      "createdAt": "2024-11-18T15:14:47.000Z",
      "updatedAt": "2024-11-18T15:14:47.000Z",
      "message": _messages,
      "product": const {
        "id": "c157d610-5e25-4f63-b585-070378d54f0b",
        "name": "Sample Product",
        "price": "99.99"
      }
    });
  }

  static Future<ApiSuccessResponse> sendPostRequest(
      String endpoint, Map<String, dynamic> body,
      {BodyReader? readResponseBody, bool authenticate = true}) async {
    await Future.delayed(const Duration(milliseconds: 700));

    /** body would be of the form
         * {
              "productId": "c157d610-5e25-4f63-b585-070378d54f0b",
              "receiverId": "fd374dcd-ea9e-42e0-a264-fc05ab4a2463",
              "content": "Hello world",
              "fileUrl": "https://sequelize.org/docs/v6/other-topics/migrations/"
              "conversationId": "55d867f8-0b51-4232-a863-499698120c96"
            }

            but a raw message is of the form

            {
              "id": "a05c0e34-1f8b-4326-9dbf-4d367bebef16",
              "userId": "d76398b3-6c76-429d-a404-45d065f10916",
              "content": "Hello world",
              "fileUrl": "https://sequelize.org/docs/v6/other-topics/migrations/",
              "isRead": false,
              "createdAt": "2024-11-18T15:14:47.000Z",
              "updatedAt": "2024-11-18T15:57:35.000Z",
              "conversationId": "55d867f8-0b51-4232-a863-499698120c96",
              "user": {
                "id": "d76398b3-6c76-429d-a404-45d065f10916",
                "firstName": "John",
                "lastName": "Doe",
                "email": "testuser@example.com"
              }
            }
         */
    // change receiver to sender and send back into the chat
    final String receiverID = body["receiverId"];
    body["userId"] = receiverID;
    body["createdAt"] = DateTime.now().toString();
    body["isRead"] = false;
    body["user"] = {
      "id": "d76398b3-6c76-429d-a404-45d065f10916",
      "firstName": "John",
      "lastName": "Doe",
      "email": "testuser@example.com"
    };
    _messages.add(body);

    return const ApiSuccessResponse(message: "Success");
  }

  static final List<Map<String, dynamic>> _messages = [
    {
      "id": "a05c0e34-1f8b-4326-9dbf-4d367bebef16",
      "userId": "d76398b3-6c76-429d-a404-45d065f10916",
      "content": "Hello world",
      "fileUrl": "https://picsum.photos/200/300",
      "isRead": false,
      "createdAt": "2024-11-18T15:14:47.000Z",
      "updatedAt": "2024-11-18T15:57:35.000Z",
      "conversationId": "55d867f8-0b51-4232-a863-499698120c96",
      "user": {
        "id": "d76398b3-6c76-429d-a404-45d065f10916",
        "firstName": "John",
        "lastName": "Doe",
        "email": "testuser@example.com"
      }
    },
    {
      "id": "4572bd4b-9e75-4ba2-a826-fde0fee18c02",
      "userId": "d76398b3-6c76-429d-a404-45d065f10916",
      "content": "Hello, this is a message from the sender!",
      "fileUrl": "https://picsum.photos/200/300",
      "isRead": false,
      "createdAt": "2024-12-02T11:28:24.000Z",
      "updatedAt": "2024-12-02T11:28:24.000Z",
      "conversationId": "55d867f8-0b51-4232-a863-499698120c96",
      "user": {
        "id": "d76398b3-6c76-429d-a404-45d065f10916",
        "firstName": "John",
        "lastName": "Doe",
        "email": "testuser@example.com"
      }
    },
    {
      "id": "af2dbfc9-0dc3-40f3-bad1-dd4632563704",
      "userId": "d76398b3-6c76-429d-a404-45d065f10916",
      "content": "Hello, this is a message from the sender!",
      "fileUrl": "https://picsum.photos/200/300",
      "isRead": false,
      "createdAt": "2024-12-02T11:28:44.000Z",
      "updatedAt": "2024-12-02T11:28:44.000Z",
      "conversationId": "55d867f8-0b51-4232-a863-499698120c96",
      "user": {
        "id": "d76398b3-6c76-429d-a404-45d065f10916",
        "firstName": "John",
        "lastName": "Doe",
        "email": "testuser@example.com"
      }
    }
  ];
}
