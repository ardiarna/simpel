import 'package:simpel/utils/af_convert.dart';

class User {
  String nik;
  String username;
  String photoUrl;
  bool active;
  DateTime? lastseen;
  String kategori;
  String _idn = '';
  String get idn => _idn;

  User({
    this.nik = '',
    this.username = '',
    this.photoUrl = '',
    this.active = false,
    this.lastseen,
    this.kategori = '',
  });

  factory User.dariMap(Map<String, dynamic> map) {
    final user = User(
      nik: AFconvert.keString(map['nik']),
      username: AFconvert.keString(map['username']),
      photoUrl: AFconvert.keString(map['photo_url']),
      active: AFconvert.keBool(map['active']),
      lastseen: AFconvert.keTanggal(map['last_seen']),
      kategori: AFconvert.keString(map['kategori']),
    );
    user._idn = AFconvert.keString(map['id']);
    return user;
  }

  Map<String, String> keMap() {
    Map<String, String> map = {
      'nik': nik,
      'username': username,
      'photo_url': photoUrl,
      'active': AFconvert.keString(active),
      'last_seen': AFconvert.keString(lastseen),
      'kategori': kategori,
    };
    return map;
  }

  bool operator ==(Object other) => other is User && other.idn == idn;

  int get hashCode => idn.hashCode;
}
