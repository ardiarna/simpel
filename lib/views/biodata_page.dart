import 'package:flutter/material.dart';
import 'package:simpel/blocs/member_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_combobox.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/home_page.dart';

List<Opsi> _listOpsiAgama = [];
List<Opsi> _listOpsiKelamin = [];
List<Opsi> _listOpsiKawin = [];
List<Opsi> _listOpsiPendidikan = [];
List<Opsi> _listOpsiProvinsi = [];

class BiodataPage extends StatefulWidget {
  final MemberModel member;

  const BiodataPage({
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _BiodataPageState createState() => _BiodataPageState();
}

class _BiodataPageState extends State<BiodataPage> {
  final MemberBloc _memberBloc = MemberBloc();
  final TextEditingController _txtNIK = TextEditingController();
  final TextEditingController _txtNama = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();
  final TextEditingController _txtTglLahir = TextEditingController();
  final TextEditingController _txtTmptLahir = TextEditingController();
  final TextEditingController _txtPhone = TextEditingController();
  final TextEditingController _txtKelamin = TextEditingController();
  final TextEditingController _txtAgama = TextEditingController();
  final TextEditingController _txtKawin = TextEditingController();
  final TextEditingController _txtPekerjaan = TextEditingController();
  final TextEditingController _txtPendidikan = TextEditingController();
  final TextEditingController _txtJurusan = TextEditingController();
  final TextEditingController _txtProvinsi = TextEditingController();
  final TextEditingController _txtKabupaten = TextEditingController();
  final TextEditingController _txtKecamatan = TextEditingController();
  final TextEditingController _txtKelurahan = TextEditingController();
  final TextEditingController _txtDusun = TextEditingController();
  late FocusNode _focNIK;
  late FocusNode _focNama;
  late FocusNode _focEmail;
  late FocusNode _focTglLahir;
  late FocusNode _focTmptLahir;
  late FocusNode _focPhone;
  late FocusNode _focKelamin;
  late FocusNode _focAgama;
  late FocusNode _focKawin;
  late FocusNode _focPekerjaan;
  late FocusNode _focPendidikan;
  late FocusNode _focJurusan;
  late FocusNode _focProvinsi;
  late FocusNode _focKabupaten;
  late FocusNode _focKecamatan;
  late FocusNode _focKelurahan;
  late FocusNode _focDusun;
  DateTime? _tglLahir;
  String _kelamin = '';
  int _agama = 0;
  int _kawin = 0;
  String _pendidikan = '';
  String _provinsi = '';
  String _kabupaten = '';
  String _kecamatan = '';
  String _kelurahan = '';

  void fetchTglLahir(DateTime nilai) {
    _tglLahir = nilai;
    _memberBloc.fetchTglLahir(nilai);
  }

  void fetchKelamin(String id, String label) {
    _kelamin = id;
    _memberBloc.fetchKelamin(label);
  }

  void fetchAgama(int id, String label) {
    _agama = id;
    _memberBloc.fetchAgama(label);
  }

  void fetchKawin(int id, String label) {
    _kawin = id;
    _memberBloc.fetchKawin(label);
  }

  void fetchPendidikan(String id, String label) {
    _pendidikan = id;
    _memberBloc.fetchPendidikan(label);
  }

  void fetchProvinsi(String id, String label) {
    _provinsi = id;
    _memberBloc.fetchProvinsi(label);
  }

  void fetchKabupaten(String id, String label) {
    _kabupaten = id;
    _memberBloc.fetchKabupaten(label);
  }

  void fetchKecamatan(String id, String label) {
    _kecamatan = id;
    _memberBloc.fetchKecamatan(label);
  }

  void fetchKelurahan(String id, String label) {
    _kelurahan = id;
    _memberBloc.fetchKelurahan(label);
  }

  @override
  void initState() {
    super.initState();
    _txtNIK.text = widget.member.nik;
    _txtNama.text = widget.member.nama;
    _txtEmail.text = widget.member.email;
    _txtTmptLahir.text = widget.member.tmptLahir;
    if (widget.member.tglLahir != null) fetchTglLahir(widget.member.tglLahir!);
    _txtPhone.text = widget.member.phone;
    _txtKelamin.text = widget.member.kelaminLabel;
    _txtAgama.text = widget.member.agamaLabel;
    _txtPekerjaan.text = widget.member.pekerjaan;
    _txtJurusan.text = widget.member.jurusan;
    _txtKawin.text = widget.member.kawinLabel;
    _txtPendidikan.text = widget.member.pendidikanLabel;
    _txtProvinsi.text = widget.member.provLabel;
    _txtKabupaten.text = widget.member.kabLabel;
    _txtKecamatan.text = widget.member.kecLabel;
    _txtKelurahan.text = widget.member.kelLabel;
    _txtDusun.text = widget.member.dusun;
    _kelamin = widget.member.kelamin;
    _agama = widget.member.agama;
    _kawin = widget.member.kawin;
    _pendidikan = widget.member.pendidikan;
    _provinsi = widget.member.provId;
    _kabupaten = widget.member.kabId;
    _kecamatan = widget.member.kecId;
    _kelurahan = widget.member.kelId;
    _focNIK = FocusNode();
    _focNama = FocusNode();
    _focEmail = FocusNode();
    _focTglLahir = FocusNode();
    _focTmptLahir = FocusNode();
    _focPhone = FocusNode();
    _focKelamin = FocusNode();
    _focAgama = FocusNode();
    _focKawin = FocusNode();
    _focPekerjaan = FocusNode();
    _focPendidikan = FocusNode();
    _focJurusan = FocusNode();
    _focProvinsi = FocusNode();
    _focKabupaten = FocusNode();
    _focKecamatan = FocusNode();
    _focKelurahan = FocusNode();
    _focDusun = FocusNode();
    if (_listOpsiAgama.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'agama')
          .then((value) => _listOpsiAgama = value);
    }
    if (_listOpsiKelamin.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'gender')
          .then((value) => _listOpsiKelamin = value);
    }
    if (_listOpsiKawin.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'kawin')
          .then((value) => _listOpsiKawin = value);
    }
    if (_listOpsiPendidikan.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'pendidikan')
          .then((value) => _listOpsiPendidikan = value);
    }
    if (_listOpsiProvinsi.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'domisili', mode: 'provinsi')
          .then((value) => _listOpsiProvinsi = value);
    }
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focNIK.dispose();
    _focNama.dispose();
    _focEmail.dispose();
    _focTglLahir.dispose();
    _focTmptLahir.dispose();
    _focPhone.dispose();
    _focKelamin.dispose();
    _focAgama.dispose();
    _focKawin.dispose();
    _focPekerjaan.dispose();
    _focPendidikan.dispose();
    _focJurusan.dispose();
    _focProvinsi.dispose();
    _focKabupaten.dispose();
    _focKecamatan.dispose();
    _focKelurahan.dispose();
    _focDusun.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubah Data Diri'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 70),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AFwidget.textField(
                  context: context,
                  kontroler: _txtNIK,
                  focusNode: _focNIK,
                  label: 'NIK',
                  suffix: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.transparent,
                  ),
                  readonly: true,
                ),
                AFwidget.textField(
                  context: context,
                  kontroler: _txtNama,
                  focusNode: _focNama,
                  label: 'Nama',
                  suffix: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.transparent,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                AFwidget.textField(
                  context: context,
                  kontroler: _txtEmail,
                  focusNode: _focEmail,
                  label: 'Email',
                  suffix: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.transparent,
                  ),
                ),
                StreamBuilder<DateTime>(
                  stream: _memberBloc.streamTglLahir,
                  builder: (context, snap) {
                    late DateTime nilai;
                    if (snap.hasData) {
                      nilai = snap.data!;
                      _txtTglLahir.text = AFconvert.matDate(snap.data);
                    } else {
                      nilai = DateTime(2000);
                      if (widget.member.tglLahir != null) {
                        fetchTglLahir(widget.member.tglLahir!);
                      }
                    }
                    return AFwidget.textField(
                      context: context,
                      kontroler: _txtTglLahir,
                      focusNode: _focTglLahir,
                      label: 'Tanggal Lahir',
                      readonly: true,
                      prefix: const Icon(
                        Icons.calendar_today,
                        size: 20,
                      ),
                      ontap: () async {
                        var a = await showDatePicker(
                          context: context,
                          initialDate: nilai,
                          firstDate: DateTime(1950),
                          lastDate: DateTime.now(),
                        );
                        if (a != null) {
                          fetchTglLahir(a);
                        }
                      },
                    );
                  },
                ),
                AFwidget.textField(
                  context: context,
                  kontroler: _txtTmptLahir,
                  focusNode: _focTmptLahir,
                  label: 'Tempat Lahir',
                  suffix: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.transparent,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
                AFwidget.textField(
                  context: context,
                  kontroler: _txtPhone,
                  focusNode: _focPhone,
                  label: 'Nomor Handphone',
                  suffix: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.transparent,
                  ),
                  keyboard: TextInputType.phone,
                ),
                StreamBuilder<String>(
                  stream: _memberBloc.streamKelamin,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      _txtKelamin.text = snap.data!;
                    }
                    return AFwidget.textField(
                      context: context,
                      kontroler: _txtKelamin,
                      focusNode: _focKelamin,
                      label: 'Jenis Kelamin',
                      readonly: true,
                      suffix: const Icon(
                        Icons.expand_more,
                        size: 20,
                      ),
                      ontap: () async {
                        var a = await AFcombobox.modalBottom(
                          context: context,
                          listOpsi: _listOpsiKelamin,
                          idSelected: _kelamin,
                          judul: 'Jenis Kelamin',
                          isScrollControlled: false,
                          withCari: false,
                        );
                        if (a != null) {
                          fetchKelamin(a.id, a.label);
                        }
                      },
                    );
                  },
                ),
                StreamBuilder<String>(
                  stream: _memberBloc.streamAgama,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      _txtAgama.text = snap.data!;
                    }
                    return AFwidget.textField(
                      context: context,
                      kontroler: _txtAgama,
                      focusNode: _focAgama,
                      label: 'Agama',
                      readonly: true,
                      suffix: const Icon(
                        Icons.expand_more,
                        size: 20,
                      ),
                      ontap: () async {
                        var a = await AFcombobox.modalBottom(
                          context: context,
                          listOpsi: _listOpsiAgama,
                          idSelected: _agama.toString(),
                          judul: 'Agama',
                        );
                        if (a != null) {
                          fetchAgama(int.parse(a.id), a.label);
                        }
                      },
                    );
                  },
                ),
                widget.member.kategori == 'team'
                    ? Container()
                    : StreamBuilder<String>(
                        stream: _memberBloc.streamKawin,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            _txtKawin.text = snap.data!;
                          }
                          return AFwidget.textField(
                            context: context,
                            kontroler: _txtKawin,
                            focusNode: _focKawin,
                            label: 'Status',
                            readonly: true,
                            suffix: const Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                            ontap: () async {
                              var a = await AFcombobox.modalBottom(
                                context: context,
                                listOpsi: _listOpsiKawin,
                                idSelected: _kawin.toString(),
                                judul: 'Status',
                                isScrollControlled: false,
                              );
                              if (a != null) {
                                fetchKawin(int.parse(a.id), a.label);
                              }
                            },
                          );
                        },
                      ),
                widget.member.kategori == 'team'
                    ? Container()
                    : AFwidget.textField(
                        context: context,
                        kontroler: _txtPekerjaan,
                        focusNode: _focPekerjaan,
                        label: 'Pekerjaan',
                        suffix: const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.transparent,
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                widget.member.kategori == 'team'
                    ? Container()
                    : StreamBuilder<String>(
                        stream: _memberBloc.streamPendidikan,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            _txtPendidikan.text = snap.data!;
                          }
                          return AFwidget.textField(
                            context: context,
                            kontroler: _txtPendidikan,
                            focusNode: _focPendidikan,
                            label: 'Pendidikan',
                            readonly: true,
                            suffix: const Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                            ontap: () async {
                              var a = await AFcombobox.modalBottom(
                                context: context,
                                listOpsi: _listOpsiPendidikan,
                                idSelected: _pendidikan,
                                judul: 'Pendidikan',
                              );
                              if (a != null) {
                                fetchPendidikan(a.id, a.label);
                              }
                            },
                          );
                        },
                      ),
                widget.member.kategori == 'team'
                    ? Container()
                    : AFwidget.textField(
                        context: context,
                        kontroler: _txtJurusan,
                        focusNode: _focJurusan,
                        label: 'Jurusan',
                        suffix: const Icon(
                          Icons.person,
                          size: 20,
                          color: Colors.transparent,
                        ),
                        textCapitalization: TextCapitalization.characters,
                      ),
                widget.member.kategori == 'team'
                    ? Container()
                    : StreamBuilder<String>(
                        stream: _memberBloc.streamProvinsi,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            _txtProvinsi.text = snap.data!;
                          }
                          return AFwidget.textField(
                            context: context,
                            kontroler: _txtProvinsi,
                            focusNode: _focProvinsi,
                            label: 'Provinsi',
                            readonly: true,
                            suffix: const Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                            ontap: () async {
                              var a = await AFcombobox.modalBottom(
                                context: context,
                                listOpsi: _listOpsiProvinsi,
                                idSelected: _provinsi.toString(),
                                judul: 'Provinsi',
                                isScrollControlled: false,
                              );
                              if (a != null) {
                                fetchProvinsi(a.id, a.label);
                                fetchKabupaten('', '');
                                fetchKecamatan('', '');
                                fetchKelurahan('', '');
                              }
                            },
                          );
                        },
                      ),
                widget.member.kategori == 'team'
                    ? Container()
                    : StreamBuilder<String>(
                        stream: _memberBloc.streamKabupaten,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            _txtKabupaten.text = snap.data!;
                          }
                          return AFwidget.textField(
                            context: context,
                            kontroler: _txtKabupaten,
                            focusNode: _focKabupaten,
                            label: 'Kabupaten',
                            readonly: true,
                            suffix: const Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                            ontap: () async {
                              if (_provinsi != '') {
                                AFwidget.circularDialog(context);
                                var _list = await _memberBloc.getOpsies(
                                    rute: 'domisili',
                                    mode: 'kabupaten/$_provinsi');
                                Navigator.of(context).pop();
                                var a = await AFcombobox.modalBottom(
                                  context: context,
                                  listOpsi: _list,
                                  idSelected: _kabupaten,
                                  judul: 'Kabupaten',
                                );
                                if (a != null) {
                                  fetchKabupaten(a.id, a.label);
                                  fetchKecamatan('', '');
                                  fetchKelurahan('', '');
                                }
                              } else {
                                AFwidget.snack(context,
                                    'Silakan isi provinsi terlebih dahulu.');
                                _focProvinsi.requestFocus();
                              }
                            },
                          );
                        },
                      ),
                widget.member.kategori == 'team'
                    ? Container()
                    : StreamBuilder<String>(
                        stream: _memberBloc.streamKecamatan,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            _txtKecamatan.text = snap.data!;
                          }
                          return AFwidget.textField(
                            context: context,
                            kontroler: _txtKecamatan,
                            focusNode: _focKecamatan,
                            label: 'Kecamatan',
                            readonly: true,
                            suffix: const Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                            ontap: () async {
                              if (_kabupaten != '') {
                                AFwidget.circularDialog(context);
                                var _list = await _memberBloc.getOpsies(
                                    rute: 'domisili',
                                    mode: 'kecamatan/$_kabupaten');
                                Navigator.of(context).pop();
                                var a = await AFcombobox.modalBottom(
                                  context: context,
                                  listOpsi: _list,
                                  idSelected: _kecamatan,
                                  judul: 'Kecamatan',
                                );
                                if (a != null) {
                                  fetchKecamatan(a.id, a.label);
                                  fetchKelurahan('', '');
                                }
                              } else {
                                AFwidget.snack(context,
                                    'Silakan isi kabupaten terlebih dahulu.');
                                _focKabupaten.requestFocus();
                              }
                            },
                          );
                        },
                      ),
                widget.member.kategori == 'team'
                    ? Container()
                    : StreamBuilder<String>(
                        stream: _memberBloc.streamKelurahan,
                        builder: (context, snap) {
                          if (snap.hasData) {
                            _txtKelurahan.text = snap.data!;
                          }
                          return AFwidget.textField(
                            context: context,
                            kontroler: _txtKelurahan,
                            focusNode: _focKelurahan,
                            label: 'Kelurahan',
                            readonly: true,
                            suffix: const Icon(
                              Icons.expand_more,
                              size: 20,
                            ),
                            ontap: () async {
                              if (_kecamatan != '') {
                                AFwidget.circularDialog(context);
                                var _list = await _memberBloc.getOpsies(
                                    rute: 'domisili',
                                    mode: 'kelurahan/$_kecamatan');
                                Navigator.of(context).pop();
                                var a = await AFcombobox.modalBottom(
                                  context: context,
                                  listOpsi: _list,
                                  idSelected: _kelurahan,
                                  judul: 'Kelurahan',
                                );
                                if (a != null) {
                                  fetchKelurahan(a.id, a.label);
                                }
                              } else {
                                AFwidget.snack(context,
                                    'Silakan isi kecamatan terlebih dahulu.');
                                _focKecamatan.requestFocus();
                              }
                            },
                          );
                        },
                      ),
                AFwidget.textField(
                  context: context,
                  kontroler: _txtDusun,
                  focusNode: _focDusun,
                  label: 'Dusun',
                  suffix: const Icon(
                    Icons.person,
                    size: 20,
                    color: Colors.transparent,
                  ),
                  textCapitalization: TextCapitalization.characters,
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: ElevatedButton(
        child: const Text('Simpan'),
        onPressed: () async {
          if (_txtNIK.text.isEmpty) {
            AFwidget.snack(context, 'NIK harus diisi.');
            _focNIK.requestFocus();
            return;
          }
          if (_txtNIK.text.length < 16) {
            AFwidget.snack(context,
                'NIK minimal harus 16 karakter, anda baru memasukan ${_txtNIK.text.length} karakter.');
            _focNIK.requestFocus();
            return;
          }
          if (_txtNama.text.isEmpty) {
            AFwidget.snack(context, 'Nama harus diisi.');
            _focNama.requestFocus();
            return;
          }
          bool emailValid = RegExp(
                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
              .hasMatch(_txtEmail.text);
          if (!emailValid) {
            AFwidget.snack(context, 'Alamat email tidak benar.');
            _focEmail.requestFocus();
            return;
          }

          if (_tglLahir == null) {
            AFwidget.snack(context, 'Tanggal lahir harus diisi.');
            _focTglLahir.requestFocus();
            return;
          }

          if (_txtTmptLahir.text.isEmpty) {
            AFwidget.snack(context, 'Tempat lahir harus diisi.');
            _focTmptLahir.requestFocus();
            return;
          }

          if (_txtPhone.text.isEmpty) {
            AFwidget.snack(context, 'Nomor HP harus diisi.');
            _focPhone.requestFocus();
            return;
          }

          if (_kelamin == '') {
            AFwidget.snack(context, 'Jenis kelamin harus diisi.');
            _focKelamin.requestFocus();
            return;
          }

          if (_agama == 0) {
            AFwidget.snack(context, 'Agama harus diisi.');
            _focAgama.requestFocus();
            return;
          }

          if (widget.member.kategori == 'member') {
            if (_kawin == 0) {
              AFwidget.snack(context, 'Status harus diisi.');
              _focKawin.requestFocus();
              return;
            }

            if (_txtPekerjaan.text.isEmpty) {
              AFwidget.snack(context, 'Pekerjaan harus diisi.');
              _focPekerjaan.requestFocus();
              return;
            }

            if (_pendidikan == '') {
              AFwidget.snack(context, 'Pendidikan harus diisi.');
              _focPendidikan.requestFocus();
              return;
            }

            if (_txtJurusan.text.isEmpty) {
              AFwidget.snack(context, 'Jurusan harus diisi.');
              _focJurusan.requestFocus();
              return;
            }

            if (_provinsi == '') {
              AFwidget.snack(context, 'Provinsi harus diisi.');
              _focProvinsi.requestFocus();
              return;
            }

            if (_kabupaten == '') {
              AFwidget.snack(context, 'Kabupaten harus diisi.');
              _focKabupaten.requestFocus();
              return;
            }

            if (_kecamatan == '') {
              AFwidget.snack(context, 'Kecamatan harus diisi.');
              _focKecamatan.requestFocus();
              return;
            }

            if (_kelurahan == '') {
              AFwidget.snack(context, 'Kelurahan harus diisi.');
              _focKelurahan.requestFocus();
              return;
            }
          }

          if (_txtDusun.text.isEmpty) {
            AFwidget.snack(context, 'Dusun harus diisi.');
            _focDusun.requestFocus();
            return;
          }

          MemberModel hasilMember = MemberModel(
            nik: _txtNIK.text,
            nama: _txtNama.text,
            email: _txtEmail.text,
            tglLahir: _tglLahir,
            tmptLahir: _txtTmptLahir.text,
            phone: _txtPhone.text,
            kelamin: _kelamin,
            kelaminLabel: _txtKelamin.text,
            agama: _agama,
            agamaLabel: _txtAgama.text,
            kawin: _kawin,
            kawinLabel: _txtKawin.text,
            pekerjaan: _txtPekerjaan.text,
            pendidikan: _pendidikan,
            pendidikanLabel: _txtPendidikan.text,
            jurusan: _txtJurusan.text,
            provId: _provinsi,
            kabId: _kabupaten,
            kecId: _kecamatan,
            kelId: _kelurahan,
            provLabel: _txtProvinsi.text,
            kabLabel: _txtKabupaten.text,
            kecLabel: _txtKecamatan.text,
            kelLabel: _txtKelurahan.text,
            dusun: _txtDusun.text,
            createdOn: widget.member.createdOn,
            flagEmail: widget.member.flagEmail,
            foto: widget.member.foto,
            fstatus: widget.member.fstatus,
            ipLogin: widget.member.ipLogin,
            keterangan: widget.member.keterangan,
            ktp: widget.member.ktp,
            modifiedBy: widget.member.modifiedBy,
            modifiedOn: widget.member.modifiedOn,
            password: widget.member.password,
            tglLastLogin: widget.member.tglLastLogin,
            token: widget.member.token,
            kategori: widget.member.kategori,
          );

          AFwidget.circularDialog(context);
          var a = await _memberBloc.editBiodata(hasilMember);
          Navigator.of(context).pop();

          if (a['status'].toString() == '1') {
            await AFwidget.alertDialog(
                context, const Text('Data Diri berhasil diubah.'));
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomePage(
                  menu: 3,
                  page: 'saya',
                  member: hasilMember,
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
