import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/user_service.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/utils/af_widget.dart';

class MessageContact extends StatefulWidget {
  final String nik;

  const MessageContact({required this.nik, Key? key}) : super(key: key);

  @override
  _MessageContactState createState() => _MessageContactState();
}

class _MessageContactState extends State<MessageContact> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Pilih Kontak'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'PSM',
            ),
            Tab(
              text: 'Peserta',
            ),
          ]),
        ),
        body: TabBarView(children: [
          ContactPSM(nik: widget.nik),
          ContactPeserta(nik: widget.nik),
        ]),
      ),
    );
  }
}

class ContactPSM extends StatefulWidget {
  final String nik;

  const ContactPSM({required this.nik, Key? key}) : super(key: key);

  @override
  _ContactPSMState createState() => _ContactPSMState();
}

class _ContactPSMState extends State<ContactPSM> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();
  final UserService _userService = UserService();

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    super.dispose();
  }

  Future<List<PersonPSMModel>> getListPSM() async {
    List<PersonPSMModel> list = [];
    var listLatih = await _pelatihanBloc.getPelatihans(widget.nik);
    for (var latih in listLatih) {
      var giat = await _pelatihanBloc.getGiatId(latih.giatKode);
      var listPerson = await _pelatihanBloc.getPSM(latih.kode);
      for (var person in listPerson) {
        person.posisi =
            '${person.posisi} ${giat.singkatan} ${latih.angkatan} - ${latih.tahun}';
        list.add(person);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PersonPSMModel>>(
      future: getListPSM(),
      builder: (context, snap) {
        if (snap.hasData && snap.data!.length > 0) {
          return tabPSM(snap.data!);
        } else {
          return Center(
            child: Text('PSM tidak ditemukan'),
          );
        }
      },
    );
  }

  Widget tabPSM(List<PersonPSMModel> el) {
    List<PersonPSMModel> _listPSM = [];
    List<PersonPSMModel> _listFilterPSM = [];
    final TextEditingController _txtPSM = TextEditingController();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AFwidget.textField(
            context: context,
            label: 'Cari PSM...',
            kontroler: _txtPSM,
            padding: EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            onchanged: (value) {
              _listFilterPSM = [];
              for (var a in _listPSM) {
                bool cek = a.nama.toLowerCase().contains(value.toLowerCase());
                if (cek) {
                  _listFilterPSM.add(a);
                }
              }
              _pelatihanBloc.fetchPSM(_listFilterPSM);
            },
          ),
        ),
        StreamBuilder<List<PersonPSMModel>>(
          stream: _pelatihanBloc.streamPSM,
          builder: (context, snapPSM) {
            if (snapPSM.hasData) {
              if (snapPSM.data!.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return ListTile(
                      contentPadding: EdgeInsets.only(left: 16),
                      dense: true,
                      leading: _profileImage(
                        imageUrl: snapPSM.data![i].foto != ''
                            ? _pelatihanBloc.dirImageMember +
                                snapPSM.data![i].foto
                            : '',
                      ),
                      title: Text(snapPSM.data![i].nama),
                      subtitle: Text(snapPSM.data![i].posisi),
                      onTap: () async {
                        var a = await _userService.fetch(snapPSM.data![i].nik);
                        if (a.nik != '') {
                          Navigator.of(context).pop(a);
                        } else {
                          var b = User(
                            nik: snapPSM.data![i].nik,
                            username: snapPSM.data![i].nama,
                            photoUrl: snapPSM.data![i].foto,
                            active: false,
                            lastseen: DateTime(2021),
                          );
                          var c = await _userService.create(b);
                          Navigator.of(context).pop(c);
                        }
                      },
                    );
                  }, childCount: snapPSM.data!.length),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('PSM tidak ditemukan.'),
                  ),
                );
              }
            } else {
              if (_listPSM.length < 1) {
                _listPSM = el;
                _pelatihanBloc.fetchPSM(el);
              } else {
                _pelatihanBloc.fetchPSM(_listPSM);
              }
              return SliverToBoxAdapter(child: AFwidget.circularProgress());
            }
          },
        ),
      ],
    );
  }

  _profileImage({
    String imageUrl = '',
    bool online = false,
  }) =>
      CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(126),
              child: imageUrl != ''
                  ? AFwidget.cachedNetworkImage(
                      imageUrl,
                      width: 126,
                      height: 126,
                      fit: BoxFit.fill,
                    )
                  : Icon(
                      Icons.record_voice_over,
                      size: 25,
                    ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: online ? _onlineIndicator() : Container(),
            ),
          ],
        ),
      );

  _onlineIndicator() => Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 3,
            color: Colors.white,
          ),
        ),
      );

  Widget selKolom({
    String isi = '',
    Color warna = Colors.red,
    FontWeight fontWeight = FontWeight.normal,
    Color? backGround,
    Alignment align = Alignment.center,
  }) {
    return Container(
      color: backGround,
      alignment: align,
      padding: EdgeInsets.all(5),
      child: Text(
        isi,
        style: TextStyle(
          color: warna,
          fontWeight: fontWeight,
        ),
      ),
    );
  }
}

