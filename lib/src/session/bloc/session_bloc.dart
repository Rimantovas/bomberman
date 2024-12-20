import 'package:bomberman/main.dart';
import 'package:bomberman/src/player/models/player.dart';
import 'package:bomberman/src/session/models/session_join_response.dart';
import 'package:bomberman/src/session/repositories/session_repository.dart';
import 'package:bomberman/utils/interceptor.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SessionState {
  final String? sessionId;
  final String? playerId;
  final bool isLoading;
  final List<PlayerModel> initialPlayers;

  SessionState(
      {this.sessionId,
      this.playerId,
      this.isLoading = true,
      this.initialPlayers = const []});
}

class SessionBloc extends Cubit<SessionState> {
  final SessionRepository _sessionRepository;

  SessionBloc()
      : _sessionRepository = SessionRepository(),
        super(SessionState());

  @override
  Future<void> close() {
    _sessionRepository.leaveSession();
    return super.close();
  }

  Future<SessionJoinResponse?> joinSession() async {
    emit(SessionState(isLoading: true));
    try {
      final SessionJoinResponse response =
          await _sessionRepository.joinSession();

      emit(SessionState(
        sessionId: response.sessionId,
        playerId: response.playerId,
        initialPlayers: response.players,
        isLoading: false,
      ));
      print('playerID: ${response.playerId}');
      httpClient.addInterceptor(PlayerIdHeaderIntercepter(response.playerId));
      return response;
    } catch (e) {
      print(e);
      emit(SessionState(isLoading: false));
      // Handle error
    }
    return null;
  }

  Future<void> leaveSession() async {
    emit(SessionState(isLoading: true));
    try {
      await _sessionRepository.leaveSession();
      emit(SessionState());
    } catch (e) {
      emit(SessionState(isLoading: false));
      // Handle error
    }
  }
}
