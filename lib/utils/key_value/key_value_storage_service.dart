import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KVKeys {
  const KVKeys._();

  static const String theme = 'theme';
  static const String volume = 'volume';
  static const String isMuted = 'isMuted';
}

class KeyValueStorageService {
  SharedPreferences? _sharedPreferences;
  SharedPreferences get sharedPreferences => _sharedPreferences!;

  Future<Either<Exception, String>> get(String key) async {
    await _initSharedPreferencesIfNeeded();

    final value = sharedPreferences.getString(key);
    if (value != null) {
      return Right(value);
    }
    return Left(Exception());
  }

  Future<Either<Exception, bool>> getBool(String key) async {
    await _initSharedPreferencesIfNeeded();

    final value = sharedPreferences.getBool(key);
    if (value != null) {
      return Right(value);
    }
    return Left(Exception());
  }

  Future<Either<Exception, T>> getWithFormat<T>(
    String key,
    T Function(String value) formatter,
  ) async {
    final value = await get(key);
    return value.fold(
      left,
      (r) => right(formatter(r)),
    );
  }

  Future<Either<Exception, List<String>>> getList(String key) async {
    await _initSharedPreferencesIfNeeded();

    final value = sharedPreferences.getStringList(key);
    if (value != null) {
      return Right(value);
    }
    return Left(Exception());
  }

  Future<void> remove(String key) async {
    await _initSharedPreferencesIfNeeded();

    await sharedPreferences.remove(key);
  }

  Future<void> set(String key, String value) async {
    await _initSharedPreferencesIfNeeded();

    await sharedPreferences.setString(key, value);
  }

  Future<void> setBool(String key, bool value) async {
    await _initSharedPreferencesIfNeeded();

    await sharedPreferences.setBool(key, value);
  }

  Future<void> setList(String key, List<String> value) async {
    await _initSharedPreferencesIfNeeded();

    await sharedPreferences.setStringList(key, value);
  }

  Future<void> clear() async {
    await _initSharedPreferencesIfNeeded();

    await sharedPreferences.clear();
  }

  Future<void> _initSharedPreferencesIfNeeded() async {
    _sharedPreferences ??= await SharedPreferences.getInstance();
  }
}
