import 'package:bomberman/src/session/models/session_join_response.dart';
import 'package:dio/dio.dart';

class SessionRepository {
  final Dio dio = Dio();

  static const String kSessionPath = '/sessions';
  static const String kJoinPath = '/join';
  static const String kLeavePath = '/leave';

  Future<SessionJoinResponse> joinSession() async {
    final response = await dio.post('$kSessionPath$kJoinPath');

    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }

    return SessionJoinResponseMapper.fromJson(response.data);
  }

  Future<void> leaveSession() async {
    final response = await dio.post('$kSessionPath$kLeavePath');

    if (response.statusCode != 200) {
      throw Exception(response.statusMessage);
    }

    return response.data;
  }
}
