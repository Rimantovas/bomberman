// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'player.dart';

class PlayerModelMapper extends ClassMapperBase<PlayerModel> {
  PlayerModelMapper._();

  static PlayerModelMapper? _instance;
  static PlayerModelMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = PlayerModelMapper._());
    }
    return _instance!;
  }

  @override
  final String id = 'PlayerModel';

  static String _$id(PlayerModel v) => v.id;
  static const Field<PlayerModel, String> _f$id = Field('id', _$id);
  static String _$sessionId(PlayerModel v) => v.sessionId;
  static const Field<PlayerModel, String> _f$sessionId =
      Field('sessionId', _$sessionId, key: 'session_id');
  static int _$positionX(PlayerModel v) => v.positionX;
  static const Field<PlayerModel, int> _f$positionX =
      Field('positionX', _$positionX, key: 'position_x');
  static int _$positionY(PlayerModel v) => v.positionY;
  static const Field<PlayerModel, int> _f$positionY =
      Field('positionY', _$positionY, key: 'position_y');
  static int _$health(PlayerModel v) => v.health;
  static const Field<PlayerModel, int> _f$health =
      Field('health', _$health, opt: true, def: 100);

  @override
  final MappableFields<PlayerModel> fields = const {
    #id: _f$id,
    #sessionId: _f$sessionId,
    #positionX: _f$positionX,
    #positionY: _f$positionY,
    #health: _f$health,
  };

  static PlayerModel _instantiate(DecodingData data) {
    return PlayerModel(data.dec(_f$id), data.dec(_f$sessionId),
        data.dec(_f$positionX), data.dec(_f$positionY),
        health: data.dec(_f$health));
  }

  @override
  final Function instantiate = _instantiate;

  static PlayerModel fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PlayerModel>(map);
  }

  static PlayerModel fromJson(String json) {
    return ensureInitialized().decodeJson<PlayerModel>(json);
  }
}

mixin PlayerModelMappable {
  String toJson() {
    return PlayerModelMapper.ensureInitialized()
        .encodeJson<PlayerModel>(this as PlayerModel);
  }

  Map<String, dynamic> toMap() {
    return PlayerModelMapper.ensureInitialized()
        .encodeMap<PlayerModel>(this as PlayerModel);
  }

  PlayerModelCopyWith<PlayerModel, PlayerModel, PlayerModel> get copyWith =>
      _PlayerModelCopyWithImpl(this as PlayerModel, $identity, $identity);
  @override
  String toString() {
    return PlayerModelMapper.ensureInitialized()
        .stringifyValue(this as PlayerModel);
  }

  @override
  bool operator ==(Object other) {
    return PlayerModelMapper.ensureInitialized()
        .equalsValue(this as PlayerModel, other);
  }

  @override
  int get hashCode {
    return PlayerModelMapper.ensureInitialized().hashValue(this as PlayerModel);
  }
}

extension PlayerModelValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PlayerModel, $Out> {
  PlayerModelCopyWith<$R, PlayerModel, $Out> get $asPlayerModel =>
      $base.as((v, t, t2) => _PlayerModelCopyWithImpl(v, t, t2));
}

abstract class PlayerModelCopyWith<$R, $In extends PlayerModel, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call(
      {String? id,
      String? sessionId,
      int? positionX,
      int? positionY,
      int? health});
  PlayerModelCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _PlayerModelCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PlayerModel, $Out>
    implements PlayerModelCopyWith<$R, PlayerModel, $Out> {
  _PlayerModelCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<PlayerModel> $mapper =
      PlayerModelMapper.ensureInitialized();
  @override
  $R call(
          {String? id,
          String? sessionId,
          int? positionX,
          int? positionY,
          int? health}) =>
      $apply(FieldCopyWithData({
        if (id != null) #id: id,
        if (sessionId != null) #sessionId: sessionId,
        if (positionX != null) #positionX: positionX,
        if (positionY != null) #positionY: positionY,
        if (health != null) #health: health
      }));
  @override
  PlayerModel $make(CopyWithData data) => PlayerModel(
      data.get(#id, or: $value.id),
      data.get(#sessionId, or: $value.sessionId),
      data.get(#positionX, or: $value.positionX),
      data.get(#positionY, or: $value.positionY),
      health: data.get(#health, or: $value.health));

  @override
  PlayerModelCopyWith<$R2, PlayerModel, $Out2> $chain<$R2, $Out2>(
          Then<$Out2, $R2> t) =>
      _PlayerModelCopyWithImpl($value, $cast, t);
}
