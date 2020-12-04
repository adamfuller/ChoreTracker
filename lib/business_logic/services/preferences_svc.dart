part of business_logic;

class PreferencesSvc{
  PreferencesSvc _instance;
  SharedPreferences _prefs;

  PreferencesSvc(){
     SharedPreferences.getInstance().then((value) => _prefs = value);
  }
  
  PreferencesSvc getInstance(){
    if (_instance == null){
      _instance = PreferencesSvc();
    }
    return _instance;
  }

  String getString(String key){
    if (_prefs == null){
      SharedPreferences.getInstance().then((value) => _prefs ??= value);
      return null;
    }

    return _prefs.getString(key);
  }
  
}

