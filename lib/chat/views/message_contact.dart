import 'package:flutter/material.dart';
import 'package:simpel/chat/blocs/message_contact_bloc.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/user_service.dart';
import 'package:simpel/chat/views/profil_image.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/utils/af_widget.dart';

class MessageContact extends StatefulWidget {
  final MemberModel member;

  const MessageContact({required this.member, Key? key}) : super(key: key);

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
          ContactPSM(member: widget.member),
          ContactPeserta(member: widget.member),
        ]),
      ),
    );
  }
}

class ContactPSM extends StatefulWidget {
  final MemberModel member;

  const ContactPSM({required this.member, Key? key}) : super(key: key);

  @override
  _ContactPSMState createState() => _ContactPSMState();
}

class _ContactPSMState extends State<ContactPSM> {
  final MessageContactBloc _messageContactBloc = MessageContactBloc();
  final UserService _userService = UserService();

  @override
  void dispose() {
    _messageContactBloc.dispose();
    super.dispose();
  }

  Future<List<PersonPSMModel>> getListPSM() async {
    List<PersonPSMModel> list = [];
    var listLatih = await _messageContactBloc.getPelatihans(widget.member);
    for (var latih in listLatih) {
      var listPerson = await _messageContactBloc.getPSM(latih.kode);
      for (var person in listPerson) {
        if (person.nik != widget.member.nik) {
          person.posisi =
              '${person.posisi} ${latih.singkatan} ${latih.angkatan} - ${latih.tahun}';
          list.add(person);
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PersonPSMModel>>(
      future: getListPSM(),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!.length > 0) {
            return tabPSM(snap.data!);
          } else {
            return Center(
              child: Text('PSM tidak ditemukan'),
            );
          }
        } else {
          return Center(
            child: AFwidget.circularProgress(),
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
              _messageContactBloc.fetchPSM(_listFilterPSM);
            },
          ),
        ),
        StreamBuilder<List<PersonPSMModel>>(
          stream: _messageContactBloc.streamPSM,
          builder: (context, snapPSM) {
            if (snapPSM.hasData) {
              if (snapPSM.data!.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return ListTile(
                      contentPadding: EdgeInsets.only(left: 16),
                      dense: true,
                      leading: ProfilImage(
                        imageUrl: snapPSM.data![i].foto != ''
                            ? _messageContactBloc.dirImageTeam +
                                snapPSM.data![i].foto
                            : '',
                        online: false,
                      ),
                      title: Text(snapPSM.data![i].nama),
                      subtitle: Text(snapPSM.data![i].posisi),
                      onTap: () async {
                        var a =
                            await _userService.fetch([snapPSM.data![i].nik]);
                        if (a.first.nik != '') {
                          Navigator.of(context).pop(a);
                        } else {
                          var b = User(
                            nik: snapPSM.data![i].nik,
                            username: snapPSM.data![i].nama,
                            photoUrl: snapPSM.data![i].foto,
                            active: false,
                            lastseen: DateTime(2021),
                            kategori: 'team',
                          );
                          var c = await _userService.create(b);
                          Navigator.of(context).pop([c]);
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
                _messageContactBloc.fetchPSM(el);
              } else {
                _messageContactBloc.fetchPSM(_listPSM);
              }
              return SliverToBoxAdapter(child: AFwidget.circularProgress());
            }
          },
        ),
      ],
    );
  }
}

class ContactPeserta extends StatefulWidget {
  final MemberModel member;

  const ContactPeserta({required this.member, Key? key}) : super(key: key);

  @override
  _ContactPesertaState createState() => _ContactPesertaState();
}

class _ContactPesertaState extends State<ContactPeserta> {
  final MessageContactBloc _messageContactBloc = MessageContactBloc();
  final UserService _userService = UserService();

  @override
  void dispose() {
    _messageContactBloc.dispose();
    super.dispose();
  }

  Future<List<PersonPesertaModel>> getListPeserta() async {
    List<PersonPesertaModel> list = [];
    var listLatih = await _messageContactBloc.getPelatihans(widget.member);
    for (var latih in listLatih) {
      var listPerson = await _messageContactBloc.getPeserta(latih.kode);
      for (var person in listPerson) {
        if (person.nik != widget.member.nik) {
          person.kedudukan =
              '${latih.singkatan} ${latih.angkatan} - ${latih.tahun}';
          list.add(person);
        }
      }
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<PersonPesertaModel>>(
      future: getListPeserta(),
      builder: (context, snap) {
        if (snap.hasData) {
          if (snap.data!.length > 0) {
            return tabPeserta(snap.data!);
          } else {
            return Center(
              child: Text('Peserta tidak ditemukan'),
            );
          }
        } else {
          return Center(
            child: AFwidget.circularProgress(),
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
              _messageContactBloc.fetchPeserta(_listFilterPeserta);
            },
          ),
        ),
        StreamBuilder<List<PersonPesertaModel>>(
          stream: _messageContactBloc.streamPeserta,
          builder: (context, snapPeserta) {
            if (snapPeserta.hasData) {
              if (snapPeserta.data!.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return ListTile(
                      contentPadding: EdgeInsets.only(left: 16),
                      dense: true,
                      leading: ProfilImage(
                        imageUrl: snapPeserta.data![i].foto != ''
                            ? _messageContactBloc.dirImageMember +
                                snapPeserta.data![i].foto
                            : '',
                        online: false,
                      ),
                      title: Text(snapPeserta.data![i].nama),
                      subtitle: Text(snapPeserta.data![i].kedudukan),
                      onTap: () async {
                        var a = await _userService
                            .fetch([snapPeserta.data![i].nik]);
                        if (a.first.nik != '') {
                          Navigator.of(context).pop(a);
                        } else {
                          var b = User(
                            nik: snapPeserta.data![i].nik,
                            username: snapPeserta.data![i].nama,
                            photoUrl: snapPeserta.data![i].foto,
                            active: false,
                            lastseen: DateTime(2021),
                            kategori: 'member',
                          );
                          var c = await _userService.create(b);
                          Navigator.of(context).pop([c]);
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
                _messageContactBloc.fetchPeserta(el);
              } else {
                _messageContactBloc.fetchPeserta(_listPeserta);
              }
              return SliverToBoxAdapter(child: AFwidget.circularProgress());
            }
          },
        ),
      ],
    );
  }
}
