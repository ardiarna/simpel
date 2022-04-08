import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simpel/blocs/rtl_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rtl_real_model.dart';
import 'package:simpel/utils/af_combobox.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_sliver_subheader.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:url_launcher/url_launcher.dart';

class RTLrealPage extends StatefulWidget {
  final MemberModel member;
  final MemberModel? team;
  final PelatihanModel pelatihan;

  const RTLrealPage({
    required this.member,
    required this.pelatihan,
    this.team,
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
    print(widget.pelatihan.kode);
    return Scaffold(
      appBar: widget.team != null
          ? AppBar(
              elevation: 0.5,
              flexibleSpace: Container(
                padding: EdgeInsets.fromLTRB(50, 19, 10, 5),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'RTL ${widget.pelatihan.singkatan} ${widget.pelatihan.angkatan}-${widget.pelatihan.tahun}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 25),
                      child: Text(
                        '${widget.member.nama}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            )
          : null,
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
                                    child: snapReal.data![i].jml > 0
                                        ? Text(
                                            snapReal.data![i].keterangan,
                                          )
                                        : Text(
                                            'Belum Realisasi',
                                            style: TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                  ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(0, 0, 0, 5),
                                  //   child: Text(
                                  //     'Capaian',
                                  //     style: TextStyle(
                                  //       color: Colors.grey,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width:
                                  //           MediaQuery.of(context).size.width -
                                  //               130,
                                  //       child: AFwidget.linearProgress(
                                  //         value: (snapReal.data![i].capaian
                                  //                 .toDouble() /
                                  //             100),
                                  //       ),
                                  //     ),
                                  //     Padding(
                                  //       padding: const EdgeInsets.fromLTRB(
                                  //           10, 0, 0, 0),
                                  //       child: Text(
                                  //         '${snapReal.data![i].capaian} %',
                                  //       ),
                                  //     ),
                                  //   ],
                                  // ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(0, 10, 0, 3),
                                  //   child: Text(
                                  //     'Status Validasi',
                                  //     style: TextStyle(
                                  //       color: Colors.grey,
                                  //     ),
                                  //   ),
                                  // ),
                                  // Padding(
                                  //   padding:
                                  //       const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                  //   child: snapReal.data![i].validasi == 'Y'
                                  //       ? Text(
                                  //           'Sudah Validasi',
                                  //         )
                                  //       : Text(
                                  //           'Belum Validasi',
                                  //           style: TextStyle(
                                  //             color: Colors.red,
                                  //           ),
                                  //         ),
                                  // ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 15, 0, 3),
                                    child: Text(
                                      'Keterangan',
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
                                        const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                    child: Text(
                                      'Solusi Psm',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      snapReal.data![i].psmSaran,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 3),
                                    child: Text(
                                      'Nama Psm',
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.fromLTRB(0, 0, 0, 10),
                                    child: Text(
                                      snapReal.data![i].psmNama,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                widget.team != null
                                    ? GestureDetector(
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
                                            Icons.comment,
                                            color: Colors.green,
                                          ),
                                        ),
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => RealSaran(
                                                teamNik: widget.team!.nik,
                                                real: snapReal.data![i],
                                                member: widget.member,
                                                pelatihan: widget.pelatihan,
                                              ),
                                            ),
                                          );
                                          refresh();
                                        },
                                      )
                                    : GestureDetector(
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
                                            Icons.add,
                                            color: Colors.green,
                                          ),
                                        ),
                                        onTap: () async {
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => RealForm(
                                                member: widget.member,
                                                pelatihan: widget.pelatihan,
                                                isEdit: false,
                                                real: snapReal.data![i],
                                              ),
                                            ),
                                          );
                                          refresh();
                                        },
                                      ),
                                widget.team == null &&
                                        snapReal.data![i].jml > 0 &&
                                        snapReal.data![i].validasi != 'Y'
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
                                                isEdit: true,
                                                real: snapReal.data![i],
                                              ),
                                            ),
                                          );
                                          refresh();
                                        },
                                      )
                                    : Container(),
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
                                          AFwidget.circularDialog(context);
                                          var a = await _rtlBloc.getRealHistory(
                                              snapReal.data![i].targetId
                                                  .toString());
                                          Navigator.of(context).pop();
                                          await Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (context) => RealHistory(
                                                selectedReal: snapReal.data![i],
                                                listReal: a,
                                              ),
                                            ),
                                          );
                                          refresh();
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
          SliverPadding(padding: EdgeInsets.only(bottom: 15)),
        ],
      ),
    );
  }
}

