// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'session_join_response.dart';

class SessionJoinResponseMapper extends ClassMapperBase<SessionJoinResponse> {
  SessionJoinResponseMapper._();

  static SessionJoinResponseMapper? _instance;
  static SessionJoinResponseMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = SessionJoinResponseMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'SessionJoinResponse';

  static String _$sessionId(SessionJoinResponse v) => v.sessionId;
  static const Field<SessionJoinResponse, String> _f$sessionId =
      Field('sessionId', _$sessionId, key: 'session_id');
  static String _$playerId(SessionJoinResponse v) => v.playerId;
  static const Field<SessionJoinResponse, String> _f$playerId =
      Field('playerId', _$playerId, key: 'player_id');

  @override
  final MappableFields<SessionJoinResponse> fields = const {
    #sessionId: _f$sessionId,
    #playerId: _f$playerId,
  };

  static SessionJoinResponse _instantiate(DecodingData data) {
    return SessionJoinResponse(data.dec(_f$sessionId), data.dec(_f$playerId));
  }

  @override
  final Function instantiate = _instantiate;

  static SessionJoinResponse fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<SessionJoinResponse>(map);
  }

  static SessionJoinResponse fromJson(String json) {
    return ensureInitialized().decodeJson<SessionJoinResponse>(json);
  }
}

mixin SessionJoinResponseMappable {
  String toJson() {
    return SessionJoinResponseMapper.ensureInitialized()
        .encodeJson<SessionJoinResponse>(this as SessionJoinResponse);
  }

  Map<String, dynamic> toMap() {
    return SessionJoinResponseMapper.ensureInitialized()
        .encodeMap<SessionJoinResponse>(this as SessionJoinResponse);
  }

  SessionJoinResponseCopyWith<SessionJoinResponse, SessionJoinResponse,
          SessionJoinResponse>
      get copyWith => _SessionJoinResponseCopyWithImpl(
          this as SessionJoinResponse, $identity, $identity);
  @override
  String toString() {
    return SessionJoinResponseMapper.ensureInitialized()
        .stringifyValue(this as SessionJoinResponse);
  }

  @override
  bool operator ==(Object other) {
    return SessionJoinResponseMapper.ensureInitialized()
        .equalsValue(this as SessionJoinResponse, other);
  }

  @override
  int get hashCode {
    return SessionJoinResponseMapper.ensureInitialized()
        .hashValue(this as SessionJoinResponse);
  }
}

extension SessionJoinResponseValueCopy<$R, $Out>
    on ObjectCopyWith<$R, SessionJoinResponse, $Out> {
  SessionJoinResponseCopyWith<$R, SessionJoinResponse, $Out>
      get $asSessionJoinResponse =>
          $base.as((v, t, t2) => _SessionJoinResponseCopyWithImpl(v, t, t2));
}

abstract class SessionJoinResponseCopyWith<$R, $In extends SessionJoinResponse,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({String? sessionId, String? playerId});
  SessionJoinResponseCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _SessionJoinResponseCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, SessionJoinResponse, $Out>
    implements SessionJoinResponseCopyWith<$R, SessionJoinResponse, $Out> {
  _SessionJoinResponseCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<SessionJoinResponse> $mapper =
      SessionJoinResponseMapper.ensureInitialized();
  @override
  $R call({String? sessionId, String? playerId}) => $apply(FieldCopyWithData({
        if (sessionId != null) #sessionId: sessionId,
        if (playerId != null) #playerId: playerId
      }));
  @override
  SessionJoinResponse $make(CopyWithData data) => SessionJoinResponse(
      data.get(#sessionId, or: $value.sessionId),
      data.get(#playerId, or: $value.playerId));

  @override
  SessionJoinResponseCopyWith<$R2, SessionJoinResponse, $Out2>
      $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
          _SessionJoinResponseCopyWithImpl($value, $cast, t);
}
