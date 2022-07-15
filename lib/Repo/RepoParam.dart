import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:w_5/DataF/paramsCrud.dart';

class RepoParam with ChangeNotifier, DiagnosticableTreeMixin {
  bool _IsLightTheme = true;

  bool getTheme() {
    // try {
    //   String strValue = paramsCrud.getParam('theme');
    //   int y = 0;
    //   if (strValue == 'light') {
    //     _IsLightTheme = true;
    //     notifyListeners();
    //   } else if (strValue == 'dark') {
    //     _IsLightTheme = false;
    //     notifyListeners();
    //   }
    // } catch (e) {
    //   print(e);
    // }
    return _IsLightTheme;
  }

  changeTheme() {
    _IsLightTheme = !_IsLightTheme;
    notifyListeners();
    // try {
    //   if (_IsLightTheme) {
    //     paramsCrud.updParam('theme', 'light');
    //   } else {
    //     paramsCrud.updParam('theme', 'dart');
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }

  setTheme(bool NewTheme) {
    _IsLightTheme = NewTheme;
    notifyListeners();

    // try {
    //   if (_IsLightTheme) {
    //     paramsCrud.updParam('theme', 'light');
    //   } else {
    //     paramsCrud.updParam('theme', 'dart');
    //   }
    // } catch (e) {
    //   print(e);
    // }
  }
}