class RealForm extends StatefulWidget {
  final MemberModel member;
  final PelatihanModel pelatihan;
  final bool isEdit;
  final RTLrealModel? real;

  const RealForm({
    required this.member,
    required this.pelatihan,
    required this.isEdit,
    this.real,
    Key? key,
  }) : super(key: key);

  @override
  _RealFormState createState() => _RealFormState();
}

class _RealFormState extends State<RealForm> {
  final RTLBloc _rtlBloc = RTLBloc();
  final TextEditingController _txtTarget = TextEditingController();
  final TextEditingController _txtTanggal = TextEditingController();
  final TextEditingController _txtKendala = TextEditingController();
  final TextEditingController _txtKeterangan = TextEditingController();
  final TextEditingController _txtFile = TextEditingController();
  late FocusNode _focTarget;
  late FocusNode _focTanggal;
  late FocusNode _focKendala;
  late FocusNode _focKeterangan;
  late FocusNode _focFile;
  DateTime? _tanggal;
  int _targetId = 0;
  double _capaian = 0;
  String _pathFile = '';

  List<Opsi> _listOpsiTarget = [];

  void fetchTanggal(DateTime nilai) {
    _tanggal = nilai;
    _rtlBloc.fetchTglAwal(nilai);
  }

  void fetchRencanaLabel(int id, String label) {
    _targetId = id;
    _rtlBloc.fetchRencanaLabel(label);
  }

  void fetchFile(String path, String label) {
    _pathFile = path;
    _rtlBloc.fetchFile(label);
  }

  void fetchCapaian(double nilai) {
    _capaian = nilai;
    _rtlBloc.fetchCapaian(nilai);
  }

  @override
  void initState() {
    super.initState();
    if (widget.isEdit) {
      _targetId = widget.real!.targetId;
      _txtTarget.text = widget.real!.targetRencana;
      fetchTanggal(widget.real!.tanggal!);
      _txtKendala.text = widget.real!.kendala;
      _txtKeterangan.text = widget.real!.keterangan;
      fetchCapaian(widget.real!.capaian.toDouble());
    } else {
      _targetId = widget.real!.targetId;
      _txtTarget.text = widget.real!.targetRencana;
    }
    _focTarget = FocusNode();
    _focTanggal = FocusNode();
    _focKendala = FocusNode();
    _focKeterangan = FocusNode();
    _focFile = FocusNode();
    if (_listOpsiTarget.isEmpty) {
      _rtlBloc
          .getTargets(widget.member.nik, widget.pelatihan.kode)
          .then((value) {
        for (var item in value) {
          var a = Opsi(
            id: item.id.toString(),
            label: item.rencana,
          );
          _listOpsiTarget.add(a);
        }
      });
    }
  }

