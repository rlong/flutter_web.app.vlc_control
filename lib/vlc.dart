



import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:logging/logging.dart';




class MapHelper {


  static T get<T>( Map map, String key ) {
    return map[key];
  }

}

class AudioFilters {


  Map value;

  AudioFilters( {this.value} ) {}
}


class Category {

  Map value;

  CategoryMeta _meta;


  Category( {this.value} ) {}

  getMeta() {
    if( null != _meta ) {
      return _meta;
    }

    _meta = new CategoryMeta( value: this.value["meta"] );
    return _meta;
  }

}

class CategoryMeta {

  Map value;

  String artist;
  String filename;
  String downloadURL;
  String albumURL;
  String title;
  String url;
  String artworkUrl;

  CategoryMeta( {this.value} ) {

    artist = MapHelper.get<String>( value, "artist");
    filename = MapHelper.get<String>( value, "filename" );
    downloadURL  = MapHelper.get<String>( value, "Download URL" );
    albumURL = MapHelper.get<String>( value, "Album URL" );
    title = MapHelper.get<String>( value, "title" );
    url = MapHelper.get<String>( value, "url" );
    artworkUrl = MapHelper.get<String>( value, "artwork_url" );
  }
}

class Information {

  Map value;

  Category _category;
  int chapter;
  List<int> chapters;
  int title;
  List titles;


  Information( {this.value} ) {


    chapter = MapHelper.get<int>( value, "chapter");
    chapters = MapHelper.get<List<int>>( value, "chapters");
    title = MapHelper.get<int>( value, "title");
    titles = MapHelper.get<List>( value, "titles");

  }

  getCategory() {
    if( null != _category ) {
      return _category;
    }

    _category = new Category( value: this.value["category"] );
    return _category;
  }

}

class Status  {

  Map _value;

  int apiversion;
  int audiodelay;
  AudioFilters _audiofilters;
  int currentplid;
  List equalizer;
//  bool _fullscreen;
  Information _information;
  int length;
  bool loop;
  double position;
  bool random;
  int rate;
  String state;
  int time;
  VideoEffects _videoeffects;
  String version;
  int volume;

  Status( Map value ) {

    _value = value;

    apiversion = MapHelper.get<int>( value, "apiversion" );
    audiodelay = MapHelper.get<int>( value, "audiodelay" );
    currentplid = MapHelper.get<int>( value, "currentplid" );
    equalizer = MapHelper.get<List>( value, "equalizer" );
//    _fullscreen = MapHelper.get<bool>( value, "fullscreen" );
    length = MapHelper.get<int>( value, "length" );
    loop = MapHelper.get<bool>( value, "loop" );
    position = MapHelper.get<double>( value, "position" );
    random = MapHelper.get<bool>( value, "random" );
    rate = MapHelper.get<int>( value, "rate" );
    state = MapHelper.get<String>( value, "state" );
    time = MapHelper.get<int>( value, "time" );
    version = MapHelper.get<String>( value, "version" );
    volume = MapHelper.get<int>( value, "volume" );
  }


}

class VideoEffects {

  Map value;

  int gamma;
  int contrast;
  int saturation;
  int brightness;
  int hue;

  VideoEffects( {this.value}) {

    gamma = MapHelper.get<int>( value, "gamma" );
    contrast = MapHelper.get<int>( value, "contrast" );
    saturation = MapHelper.get<int>( value, "saturation");
    brightness = MapHelper.get<int>( value, "brightness");
    hue = MapHelper.get<int>( value, "hue");
  }

}



enum NodeType {
  leaf,
  node
}



class Node {

  NodeType type = NodeType.node;
  Map value;
  String name;
  String id;

  List<Node> _children;

  Node( {this.value} ) {

    name = MapHelper.get<String>( value, "name" );
    id = MapHelper.get<String>( value, "id" );
  }

  List<Node> getChildren() {

    if( this.type == NodeType.leaf ) {

      return [];
    }

    if( null == _children ) {
      List<Map> childNodes = MapHelper.get<List<Map>>( value , "children");
      _children = childNodes.map( (e) {
        if( "node" == e["type"]) {

          return new Node( value: e );
        } else {

          return new LeafNode( e );
        }
      } ).toList(growable: false);
    }

    return _children;

  }

  getCurrent() {

    return this.getChildren().firstWhere( (e) {
      if( NodeType.leaf == e.type ) {
        LeafNode leaf = e as LeafNode;
        return leaf.current;
      }

      return false;
    } );
  }
}

class LeafNode extends Node {

  int duration;
  String uri;
  bool current;

  LeafNode( Map value ): super( value:value ) {

    type = NodeType.leaf;

    duration = MapHelper.get<int>( value, "duration" );
    uri = MapHelper.get<String>( value, "uri" );

    if( null == MapHelper.get<String>( value, "current") ) {

      current = true;
    } else {

      current = false;
    }
  }

}



class Playlist {

  LeafNode _current;
  bool _curentResolved = false;
  Node root;