class ContactPeserta extends StatefulWidget {
  final String nik;

  const ContactPeserta({required this.nik, Key? key}) : super(key: key);

  @override
  _ContactPesertaState createState() => _ContactPesertaState();
}

class _ContactPesertaState extends State<ContactPeserta> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();
  final UserService _userService = UserService();

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    super.dispose();
  }

  Future<List<PersonPesertaModel>> getListPeserta() async {
    List<PersonPesertaModel> list = [];
    var listLatih = await _pelatihanBloc.getPelatihans(widget.nik);
    for (var latih in listLatih) {
      var giat = await _pelatihanBloc.getGiatId(latih.giatKode);
      var listPerson = await _pelatihanBloc.getPeserta(latih.kode);
      for (var person in listPerson) {
        person.posisi =
            '${person.posisi} ${giat.singkatan} ${latih.angkatan} - ${latih.tahun}';
        list.add(person);
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PersonPesertaModel>>(
      future: getListPeserta(),
      builder: (context, snap) {
        if (snap.hasData && snap.data!.length > 0) {
          return tabPeserta(snap.data!);
        } else {
          return Center(
            child: Text('Peserta tidak ditemukan'),
          );
        }
      },
    );
  }

  Widget tabPeserta(List<PersonPesertaModel> el) {
    List<PersonPesertaModel> _listPeserta = [];
    List<PersonPesertaModel> _listFilterPeserta = [];
    final TextEditingController _txtPeserta = TextEditingController();
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AFwidget.textField(
            context: context,
            label: 'Cari Peserta...',
            kontroler: _txtPeserta,
            padding: EdgeInsets.all(10),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
            onchanged: (value) {
              _listFilterPeserta = [];
              for (var a in _listPeserta) {
                bool cek = a.nama.toLowerCase().contains(value.toLowerCase());
                if (cek) {
                  _listFilterPeserta.add(a);
                }
              }
              _pelatihanBloc.fetchPeserta(_listFilterPeserta);
            },
          ),
        ),
        StreamBuilder<List<PersonPesertaModel>>(
          stream: _pelatihanBloc.streamPeserta,
          builder: (context, snapPeserta) {
            if (snapPeserta.hasData) {
              if (snapPeserta.data!.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return ListTile(
                      contentPadding: EdgeInsets.only(left: 16),
                      dense: true,
                      leading: _profileImage(
                        imageUrl: snapPeserta.data![i].foto != ''
                            ? _pelatihanBloc.dirImageMember +
                                snapPeserta.data![i].foto
                            : '',
                      ),
                      title: Text(snapPeserta.data![i].nama),
                      subtitle: Text(snapPeserta.data![i].posisi),
                      onTap: () async {
                        var a =
                            await _userService.fetch(snapPeserta.data![i].nik);
                        if (a.nik != '') {
                          Navigator.of(context).pop(a);
                        } else {
                          var b = User(
                            nik: snapPeserta.data![i].nik,
                            username: snapPeserta.data![i].nama,
                            photoUrl: snapPeserta.data![i].foto,
                            active: false,
                            lastseen: DateTime(2021),
                          );
                          var c = await _userService.create(b);
                          Navigator.of(context).pop(c);
                        }
                      },
                    );
                  }, childCount: snapPeserta.data!.length),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('Peserta tidak ditemukan.'),
                  ),
                );
              }
            } else {
              if (_listPeserta.length < 1) {
                _listPeserta = el;
                _pelatihanBloc.fetchPeserta(el);
              } else {
                _pelatihanBloc.fetchPeserta(_listPeserta);
              }
              return SliverToBoxAdapter(child: AFwidget.circularProgress());
            }
          },
        ),
      ],
    );
  }

  _profileImage({
    String imageUrl = '',
    bool online = false,
  }) =>
      CircleAvatar(
        backgroundColor: Colors.grey.shade300,
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(126),
              child: imageUrl != ''
                  ? AFwidget.cachedNetworkImage(
                      imageUrl,
                      width: 126,
                      height: 126,
                      fit: BoxFit.fill,
                    )
                  : Icon(
                      Icons.person,
                      size: 25,
                    ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: online ? _onlineIndicator() : Container(),
            ),
          ],
        ),
      );

  _onlineIndicator() => Container(
        height: 15,
        width: 15,
        decoration: BoxDecoration(
          color: Colors.green,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            width: 3,
            color: Colors.white,
          ),
        ),
      );
}
