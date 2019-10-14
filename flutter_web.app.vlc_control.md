


Session Setup
=============


```
export PATH=$PATH:"$HOME/Applications/flutter/bin":"$HOME/Applications/flutter/.pub-cache/bin":"$HOME/Applications/flutter/bin/cache/dart-sdk/bin"
export VLC_CTRL_BASE="$HOME/Projects/flutter_web.app.vlc_control"
export VLC_CTRL_HOME=$VLC_CTRL_BASE
cd $VLC_CTRL_HOME
```


```
export PATH="$PATH":"$HOME/Applications/flutter/bin":"$HOME/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin":$HOME/Applications/flutter/bin/cache/dart-sdk/bin
```

```
/home/lrlong/Applications/flutter/bin
:/home/lrlong/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin
:/home/lrlong/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin
:/home/lrlong/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin
:/home/lrlong/Applications/flutter/bin/cache/dart-sdk/bin
```


Development
===========


```
cd $VLC_CTRL_HOME
webdev serve
```

```
http://127.0.0.1:8080
```

System Setup (Linux)
====================

* Install 'flutter'

* Intsall 'webdev' (https://github.com/flutter/flutter_web)

```
flutter pub global activate webdev
```

... get the warning ...

```
Warning: Pub installs executables into $HOME/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin, which is not on your path.
You can fix that by adding this to your shell's config file (.bashrc, .bash_profile, etc.):

export PATH="$PATH":"$HOME/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin"
```


-------------------------------------------------------------------------------


https://github.com/flutter/flutter_web

```
cd ~/Applications/flutter/examples/hello_world
webdev serve 
```

... get ...

```
/home/lrlong/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin/webdev: 7: /home/lrlong/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin/webdev: dart: not found
```

https://github.com/flutter/flutter/issues/32279 

... add `flutter/bin/cache/dart-sdk/bin` to the path ...

```
export PATH="$PATH":"$HOME/Applications/flutter_linux_v1.9.1+hotfix.2-stable/.pub-cache/bin":/home/lrlong/Applications/flutter/bin/cache/dart-sdk/bin
```

Project Setup
=============

```
pub get
```
