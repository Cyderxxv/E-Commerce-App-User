import 'package:shared_preferences/shared_preferences.dart';

class StoreData implements _CacheKey {
  static final StoreData instant = StoreData._internal();
  StoreData._internal();

  late SharedPreferences pref;

  Future<void> initCache() async {
    pref = await SharedPreferences.getInstance();
  }

  String get token {
    try {
      return pref.getString(_CacheKey.token) ?? '';
    } catch (e) {
      print('❌ Error getting token from SharedPreferences: $e');
      return '';
    }
  }
  
  Future<void> setToken(String token) async {
    try {
      print('💾 StoreData: Saving token (${token.length} chars)');
      await pref.setString(_CacheKey.token, token);
      print('✅ StoreData: Token saved successfully');
    } catch (e) {
      print('❌ StoreData: Error saving token: $e');
      throw e;
    }
  }

  String get refreshToken => pref.getString(_CacheKey.refreshToken) ?? '';
  Future<void> setRefreshToken(String refreshToken) =>
      pref.setString(_CacheKey.refreshToken, refreshToken);

  Future removeAllCache() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove(_CacheKey.token);
    await preferences.remove(_CacheKey.refreshToken);
  }
}

abstract class _CacheKey {
  _CacheKey._internal();
  static const String token = "xToken";
  static const String refreshToken = "xTokenRefresh";
}