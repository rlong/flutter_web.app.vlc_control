


import 'vlc.dart';

class SessionContext {

  static var instance = new SessionContext();
  var vlcService = new VlcService( proxy: new VlcProxy() );

}

