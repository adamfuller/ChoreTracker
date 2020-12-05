part of business_logic;

class PreferencesSvc{
  static PreferencesSvc _instance;
  static SharedPreferences _prefs;
  static Map<String, dynamic> _cache;

  PreferencesSvc(){
    if (_prefs == null){
      init();
    }
  }

  static Future<bool> init() async {
    _prefs ??= await SharedPreferences.getInstance();
    _instance ??= PreferencesSvc();
    _cache ??= Map();
    return true;
  }
  
  PreferencesSvc getInstance(){
    _instance ??= PreferencesSvc();
    return _instance;
  }

  Future<bool> setString(String key, String value) async {
    Completer<bool> output = Completer();
    _cache[key] = value;

    if (_prefs == null){
      init().then((v) => setString(key, value));
    }
    _prefs?.setString(key, value)?.then((e){
      output.complete(true);
      _cache.remove(key);
    }, onError: (e){
      output.complete(false);
      _cache.remove(key);
    });


    return output.future;
  }

  String getString(String key){
    return _cache.containsKey(key) ? _cache[key] : _prefs?.getString(key);
  }
  
}

