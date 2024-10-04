// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'player_move_request.dart';

class PlayerMoveRequestMapper extends ClassMapperBase<PlayerMoveRequest> {
  PlayerMoveRequestMapper._();

  static PlayerMoveRequestMapper? _instance;
  static PlayerMoveRequestMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PlayerMoveRequestMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PlayerMoveRequest';

  static int _$positionX(PlayerMoveRequest v) => v.positionX;
  static const Field<PlayerMoveRequest, int> _f$positionX =
      Field('positionX', _$positionX, key: 'position_x');
  static int _$positionY(PlayerMoveRequest v) => v.positionY;
  static const Field<PlayerMoveRequest, int> _f$positionY =
      Field('positionY', _$positionY, key: 'position_y');

  @override
  final MappableFields<PlayerMoveRequest> fields = const {
    #positionX: _f$positionX,
    #positionY: _f$positionY,
  };

  static PlayerMoveRequest _instantiate(DecodingData data) {
    return PlayerMoveRequest(data.dec(_f$positionX), data.dec(_f$positionY));
  }

  @override
  final Function instantiate = _instantiate;

  static PlayerMoveRequest fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PlayerMoveRequest>(map);
  }

  static PlayerMoveRequest fromJson(String json) {
    return ensureInitialized().decodeJson<PlayerMoveRequest>(json);
  }
}

mixin PlayerMoveRequestMappable {
  String toJson() {
    return PlayerMoveRequestMapper.ensureInitialized()
        .encodeJson<PlayerMoveRequest>(this as PlayerMoveRequest);
  }

  Map<String, dynamic> toMap() {
    return PlayerMoveRequestMapper.ensureInitialized()
        .encodeMap<PlayerMoveRequest>(this as PlayerMoveRequest);
  }

  PlayerMoveRequestCopyWith<PlayerMoveRequest, PlayerMoveRequest,
          PlayerMoveRequest>
      get copyWith => _PlayerMoveRequestCopyWithImpl(
          this as PlayerMoveRequest, $identity, $identity);
  @override
  String toString() {
    return PlayerMoveRequestMapper.ensureInitialized()
        .stringifyValue(this as PlayerMoveRequest);
  }

  @override
  bool operator ==(Object other) {
    return PlayerMoveRequestMapper.ensureInitialized()
        .equalsValue(this as PlayerMoveRequest, other);
  }

  @override
  int get hashCode {
    return PlayerMoveRequestMapper.ensureInitialized()
        .hashValue(this as PlayerMoveRequest);
  }
}

extension PlayerMoveRequestValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PlayerMoveRequest, $Out> {
  PlayerMoveRequestCopyWith<$R, PlayerMoveRequest, $Out>
      get $asPlayerMoveRequest =>
          $base.as((v, t, t2) => _PlayerMoveRequestCopyWithImpl(v, t, t2));
}

abstract class PlayerMoveRequestCopyWith<$R, $In extends PlayerMoveRequest,
    $Out> implements ClassCopyWith<$R, $In, $Out> {
  $R call({int? positionX, int? positionY});
  PlayerMoveRequestCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
      Then<$Out2, $R2> t);
}

class _PlayerMoveRequestCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PlayerMoveRequest, $Out>
    implements PlayerMoveRequestCopyWith<$R, PlayerMoveRequest, $Out> {
  _PlayerMoveRequestCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PlayerMoveRequest> $mapper =
      PlayerMoveRequestMapper.ensureInitialized();
  @override
  $R call({int? positionX, int? positionY}) => $apply(FieldCopyWithData({
        if (positionX != null) #positionX: positionX,
        if (positionY != null) #positionY: positionY
      }));
  @override
  PlayerMoveRequest $make(CopyWithData data) => PlayerMoveRequest(
      data.get(#positionX, or: $value.positionX),
      data.get(#positionY, or: $value.positionY));

  @override
  PlayerMoveRequestCopyWith<$R2, PlayerMoveRequest, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PlayerMoveRequestCopyWithImpl($value, $cast, t);
}