  @override
  void dispose() {
    _focTarget.dispose();
    _focTanggal.dispose();
    _focKendala.dispose();
    _focKeterangan.dispose();
    _focFile.dispose();
    _rtlBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isEdit ? 'Ubah RTL Realisasi' : 'Tambah RTL Realisasi'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            StreamBuilder<String>(
              stream: _rtlBloc.streamRencanaLabel,
              builder: (context, snap) {
                if (snap.hasData) {
                  _txtTarget.text = snap.data!;
                }
                return AFwidget.textField(
                  context: context,
                  kontroler: _txtTarget,
                  focusNode: _focTarget,
                  label: 'Rencana Aksi',
                  readonly: true,
                  suffix: const Icon(
                    Icons.expand_more,
                    size: 20,
                  ),
                  ontap: () async {
                    // if (widget.real == null) {
                    //   var a = await AFcombobox.modalBottom(
                    //     context: context,
                    //     listOpsi: _listOpsiTarget,
                    //     idSelected: _targetId.toString(),
                    //     judul: 'Rencana Aksi',
                    //   );
                    //   if (a != null) {
                    //     fetchRencanaLabel(int.parse(a.id), a.label);
                    //   }
                    // }
                  },
                );
              },
            ),
            StreamBuilder<DateTime>(
              stream: _rtlBloc.streamTglAwal,
              builder: (context, snap) {
                late DateTime nilai;
                if (snap.hasData) {
                  nilai = snap.data!;
                  _txtTanggal.text = AFconvert.matDate(snap.data);
                } else {
                  nilai = DateTime.now();
                  if (widget.isEdit) {
                    if (widget.real!.tanggal != null) {
                      fetchTanggal(widget.real!.tanggal!);
                    }
                  }
                }
                return AFwidget.textField(
                  context: context,
                  kontroler: _txtTanggal,
                  focusNode: _focTanggal,
                  label: 'Tanggal Realisasi',
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
              kontroler: _txtKeterangan,
              focusNode: _focKeterangan,
              label: 'Realisasi Aksi',
              maxLines: 3,
            ),
            AFwidget.textField(
              context: context,
              kontroler: _txtKendala,
              focusNode: _focKendala,
              label: 'Keterangan',
              maxLines: 2,
            ),
            // Container(
            //   padding: EdgeInsets.fromLTRB(10, 15, 15, 0),
            //   alignment: Alignment.topLeft,
            //   child: Text(
            //     'Capaian',
            //     style: TextStyle(
            //       fontSize: 15,
            //     ),
            //   ),
            // ),
            // Container(
            //   padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            //   child: StreamBuilder<double>(
            //     stream: _rtlBloc.streamCapaian,
            //     builder: (context, snap) {
            //       double nilai = 0;
            //       if (snap.hasData) {
            //         nilai = snap.data!;
            //       } else {
            //         if (widget.isEdit) {
            //           fetchCapaian(widget.real!.capaian.toDouble());
            //         }
            //       }
            //       return Row(
            //         children: [
            //           Expanded(
            //             child: Slider(
            //               value: nilai,
            //               min: 0,
            //               max: 100,
            //               label: nilai.round().toString(),
            //               onChanged: (value) {
            //                 fetchCapaian(value);
            //               },
            //             ),
            //           ),
            //           Text('${nilai.round()} %'),
            //         ],
            //       );
            //     },
            //   ),
            // ),
            StreamBuilder<String>(
              stream: _rtlBloc.streamFile,
              builder: (context, snap) {
                if (snap.hasData) {
                  _txtFile.text = snap.data!;
                } else {
                  if (widget.isEdit) {
                    fetchFile('', widget.real!.file);
                  }
                }
                return AFwidget.textField(
                  context: context,
                  kontroler: _txtFile,
                  focusNode: _focFile,
                  label: 'File',
                  readonly: true,
                  prefix: const Icon(
                    Icons.upload_file,
                    size: 20,
                  ),
                  ontap: () {
                    AFwidget.modalBottom(
                      context: context,
                      isScrollControlled: false,
                      judul: 'Upload File',
                      konten: Column(
                        children: [
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.add_chart),
                            title: const Text('Ambil File dari storage'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              var a = await FilePicker.platform.pickFiles();
                              if (a != null) {
                                var path = a.files.single.path;
                                if (path != null) {
                                  fetchFile(path, a.files.single.name);
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                          ),
                          const Divider(),
                          ListTile(
                            dense: true,
                            leading: const Icon(Icons.add_a_photo_outlined),
                            title: const Text('Ambil Foto dari Kamera'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              var a = await ImagePicker().pickImage(
                                source: ImageSource.camera,
                              );
                              if (a != null) {
                                fetchFile(a.path, a.name);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          const Divider(),
                          ListTile(
                            dense: true,
                            leading:
                                const Icon(Icons.add_photo_alternate_outlined),
                            title: const Text('Ambil Foto dari Galeri'),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 15,
                              color: Colors.red,
                            ),
                            onTap: () async {
                              var a = await ImagePicker().pickImage(
                                source: ImageSource.gallery,
                              );
                              if (a != null) {
                                fetchFile(a.path, a.name);
                                Navigator.of(context).pop();
                              }
                            },
                          ),
                          const Divider(),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(15, 35, 15, 15),
              child: ElevatedButton(
                child: Text('Simpan'),
                onPressed: () async {
                  if (_targetId == 0) {
                    AFwidget.snack(context, 'Rencana Aksi harus diisi.');
                    _focTarget.requestFocus();
                    return;
                  }
                  if (_tanggal == null) {
                    AFwidget.snack(context, 'Tanggal harus diisi.');
                    _focTanggal.requestFocus();
                    return;
                  }
                  if (_txtKeterangan.text.isEmpty) {
                    AFwidget.snack(context, 'Realisasi Aksi harus diisi.');
                    _focKeterangan.requestFocus();
                    return;
                  }
                  // if (_capaian == 0) {
                  //   AFwidget.snack(context, 'Capaian harus diisi.');
                  //   return;
                  // }
                  // if (_capaian > 100) {
                  //   AFwidget.snack(context,
                  //       'Nilai Capaian tidak boleh lebih dari 100');
                  //   return;
                  // }

                  RTLrealModel hasil = RTLrealModel(
                    id: widget.isEdit ? widget.real!.id : 0,
                    targetId: _targetId,
                    targetRencana: _txtTarget.text,
                    tanggal: _tanggal,
                    keterangan: _txtKeterangan.text,
                    kendala: _txtKendala.text,
                    capaian: _capaian.round(),
                    file: _pathFile,
                  );

                  AFwidget.circularDialog(context);
                  Map<String, dynamic> a = {};
                  if (widget.isEdit) {
                    a = await _rtlBloc.ediReal(hasil);
                  } else {
                    a = await _rtlBloc.addReal(hasil);
                  }
                  Navigator.of(context).pop();
                  if (a['status'].toString() == '1') {
                    await AFwidget.alertDialog(context,
                        const Text('Data RTL Realisasi berhasil disimpan.'));
                    Navigator.of(context).pop(hasil);
                  } else {
                    AFwidget.alertDialog(
                        context, Text(a['message'].toString()));
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

class RealHistory extends StatefulWidget {
  final RTLrealModel selectedReal;
  final List<RTLrealModel> listReal;

  const RealHistory({
    required this.selectedReal,
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
        title: Text('History Realisasi'),
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
                      widget.selectedReal.targetRencana,
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
                                'Keterangan',
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
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                            //   child: Text(
                            //     'Capaian',
                            //     style: TextStyle(
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ),
                            // Row(
                            //   children: [
                            //     Container(
                            //       width:
                            //           MediaQuery.of(context).size.width - 130,
                            //       child: AFwidget.linearProgress(
                            //           value: widget.listReal[i].capaian
                            //                   .toDouble() /
                            //               100),
                            //     ),
                            //     Padding(
                            //       padding:
                            //           const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            //       child: Text(
                            //         '${widget.listReal[i].capaian} %',
                            //       ),
                            //     ),
                            //   ],
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 3),
                            //   child: Text(
                            //     'Status Validasi',
                            //     style: TextStyle(
                            //       color: Colors.grey,
                            //     ),
                            //   ),
                            // ),
                            // Padding(
                            //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                            //   child: widget.listReal[i].validasi == 'Y'
                            //       ? Text(
                            //           'Sudah Validasi',
                            //         )
                            //       : Text(
                            //           'Belum Validasi',
                            //           style: TextStyle(
                            //             color: Colors.red,
                            //           ),
                            //         ),
                            // ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 15, 0, 3),
                              child: Text(
                                'Solusi Psm',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                widget.listReal[i].psmSaran,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                              child: Text(
                                'Nama Psm',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                              child: Text(
                                widget.listReal[i].psmNama,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
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
                                    String url = _rtlBloc.dirRTL +
                                        widget.listReal[i].file;
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
                          widget.listReal[i].id == widget.selectedReal.id
                              ? GestureDetector(
                                  child: Container(
                                    margin: EdgeInsets.only(top: 15),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.red,
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.delete_forever,
                                      color: Colors.red,
                                    ),
                                  ),
                                  onTap: () async {
                                    AFwidget.simpleDialog(
                                      context,
                                      [
                                        Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Text(
                                            'Yakin ingin menghapus data RTL realisasi ini?',
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                              child: const Text('Batal'),
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.orange.shade500,
                                              ),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            ElevatedButton.icon(
                                              icon: Icon(Icons
                                                  .delete_forever_outlined),
                                              label: const Text('Ya, Hapus'),
                                              style: TextButton.styleFrom(
                                                backgroundColor:
                                                    Colors.red.shade500,
                                              ),
                                              onPressed: () async {
                                                AFwidget.circularDialog(
                                                    context);
                                                var a = await _rtlBloc.delReal(
                                                    widget.listReal[i]);
                                                Navigator.of(context).pop();
                                                String pesan = a['status']
                                                            .toString() ==
                                                        '1'
                                                    ? 'Data RTL Realisasi berhasil dihapus.'
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
                                      judul: Text('Konfirmasi!'),
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
              childCount: widget.listReal.length,
            ),
          )
        ],
      ),
    );
  }
}

class RealSaran extends StatefulWidget {
  final RTLrealModel real;
  final String teamNik;
  final MemberModel member;
  final PelatihanModel pelatihan;

  RealSaran({
    required this.real,
    required this.teamNik,
    required this.member,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  State<RealSaran> createState() => _RealSaranState();
}

class _RealSaranState extends State<RealSaran> {
  final RTLBloc _rtlBloc = RTLBloc();
  final TextEditingController _txtSaran = TextEditingController();
  late FocusNode _focSaran;

  @override
  void initState() {
    super.initState();
    _txtSaran.text = widget.real.psmSaran;
    _focSaran = FocusNode();
  }

  @override
  void dispose() {
    _rtlBloc.dispose();
    _focSaran.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.5,
        flexibleSpace: Container(
          padding: EdgeInsets.fromLTRB(50, 19, 10, 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Saran RTL ${widget.pelatihan.singkatan} ${widget.pelatihan.angkatan}-${widget.pelatihan.tahun}',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25),
                child: Text(
                  '${widget.member.nama}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(15, 15, 10, 15),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.grey, width: 1),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 10, 0, 3),
                child: Text(
                  'Rencana Aksi',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 15),
                child: Text(
                  widget.real.targetRencana,
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
                      widget.real.tanggal,
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
                  widget.real.keterangan,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                child: Text(
                  'Keterangan',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 10),
                child: Text(
                  widget.real.kendala,
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
              //   child: Text(
              //     'Capaian',
              //     style: TextStyle(
              //       color: Colors.grey,
              //     ),
              //   ),
              // ),
              // Row(
              //   children: [
              //     Container(
              //       width: MediaQuery.of(context).size.width - 130,
              //       child: AFwidget.linearProgress(
              //         value: (widget.real.capaian.toDouble() / 100),
              //       ),
              //     ),
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(10, 0, 0, 20),
              //       child: Text(
              //         '${widget.real.capaian} %',
              //       ),
              //     ),
              //   ],
              // ),
              AFwidget.textField(
                context: context,
                kontroler: _txtSaran,
                focusNode: _focSaran,
                label: 'Solusi Psm',
                maxLines: 2,
                padding: EdgeInsets.all(10),
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(7)),
              ),
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 35, 15, 15),
                  child: ElevatedButton(
                    child: Text('Simpan'),
                    onPressed: () async {
                      if (_txtSaran.text.isEmpty) {
                        AFwidget.snack(context, 'Saran harus diisi.');
                        _focSaran.requestFocus();
                        return;
                      }

                      AFwidget.circularDialog(context);
                      var a = await _rtlBloc.saranReal(
                          widget.real.id.toString(),
                          _txtSaran.text,
                          widget.teamNik);
                      Navigator.of(context).pop();
                      if (a['status'].toString() == '1') {
                        await AFwidget.alertDialog(
                            context, const Text('Saran berhasil disimpan.'));
                        Navigator.of(context).pop();
                      } else {
                        AFwidget.alertDialog(
                            context, Text(a['message'].toString()));
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
