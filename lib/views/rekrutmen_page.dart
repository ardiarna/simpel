import 'package:flutter/material.dart';
import 'package:simpel/blocs/bumdes_bloc.dart';
import 'package:simpel/blocs/rekrutmen_bloc.dart';
import 'package:simpel/chat/data/datasource_contract.dart';
import 'package:simpel/chat/data/sqflite_datasource.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/message_group_model.dart';
import 'package:simpel/chat/services/group_service.dart';
import 'package:simpel/chat/services/user_service.dart';
import 'package:simpel/chat/services/user_service_contract.dart';
import 'package:simpel/chat/viewmodels/chats_view_model.dart';
import 'package:simpel/chat/views/color_generator.dart';
import 'package:simpel/models/bumdes_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/utils/db_factory.dart';
import 'package:simpel/views/bumdes_page.dart';
import 'package:simpel/views/home_page.dart';
import 'package:sqflite/sqflite.dart';

class RekrutmenPage extends StatefulWidget {
  final MemberModel member;
  const RekrutmenPage({required this.member, Key? key}) : super(key: key);

  @override
  _RekrutmenPageState createState() => _RekrutmenPageState();
}

class _RekrutmenPageState extends State<RekrutmenPage> {
  final RekrutmenBloc _rekrutmenBloc = RekrutmenBloc();
  final BumdesBloc _bumdesBloc = BumdesBloc();
  late BumdesModel _bumdesModel;
  late KedudukanModel _kedudukanModel;

  cekBumdes() {
    _bumdesBloc.get(widget.member.nik).then((bumdes) {
      if (bumdes.nama == '') {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (_) {
            return AlertDialog(
              elevation: 0,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Anda belum mengisi Data Bumdes,'),
                  Text('silakan isi data bumdes terlebih dahulu.'),
                ],
              ),
              actions: [
                ElevatedButton(
                  child: const Text('Batal'),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.orange.shade400,
                  ),
                  onPressed: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                        builder: (context) => HomePage(
                          menu: 0,
                          page: 'beranda',
                          member: widget.member,
                        ),
                      ),
                    );
                  },
                ),
                ElevatedButton(
                  child: const Text('Isi Data Bumdes'),
                  onPressed: () async {
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => BumdesTab(
                          nik: widget.member.nik,
                        ),
                      ),
                    );
                    Navigator.of(context).pop();
                    cekBumdes();
                  },
                ),
              ],
            );
          },
        );
      } else {
        _bumdesModel = bumdes;
        _bumdesBloc
            .getKedudukan(widget.member.nik)
            .then((value) => _kedudukanModel = value);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    cekBumdes();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverPadding(padding: EdgeInsets.all(5)),
        FutureBuilder<List<RekrutmenModel>>(
          future: _rekrutmenBloc.getRekrutmens(),
          builder: (context, snap) {
            if (snap.hasData) {
              return SliverList(
                delegate: SliverChildBuilderDelegate((context, i) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    padding: const EdgeInsets.fromLTRB(10, 10, 10, 5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          spreadRadius: 0.5,
                          blurRadius: 1,
                          offset: const Offset(1, 1),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: Colors.green,
                          padding: const EdgeInsets.all(7),
                          margin: const EdgeInsets.only(bottom: 15),
                          width: double.infinity,
                          child: Column(
                            children: [
                              const Align(
                                child: Text(
                                  'Kegiatan : ',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                alignment: Alignment.topLeft,
                              ),
                              Text(
                                '${snap.data![i].nmgiat} (${snap.data![i].singkatangiat})',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            const Text('Tahun : '),
                            Text(
                              snap.data![i].tahun.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Padding(padding: EdgeInsets.only(right: 25)),
                            const Text('Angkatan : '),
                            Text(
                              snap.data![i].angkatan.toString(),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 15)),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 20,
                              color: Colors.green,
                            ),
                            const Padding(padding: EdgeInsets.only(right: 5)),
                            const Text('Tanggal : '),
                            Text(
                              AFconvert.matDate(snap.data![i].tglMulai),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Text(' s/d '),
                            Text(
                              AFconvert.matDate(snap.data![i].tglSelesai),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const Padding(padding: EdgeInsets.only(bottom: 10)),
                        Row(
                          children: const [
                            Icon(
                              Icons.location_on_outlined,
                              size: 20,
                              color: Colors.green,
                            ),
                            Padding(padding: EdgeInsets.only(right: 5)),
                            Text('Lokasi : '),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.fromLTRB(25, 5, 0, 10),
                          child: Text(
                            '${snap.data![i].dusun} KEL/DESA : ${snap.data![i].kelLabel}, KEC : ${snap.data![i].kecLabel}, KAB : ${snap.data![i].kabLabel}, PROV : ${snap.data![i].provLabel}.',
                            maxLines: 4,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        FutureBuilder<Map<String, dynamic>>(
                          future: _rekrutmenBloc.cekDaftar(
                              widget.member.nik, snap.data![i].kdgiat),
                          builder: (context, snapCek) {
                            if (snapCek.hasData) {
                              String label = "Daftar";
                              bool disable = false;
                              if (snapCek.data!['sudah_daftar'] == 'Y') {
                                disable = true;
                                if (snapCek.data!['tahun'].toString() ==
                                        snap.data![i].tahun.toString() &&
                                    snapCek.data!['angkatan'].toString() ==
                                        snap.data![i].angkatan.toString()) {
                                  label = 'Sudah terdaftar';
                                } else {
                                  label =
                                      'Sudah terdaftar pada tahun ${snapCek.data!['tahun']} angkatan ${snapCek.data!['angkatan']}';
                                }
                              }
                              return Align(
                                alignment: Alignment.topRight,
                                child: ElevatedButton(
                                  child: Text(label),
                                  style: TextButton.styleFrom(
                                    backgroundColor: disable
                                        ? Colors.white
                                        : Colors.tealAccent.shade400,
                                  ),
                                  onPressed: disable
                                      ? null
                                      : () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  RekrutmenForm(
                                                member: widget.member,
                                                bumdes: _bumdesModel,
                                                kedudukan: _kedudukanModel,
                                                rekrutmen: snap.data![i],
                                              ),
                                            ),
                                          );
                                        },
                                ),
                              );
                            } else {
                              return Container();
                            }
                          },
                        )
                      ],
                    ),
                  );
                }, childCount: snap.data!.length),
              );
            } else {
              return SliverToBoxAdapter(child: AFwidget.circularProgress());
            }
          },
        ),
      ],
    );
  }
}

