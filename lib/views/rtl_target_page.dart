import 'package:flutter/material.dart';
import 'package:simpel/blocs/rtl_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rtl_target_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';

class RTLtargetPage extends StatefulWidget {
  final MemberModel member;
  final PelatihanModel pelatihan;

  const RTLtargetPage({
    required this.member,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  _RTLtargetPageState createState() => _RTLtargetPageState();
}

class _RTLtargetPageState extends State<RTLtargetPage> {
  final RTLBloc _rtlBloc = RTLBloc();

  @override
  void dispose() {
    _rtlBloc.dispose();
    super.dispose();
  }

  void refresh() {
    _rtlBloc.getTargets(widget.member.nik, widget.pelatihan.kode).then((value) {
      _rtlBloc.fetchTarget(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => TargetForm(
                member: widget.member,
                pelatihan: widget.pelatihan,
              ),
            ),
          );
          refresh();
        },
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(padding: EdgeInsets.only(top: 1)),
          StreamBuilder<List<RTLtargetModel>>(
            stream: _rtlBloc.streamTarget,
            builder: (context, snapTarget) {
              if (snapTarget.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return Container(
                        padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border(
                            bottom: BorderSide(color: Colors.grey, width: 1),
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                          color: Colors.orange,
                                        ),
                                      ),
                                      Text(
                                        AFconvert.matDate(
                                          snapTarget.data![i].tanggal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 3),
                                    child: Text(
                                      'Rencana Aksi',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      snapTarget.data![i].rencana,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                    child: Text(
                                      'Pelaksana/Koordinasi',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 0),
                                    child: Text(
                                      snapTarget.data![i].keterangan,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              child: Container(
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.edit,
                                  color: Colors.orange,
                                ),
                              ),
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => TargetForm(
                                      member: widget.member,
                                      pelatihan: widget.pelatihan,
                                      target: snapTarget.data![i],
                                    ),
                                  ),
                                );
                                refresh();
                              },
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: snapTarget.data!.length,
                  ),
                );
              } else {
                return SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(25),
                    child: AFwidget.circularProgress(),
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

class TargetForm extends StatefulWidget {
  final MemberModel member;
  final PelatihanModel pelatihan;
  final RTLtargetModel? target;

  const TargetForm({
    required this.member,
    required this.pelatihan,
    this.target,
    Key? key,
  }) : super(key: key);

  @override
  _TargetFormState createState() => _TargetFormState();
}

class _TargetFormState extends State<TargetForm> {
  final RTLBloc _rtlBloc = RTLBloc();
  final TextEditingController _txtTanggal = TextEditingController();
  final TextEditingController _txtRencana = TextEditingController();
  final TextEditingController _txtKeterangan = TextEditingController();
  late FocusNode _focTanggal;
  late FocusNode _focRencana;
  late FocusNode _focKeterangan;
  DateTime? _tanggal;

  void fetchTanggal(DateTime nilai) {
    _tanggal = nilai;
    _rtlBloc.fetchTanggal(nilai);
  }

  @override
  void initState() {
    super.initState();
    if (widget.target != null) {
      fetchTanggal(widget.target!.tanggal!);
      _txtRencana.text = widget.target!.rencana;
      _txtKeterangan.text = widget.target!.keterangan;
    }
    _focTanggal = FocusNode();
    _focRencana = FocusNode();
    _focKeterangan = FocusNode();
  }

  @override
  void dispose() {
    _focTanggal.dispose();
    _focRencana.dispose();
    _focKeterangan.dispose();
    _rtlBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.target != null ? 'Ubah RTL Target' : 'Tambah RTL Target'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StreamBuilder<DateTime>(
              stream: _rtlBloc.streamTanggal,
              builder: (context, snap) {
                late DateTime nilai;
                if (snap.hasData) {
                  nilai = snap.data!;
                  _txtTanggal.text = AFconvert.matDate(snap.data);
                } else {
                  nilai = DateTime.now();
                  if (widget.target != null) {
                    if (widget.target!.tanggal != null) {
                      fetchTanggal(widget.target!.tanggal!);
                    }
                  }
                }
                return AFwidget.textField(
                  context: context,
                  kontroler: _txtTanggal,
                  focusNode: _focTanggal,
                  label: 'Tanggal Rencana',
                  readonly: true,
                  prefix: const Icon(
                    Icons.calendar_today,
                    size: 20,
                  ),
                  ontap: () async {
                    var a = await showDatePicker(
                      context: context,
                      initialDate: nilai,
                      firstDate: DateTime(2021),
                      lastDate: DateTime(2099),
                    );
                    if (a != null) {
                      fetchTanggal(a);
                    }
                  },
                );
              },
            ),
            AFwidget.textField(
              context: context,
              kontroler: _txtRencana,
              focusNode: _focRencana,
              label: 'Rencana Aksi',
            ),
            AFwidget.textField(
              context: context,
              kontroler: _txtKeterangan,
              focusNode: _focKeterangan,
              label: 'Keterangan',
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 35, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.target != null
                      ? ElevatedButton(
                          child: Text('Hapus'),
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.red.shade400,
                          ),
                          onPressed: () {
                            AFwidget.simpleDialog(
                              context,
                              [
                                Padding(
                                  padding: const EdgeInsets.all(15),
                                  child: Text(
                                    'Yakin ingin menghapus data RTL target ini?',
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    ElevatedButton(
                                      child: const Text('Batal'),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.orange.shade500,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    ElevatedButton.icon(
                                      icon: Icon(Icons.delete_forever_outlined),
                                      label: const Text('Ya, Hapus'),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Colors.red.shade500,
                                      ),
                                      onPressed: () async {
                                        AFwidget.circularDialog(context);
                                        var a = await _rtlBloc
                                            .delTarget(widget.target!);
                                        Navigator.of(context).pop();
                                        String pesan = a['status'].toString() ==
                                                '1'
                                            ? 'Data RTL Target berhasil dihapus.'
                                            : a['message'].toString();
                                        await AFwidget.alertDialog(
                                          context,
                                          Text(pesan),
                                        );
                                        Navigator.of(context).pop();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                              judul: Text('Konfirmasi Hapus RTL Target'),
                            );
                          },
                        )
                      : Spacer(),
                  ElevatedButton(
                    child: Text('Simpan'),
                    onPressed: () async {
                      if (_tanggal == null) {
                        AFwidget.snack(context, 'Tanggal harus diisi.');
                        _focTanggal.requestFocus();
                        return;
                      }
                      if (_txtRencana.text.isEmpty) {
                        AFwidget.snack(context, 'Rencana Aksi harus diisi.');
                        _focRencana.requestFocus();
                        return;
                      }
                      if (_txtKeterangan.text.isEmpty) {
                        AFwidget.snack(context, 'Pelaksana/Koordinasi.');
                        _focKeterangan.requestFocus();
                        return;
                      }

                      RTLtargetModel hasil = RTLtargetModel(
                        id: widget.target != null ? widget.target!.id : 0,
                        nik: widget.target != null
                            ? widget.target!.nik
                            : widget.member.nik,
                        root: widget.target != null
                            ? widget.target!.root
                            : '${widget.pelatihan.giatKode}${widget.pelatihan.tahun}${widget.pelatihan.angkatan}',
                        tanggal: _tanggal,
                        rencana: _txtRencana.text,
                        keterangan: _txtKeterangan.text,
                      );

                      AFwidget.circularDialog(context);
                      Map<String, dynamic> a = {};
                      if (widget.target != null) {
                        a = await _rtlBloc.ediTarget(hasil);
                      } else {
                        a = await _rtlBloc.addTarget(hasil);
                      }
                      Navigator.of(context).pop();
                      if (a['status'].toString() == '1') {
                        await AFwidget.alertDialog(context,
                            const Text('Data RTL Target berhasil disimpan.'));
                        Navigator.of(context).pop(hasil);
                      } else {
                        AFwidget.alertDialog(
                            context, Text(a['message'].toString()));
                      }
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
