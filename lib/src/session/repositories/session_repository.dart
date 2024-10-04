import 'package:bomberman/main.dart';
import 'package:bomberman/src/session/models/session_join_response.dart';

class SessionRepository {
  static const String kSessionPath = '/sessions';
  static const String kJoinPath = '/join';
  static const String kLeavePath = '/leave';

  Future<SessionJoinResponse> joinSession() async {
    final response = await dio.post('$kSessionPath$kJoinPath');

    print(response.data);

    print(response.statusCode);

    print(response.statusMessage);

    if (response.statusCode! > 300) {
      throw Exception(response.statusMessage);
    }

    return SessionJoinResponseMapper.fromMap(response.data);
  }

  Future<void> leaveSession() async {
    final response = await dio.post('$kSessionPath$kLeavePath');

    if (response.statusCode! > 300) {
      throw Exception(response.statusMessage);
    }

    return response.data;
  }
}