  Playlist(Map value ) {

    root = new Node( value: value );
  }

  getCurrent() {

    if( !_curentResolved ) {

      _current = root.getCurrent();
      _curentResolved = true;
    }

    return _current;
  }
}




// vvv VAVlcHttpService.m
class VlcProxy {


  static final Logger log = new Logger('VlcProxy');

//  var _httpClient = createHttpClient();
  var _baseStatusUrl;
  var _playlistUrl;

  var headers = {'Authorization': 'Basic OnZsY3JlbW90ZQ=='};


  VlcProxy() {

    var baseUrl = 'http://127.0.0.1:8080';
    _baseStatusUrl = '$baseUrl/requests/status.json';
    _playlistUrl = '$baseUrl/requests/playlist.json';
  }


  Future<Status> playPause() async  {

    var url = "$_baseStatusUrl?command=pl_pause";
    return _dispatchStatusRequest( url );
  }

  Future<Status> pl_play( LeafNode leafNode ) async  {

    var url = "$_baseStatusUrl?command=pl_play&id=${leafNode.id}";
    return _dispatchStatusRequest( url );
  }


  Future<Status> playlistNext() async  {

    var url = "$_baseStatusUrl?command=pl_next";
    return _dispatchStatusRequest( url );
  }

  Future<Status> playlistPrevious() async  {

    var url = "$_baseStatusUrl?command=pl_previous";
    return _dispatchStatusRequest( url );
  }


  Future<Playlist> playlist() async  {

    // var response = await _httpClient.get( _playlistUrl, headers: headers );
    var response = await http.get( _playlistUrl, headers: headers );
    print( response.body );
    Map value = json.decode(response.body);
    return new Playlist( value );
  }



  Future<Status> setVolume( int volume ) async {

    if( 0 > volume  ) {

      log.warning( '0 > volume; volume = $volume' );
      volume = 0;
    } else if ( 320 < volume ) {

      log.warning( '320 < volume; volume = $volume' );
      volume = 320;
    }

    var url = "$_baseStatusUrl?command=volume&val=$volume";


    return this._dispatchStatusRequest( url );
  }

  Future<Status> seek( int position ) async {

    if( 0 > position  ) {

      log.warning( '0 > position; position = $position' );
      position = 0;
    }

    var url = "$_baseStatusUrl?command=seek&val=$position";
    return _dispatchStatusRequest( url );

  }


  Future<Status> status() async {

    return this._dispatchStatusRequest( _baseStatusUrl );
  }


  Future<Status> toggleFullScreen() async  {

    var url = "$_baseStatusUrl?command=fullscreen";
    return _dispatchStatusRequest( url );
  }


  _dispatchStatusRequest( String url ) async {

    //var response = await _httpClient.get( url, headers: headers );
    var response = await http.get( url, headers: headers );
    // print( response.body );
    Map value = json.decode(response.body);
    var answer = new Status( value );
    return answer;
  }
}



class VlcService {

  static final Logger log = new Logger('VlcService');

  VlcProxy proxy;
  Status lastStatus;
  int unMutedVolume;
  bool muted = false;

  VlcService( {this.proxy} ) {}



  Future<Status> _handle( Future<Status> futureStatus ) async {

    lastStatus = await futureStatus;

    if( !muted ) {

      unMutedVolume = lastStatus.volume;
    }
    return futureStatus;

  }


  Future<Status> playPause() async {
    return this._handle( proxy.playPause() );
  }



  Future<Status> pl_play( LeafNode leafNode ) async  {

    return this._handle( proxy.pl_play( leafNode ) );
  }

  Future<Status> playlistNext() async {

    return this._handle( proxy.toggleFullScreen() );
  }


  Future<Status> playlistPrevious() async {

    return this._handle( proxy.toggleFullScreen() );
  }

  Future<Playlist> playlist() async {

    return proxy.playlist();
  }



  Future<Status> skipBackward( int delta ) async {



//    if( null == lastStatus ) {
//
//      log.warning( "null == lastStatus" );
//      await this.status();
//    }

    await this.status();
    var time = lastStatus.time - delta;
    if( 0 > time )  {
      time = 0;
    }

    return proxy.seek( time );
  }

  Future<Status> skipForward( int delta ) async {

//    if( null == lastStatus ) {
//
//      log.warning( "null == lastStatus" );
//      await this.status();
//    }

    await this.status();
    var time = lastStatus.time + delta;
    if( lastStatus.length <= time )  {
      time = lastStatus.length - 1;
    }

    return proxy.seek( time );
  }


  Future<Status> setVolume( int volume ) async {

    return this._handle( proxy.setVolume( volume ) );
  }

  Future<Status> status() async {

    return this._handle( proxy.status() );
  }

  Future<Status> toggleFullScreen() async {

    return this._handle( proxy.toggleFullScreen() );
  }

  Future<Status> toggleMute() async {

    if( muted ) {

      muted = false;
      return this.setVolume( unMutedVolume );
    } else {

      muted = true;
      return this.setVolume( 0 );
    }
  }

}

