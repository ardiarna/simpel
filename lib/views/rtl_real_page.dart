import 'package:flutter/material.dart';
import 'package:simpel/blocs/rtl_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rtl_real_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_sliver_subheader.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class RTLrealPage extends StatefulWidget {
  final MemberModel member;
  final PelatihanModel pelatihan;

  const RTLrealPage({
    required this.member,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  _RTLrealPageState createState() => _RTLrealPageState();
}

class _RTLrealPageState extends State<RTLrealPage> {
  final RTLBloc _rtlBloc = RTLBloc();

  @override
  void dispose() {
    _rtlBloc.dispose();
    super.dispose();
  }

  void refresh() {
    _rtlBloc.getReals(widget.member.nik, widget.pelatihan.kode).then((value) {
      _rtlBloc.fetchReal(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    refresh();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => RealForm(
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
          StreamBuilder<List<RTLrealModel>>(
            stream: _rtlBloc.streamReal,
            builder: (context, snapReal) {
              if (snapReal.hasData) {
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
                                        const EdgeInsets.fromLTRB(0, 0, 0, 15),
                                    child: Text(
                                      snapReal.data![i].targetRencana,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(right: 5),
                                        child: Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                      ),
                                      Text(
                                        AFconvert.matDate(
                                          snapReal.data![i].tanggal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 10, 0, 3),
                                    child: Text(
                                      'Realisasi Aksi',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      snapReal.data![i].keterangan,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                    child: Text(
                                      'Kendala',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      snapReal.data![i].kendala,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                    child: Text(
                                      'Capaian',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                130,
                                        child: AFwidget.linearProgress(
                                          value: (snapReal.data![i].capaian
                                                  .toDouble() /
                                              100),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 0, 0, 0),
                                        child: Text(
                                          '${snapReal.data![i].capaian} %',
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.green,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.edit,
                                      color: Colors.green,
                                    ),
                                  ),
                                  onTap: () async {
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => RealForm(
                                          member: widget.member,
                                          pelatihan: widget.pelatihan,
                                          real: snapReal.data![i],
                                        ),
                                      ),
                                    );
                                    refresh();
                                  },
                                ),
                                snapReal.data![i].file != ''
                                    ? GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 15),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.green,
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.download_outlined,
                                            color: Colors.green,
                                          ),
                                        ),
                                        onTap: () async {
                                          String url = _rtlBloc.dirRTL +
                                              snapReal.data![i].file;
                                          var a = await canLaunch(url);

                                          if (a) {
                                            launch(url);
                                          } else {
                                            AFwidget.alertDialog(
                                              context,
                                              Text('Lampiran tidak ditemukan'),
                                            );
                                          }
                                        },
                                      )
                                    : Container(),
                                snapReal.data![i].jml > 1
                                    ? GestureDetector(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 15),
                                          padding: EdgeInsets.all(5),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.green,
                                              width: 1,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.timeline_outlined,
                                            color: Colors.green,
                                          ),
                                        ),
                                        onTap: () async {
                                          var a = await _rtlBloc.getRealHistory(
                                              snapReal.data![i].targetId
                                                  .toString());
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => RealHistory(
                                                targetRencana: snapReal
                                                    .data![i].targetRencana,
                                                listReal: a,
                                              ),
                                            ),
                                          );
                                        },
                                      )
                                    : Container(),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: snapReal.data!.length,
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

class RealForm extends StatefulWidget {
  final MemberModel member;
  final PelatihanModel pelatihan;
  final RTLrealModel? real;

  const RealForm({
    required this.member,
    required this.pelatihan,
    this.real,
    Key? key,
  }) : super(key: key);

  @override
  _RealFormState createState() => _RealFormState();
}

class _RealFormState extends State<RealForm> {
  final RTLBloc _rtlBloc = RTLBloc();
  final TextEditingController _txtTanggal = TextEditingController();
  final TextEditingController _txtKendala = TextEditingController();
  final TextEditingController _txtKeterangan = TextEditingController();
  late FocusNode _focTanggal;
  late FocusNode _focKendala;
  late FocusNode _focKeterangan;
  DateTime? _tanggal;

  void fetchTanggal(DateTime nilai) {
    _tanggal = nilai;
    _rtlBloc.fetchTanggal(nilai);
  }

  @override
  void initState() {
    super.initState();
    if (widget.real != null) {
      fetchTanggal(widget.real!.tanggal!);
      _txtKendala.text = widget.real!.kendala;
      _txtKeterangan.text = widget.real!.keterangan;
    }
    _focTanggal = FocusNode();
    _focKendala = FocusNode();
    _focKeterangan = FocusNode();
  }

  @override
  void dispose() {
    _focTanggal.dispose();
    _focKendala.dispose();
    _focKeterangan.dispose();
    _rtlBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit RTL Real'),
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
                  if (widget.real != null) {
                    if (widget.real!.tanggal != null) {
                      fetchTanggal(widget.real!.tanggal!);
                    }
                  }
                }
                return AFwidget.textField(
                  context: context,
                  kontroler: _txtTanggal,
                  focusNode: _focTanggal,
                  label: 'Tanggal',
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
              kontroler: _txtKendala,
              focusNode: _focKendala,
              label: 'Kendala Aksi',
            ),
            AFwidget.textField(
              context: context,
              kontroler: _txtKeterangan,
              focusNode: _focKeterangan,
              label: 'Pelaksana/Koordinasi',
              maxLines: 5,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 25, 15, 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.real != null
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
                                    'Yakin ingin menghapus data RTL real ini?',
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
                                            .delReal(widget.real!);
                                        Navigator.of(context).pop();
                                        String pesan = a['status'].toString() ==
                                                '1'
                                            ? 'Data RTL Real berhasil dihapus.'
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
                              judul: Text('Konfirmasi Hapus RTL Real'),
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
                      if (_txtKendala.text.isEmpty) {
                        AFwidget.snack(context, 'Kendala Aksi harus diisi.');
                        _focKendala.requestFocus();
                        return;
                      }
                      if (_txtKeterangan.text.isEmpty) {
                        AFwidget.snack(context, 'Pelaksana/Koordinasi.');
                        _focKeterangan.requestFocus();
                        return;
                      }

                      // RTLrealModel hasil = RTLrealModel(
                      //   id: widget.real != null ? widget.real!.id : 0,
                      //   nik: widget.real != null
                      //       ? widget.real!.nik
                      //       : widget.member.nik,
                      //   root: widget.real != null
                      //       ? widget.real!.root
                      //       : '${widget.pelatihan.giatKode}${widget.pelatihan.tahun}${widget.pelatihan.angkatan}',
                      //   tanggal: _tanggal,
                      //   kendala: _txtKendala.text,
                      //   keterangan: _txtKeterangan.text,
                      // );

                      // AFwidget.circularDialog(context);
                      // Map<String, dynamic> a = {};
                      // if (widget.real != null) {
                      //   a = await _rtlBloc.ediReal(hasil);
                      // } else {
                      //   a = await _rtlBloc.addReal(hasil);
                      // }
                      // Navigator.of(context).pop();
                      // if (a['status'].toString() == '1') {
                      //   await AFwidget.alertDialog(context,
                      //       const Text('Data RTL Real berhasil disimpan.'));
                      //   Navigator.of(context).pop(hasil);
                      // } else {
                      //   AFwidget.alertDialog(
                      //       context, Text(a['message'].toString()));
                      // }
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

class RealHistory extends StatefulWidget {
  final String targetRencana;
  final List<RTLrealModel> listReal;

  const RealHistory({
    required this.targetRencana,
    required this.listReal,
    Key? key,
  }) : super(key: key);

  @override
  _RealHistoryState createState() => _RealHistoryState();
}

class _RealHistoryState extends State<RealHistory> {
  final RTLBloc _rtlBloc = RTLBloc();

  @override
  void dispose() {
    _rtlBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History RTL Real'),
      ),
      body: CustomScrollView(
        slivers: [
          AFsliverSubHeader(
            maxHeight: 65,
            minHeight: 65,
            child: Container(
              padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                    child: Text(
                      'Rencana Aksi',
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Text(
                      widget.targetRencana,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
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
                                    color: Colors.green,
                                  ),
                                ),
                                Text(
                                  AFconvert.matDate(
                                    widget.listReal[i].tanggal,
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
                              child: Text(
                                'Realisasi Aksi',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                widget.listReal[i].keterangan,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              child: Text(
                                'Kendala',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                widget.listReal[i].kendala,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                              child: Text(
                                'Capaian',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 130,
                                  child: AFwidget.linearProgress(
                                      value: widget.listReal[i].capaian
                                              .toDouble() /
                                          100),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(10, 0, 0, 0),
                                  child: Text(
                                    '${widget.listReal[i].capaian} %',
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      widget.listReal[i].file != ''
                          ? GestureDetector(
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.green,
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  Icons.download_outlined,
                                  color: Colors.green,
                                ),
                              ),
                              onTap: () async {
                                String url =
                                    _rtlBloc.dirRTL + widget.listReal[i].file;
                                var a = await canLaunch(url);

                                if (a) {
                                  launch(url);
                                } else {
                                  AFwidget.alertDialog(
                                    context,
                                    Text('Lampiran tidak ditemukan'),
                                  );
                                }
                              },
                            )
                          : Container(),
                    ],
                  ),
                );
              },
              childCount: widget.listReal.length,
            ),
          )
        ],
      ),
    );
  }
}