class RekrutmenForm extends StatefulWidget {
  final MemberModel member;
  final BumdesModel bumdes;
  final KedudukanModel kedudukan;
  final RekrutmenModel rekrutmen;

  const RekrutmenForm({
    required this.member,
    required this.bumdes,
    required this.kedudukan,
    required this.rekrutmen,
    Key? key,
  }) : super(key: key);

  @override
  _RekrutmenFormState createState() => _RekrutmenFormState();
}

class _RekrutmenFormState extends State<RekrutmenForm> {
  final RekrutmenBloc _rekrutmenBloc = RekrutmenBloc();
  // final TextEditingController _txtKendala = TextEditingController();
  late FocusNode _focKendala;

  @override
  void initState() {
    super.initState();
    _focKendala = FocusNode();
  }

  @override
  void dispose() {
    _focKendala.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double lebarA = 100;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rekrutmen Calon Peserta'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(width: lebarA, child: const Text('Kegiatan')),
                        const Text(' : '),
                        Expanded(
                          child: Text(
                            '${widget.rekrutmen.nmgiat} (${widget.rekrutmen.singkatangiat})',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),
                    Row(
                      children: [
                        SizedBox(width: lebarA, child: const Text('Tahun')),
                        const Text(' : '),
                        Text(
                          widget.rekrutmen.tahun.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 25)),
                        const Text('Angkatan : '),
                        Text(
                          widget.rekrutmen.angkatan.toString(),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),
                    Row(
                      children: [
                        const Icon(
                          Icons.calendar_today_outlined,
                          size: 20,
                          color: Colors.green,
                        ),
                        const Padding(padding: EdgeInsets.only(right: 5)),
                        const Text('Tanggal : '),
                        Text(
                          AFconvert.matDate(widget.rekrutmen.tglMulai),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(' s/d '),
                        Text(
                          AFconvert.matDate(widget.rekrutmen.tglSelesai),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 10)),
                    Row(
                      children: const [
                        Icon(
                          Icons.location_on_outlined,
                          size: 20,
                          color: Colors.green,
                        ),
                        Padding(padding: EdgeInsets.only(right: 5)),
                        Text('Lokasi : '),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(25, 5, 0, 10),
                      child: Text(
                        '${widget.rekrutmen.dusun} KEL/DESA : ${widget.rekrutmen.kelLabel}, KEC : ${widget.rekrutmen.kecLabel}, KAB : ${widget.rekrutmen.kabLabel}, PROV : ${widget.rekrutmen.provLabel}.',
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        SizedBox(width: lebarA, child: const Text('NIK')),
                        const Text(' : '),
                        Text(
                          widget.member.nik,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(bottom: 15)),
                    Row(
                      children: [
                        SizedBox(width: lebarA, child: const Text('Nama')),
                        const Text(' : '),
                        Text(
                          widget.member.nama,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              (widget.rekrutmen.kdgiat == '001' ||
                      widget.rekrutmen.kdgiat == '01')
                  ? Container(
                      margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Nama Bumdes')),
                              const Text(' : '),
                              Text(
                                widget.bumdes.nama,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Tahun Berdiri')),
                              const Text(' : '),
                              Text(
                                widget.bumdes.tahun.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Unit Usaha')),
                              const Text(' : '),
                              Text(
                                widget.bumdes.unitusaha,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Omzet per tahun')),
                              const Text(' : '),
                              Text(
                                widget.bumdes.omset,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Jabatan dalam Bumdes')),
                              const Text(' : '),
                              Text(
                                widget.bumdes.jabatan,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Periode Jabatan')),
                              const Text(' : '),
                              Text(
                                widget.bumdes.jabperiode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Kendala / Permasalahan')),
                              const Text(' : '),
                              Text(
                                widget.bumdes.kendala,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : Container(
                      margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
                      padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text(
                                      'Jabatan / Kedudukan di Desa')),
                              const Text(' : '),
                              Text(
                                widget.kedudukan.jabatan,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Periode Jabatan')),
                              const Text(' : '),
                              Text(
                                widget.kedudukan.periode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
              // Container(
              //   color: Colors.white,
              //   padding: EdgeInsets.only(
              //       bottom: MediaQuery.of(context).viewInsets.bottom),
              //   child: AFwidget.textField(
              //     context: context,
              //     kontroler: _txtKendala,
              //     focusNode: _focKendala,
              //     label: 'Kendala / Permasalahan',
              //     border: OutlineInputBorder(
              //         borderRadius: BorderRadius.circular(7)),
              //     suffix: const Icon(
              //       Icons.person,
              //       size: 20,
              //       color: Colors.transparent,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('Daftar'),
        onPressed: () async {
          AFwidget.circularDialog(context);
          var a = await _rekrutmenBloc.add(
            member: widget.member,
            bumdes: widget.bumdes,
            rekrutmen: widget.rekrutmen,
          );
          Navigator.of(context).pop();

          if (a['status'].toString() == '1') {
            MessageGroup messageGroup = MessageGroup(
              name:
                  '${widget.rekrutmen.singkatangiat} ${widget.rekrutmen.angkatan}-${widget.rekrutmen.tahun}',
              createdBy: widget.member.nik,
              members: [widget.member.nik],
              photoUrl: widget.rekrutmen.imagegiat,
            );
            Database _db = await LocalDatabaseFactory().createDatabase();
            IDataSource _dataSource = SqfLiteDataSource(_db);
            IUserService _userService = UserService();
            MessageGroupService messageGroupService = MessageGroupService();
            ChatsViewModel chatsViewModel =
                ChatsViewModel(_dataSource, _userService);
            MessageGroup msgrupFromServer =
                await messageGroupService.create(messageGroup);
            final membersId = msgrupFromServer.members
                .map((e) =>
                    {e: RandomColorGenerator.getColor().value.toString()})
                .toList();
            Chat chat = Chat(
              msgrupFromServer.id,
              ChatType.group,
              membersId: membersId,
              name: msgrupFromServer.name,
              photoUrl: msgrupFromServer.photoUrl,
            );
            await chatsViewModel.createNewChat(chat);
            await AFwidget.alertDialog(
              context,
              const Text('Terima kasih, anda berhasil melakukan pendaftaran!.'),
            );

            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(
                  menu: 1,
                  page: 'rekrutmen',
                  member: widget.member,
                ),
              ),
            );
          } else {
            AFwidget.alertDialog(context, Text(a['message'].toString()));
          }
        },
      ),
    );
  }
}
