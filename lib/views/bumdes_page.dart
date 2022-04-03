import 'package:flutter/material.dart';
import 'package:simpel/blocs/bumdes_bloc.dart';
import 'package:simpel/models/bumdes_model.dart';
import 'package:simpel/utils/af_widget.dart';

class BumdesTab extends StatefulWidget {
  final String nik;
  const BumdesTab({
    required this.nik,
    Key? key,
  }) : super(key: key);

  @override
  _BumdesTabState createState() => _BumdesTabState();
}

class _BumdesTabState extends State<BumdesTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Bumdes / Kedudukan'),
          bottom: const TabBar(tabs: [
            Tab(
              text: 'Bumdes',
            ),
            Tab(
              text: 'Kedudukan',
            ),
          ]),
        ),
        body: TabBarView(children: [
          BumdesPage(nik: widget.nik),
          KedudukanPage(nik: widget.nik),
        ]),
      ),
    );
  }
}

class BumdesPage extends StatefulWidget {
  final String nik;

  const BumdesPage({
    required this.nik,
    Key? key,
  }) : super(key: key);

  @override
  _BumdesPageState createState() => _BumdesPageState();
}

class _BumdesPageState extends State<BumdesPage> {
  final BumdesBloc bumdesBloc = BumdesBloc();

  @override
  Widget build(BuildContext context) {
    double lebarA = 120;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(5, 3, 5, 0),
          padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),
          color: Colors.white,
          child: FutureBuilder<BumdesModel>(
            future: bumdesBloc.get(widget.nik),
            builder: (context, snapFut) {
              if (snapFut.hasData) {
                return StreamBuilder<BumdesModel>(
                  stream: bumdesBloc.stream,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Nama Bumdes')),
                              const Text(' : '),
                              Text(
                                snap.data!.nama,
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
                                snap.data!.tahun.toString(),
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
                                snap.data!.unitusaha,
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
                                snap.data!.omset,
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
                                snap.data!.jabatan,
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
                                snap.data!.jabperiode,
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
                                snap.data!.kendala,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: ElevatedButton(
                              child: Text("Edit"),
                              onPressed: () async {
                                var a = await Navigator.of(context)
                                    .push<BumdesModel>(
                                  MaterialPageRoute(
                                    builder: (context) => BumdesForm(
                                      nik: widget.nik,
                                    ),
                                  ),
                                );
                                if (a != null) {
                                  bumdesBloc.fetch(a);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      bumdesBloc.fetch(snapFut.data!);
                      return AFwidget.circularProgress();
                    }
                  },
                );
              } else {
                return AFwidget.circularProgress();
              }
            },
          ),
        ),
      ),
    );
  }
}

class BumdesForm extends StatefulWidget {
  final String nik;

  const BumdesForm({
    required this.nik,
    Key? key,
  }) : super(key: key);

  @override
  _BumdesFormState createState() => _BumdesFormState();
}

class _BumdesFormState extends State<BumdesForm> {
  final BumdesBloc bumdesBloc = BumdesBloc();
  final TextEditingController _txtNama = TextEditingController();
  final TextEditingController _txtTahun = TextEditingController();
  final TextEditingController _txtUnitUsaha = TextEditingController();
  final TextEditingController _txtOmset = TextEditingController();
  final TextEditingController _txtJabatan = TextEditingController();
  final TextEditingController _txtJabPeriode = TextEditingController();
  final TextEditingController _txtKendala = TextEditingController();

  late FocusNode _focNama;
  late FocusNode _focTahun;
  late FocusNode _focUnitUsaha;
  late FocusNode _focOmset;
  late FocusNode _focJabatan;
  late FocusNode _focJabPeriode;
  late FocusNode _focKendala;

  @override
  void initState() {
    super.initState();
    _focNama = FocusNode();
    _focTahun = FocusNode();
    _focUnitUsaha = FocusNode();
    _focOmset = FocusNode();
    _focJabatan = FocusNode();
    _focJabPeriode = FocusNode();
    _focKendala = FocusNode();
  }

  @override
  void dispose() {
    _focNama.dispose();
    _focTahun.dispose();
    _focUnitUsaha.dispose();
    _focOmset.dispose();
    _focJabatan.dispose();
    _focJabPeriode.dispose();
    _focKendala.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bumdes'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 70),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            color: Colors.white,
            child: FutureBuilder<BumdesModel>(
                future: bumdesBloc.get(widget.nik),
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtNama.text = snap.data!.nama;
                    _txtTahun.text = snap.data!.tahun.toString();
                    _txtUnitUsaha.text = snap.data!.unitusaha;
                    _txtOmset.text = snap.data!.omset;
                    _txtJabatan.text = snap.data!.jabatan;
                    _txtJabPeriode.text = snap.data!.jabperiode;
                    _txtKendala.text = snap.data!.kendala;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtNama,
                          focusNode: _focNama,
                          label: 'Nama Bumdes',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtTahun,
                          focusNode: _focTahun,
                          label: 'Tahun Berdiri',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                          keyboard: TextInputType.number,
                        ),
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtUnitUsaha,
                          focusNode: _focUnitUsaha,
                          label: 'Unit Usaha',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtOmset,
                          focusNode: _focOmset,
                          label: 'Omzet per tahun',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                        ),
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtJabatan,
                          focusNode: _focJabatan,
                          label: 'Jabatan Dalam Bumdes',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtJabPeriode,
                          focusNode: _focJabPeriode,
                          label: 'Periode Jabatan',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtKendala,
                          focusNode: _focKendala,
                          label: 'Kendala / Permasalahan',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: ElevatedButton(
                            child: const Text('Simpan'),
                            onPressed: () async {
                              if (_txtNama.text.isEmpty) {
                                AFwidget.snack(
                                    context, 'Nama Bumdes harus diisi.');
                                _focNama.requestFocus();
                                return;
                              }

                              if (_txtTahun.text.isEmpty) {
                                AFwidget.snack(
                                    context, 'Tahun berdiri harus diisi.');
                                _focNama.requestFocus();
                                return;
                              }

                              if (_txtUnitUsaha.text.isEmpty) {
                                AFwidget.snack(
                                    context, 'Unit usaha harus diisi.');
                                _focUnitUsaha.requestFocus();
                                return;
                              }

                              if (_txtOmset.text.isEmpty) {
                                AFwidget.snack(context, 'Omzet harus diisi.');
                                _focOmset.requestFocus();
                                return;
                              }

                              if (_txtJabatan.text.isEmpty) {
                                AFwidget.snack(context,
                                    'Jabatan dalam bumdes harus diisi.');
                                _focJabatan.requestFocus();
                                return;
                              }

                              if (_txtJabPeriode.text.isEmpty) {
                                AFwidget.snack(
                                    context, 'Periode jabatan harus diisi.');
                                _focJabPeriode.requestFocus();
                                return;
                              }

                              BumdesModel hasilBumdes = BumdesModel(
                                nik: widget.nik,
                                nama: _txtNama.text,
                                tahun: int.parse(_txtTahun.text),
                                unitusaha: _txtUnitUsaha.text,
                                omset: _txtOmset.text,
                                jabatan: _txtJabatan.text,
                                jabperiode: _txtJabPeriode.text,
                                kendala: _txtKendala.text,
                              );

                              AFwidget.circularDialog(context);
                              var a = await bumdesBloc.edit(hasilBumdes);
                              Navigator.of(context).pop();

                              if (a['status'].toString() == '1') {
                                await AFwidget.alertDialog(
                                  context,
                                  const Text('Data Bumdes berhasil disimpan.'),
                                );
                                Navigator.of(context)
                                    .pop<BumdesModel>(hasilBumdes);
                              } else {
                                AFwidget.alertDialog(
                                    context, Text(a['message'].toString()));
                              }
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return AFwidget.circularProgress();
                  }
                }),
          ),
        ),
      ),
    );
  }
}

class KedudukanPage extends StatefulWidget {
  final String nik;

  const KedudukanPage({
    required this.nik,
    Key? key,
  }) : super(key: key);

  @override
  _KedudukanPageState createState() => _KedudukanPageState();
}

class _KedudukanPageState extends State<KedudukanPage> {
  final BumdesBloc bumdesBloc = BumdesBloc();

  @override
  Widget build(BuildContext context) {
    double lebarA = 130;
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.fromLTRB(10, 5, 10, 70),
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          color: Colors.white,
          child: FutureBuilder<KedudukanModel>(
            future: bumdesBloc.getKedudukan(widget.nik),
            builder: (context, snapFut) {
              if (snapFut.hasData) {
                return StreamBuilder<KedudukanModel>(
                  stream: bumdesBloc.streamKedudukan,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                  width: lebarA,
                                  child: const Text('Kedudukan di Desa')),
                              const Text(' : '),
                              Text(
                                snap.data!.jabatan,
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
                                  width: lebarA, child: const Text('Periode')),
                              const Text(' : '),
                              Text(
                                snap.data!.periode,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                            child: ElevatedButton(
                              child: const Text('Edit'),
                              onPressed: () async {
                                var a = await Navigator.of(context)
                                    .push<KedudukanModel>(
                                  MaterialPageRoute(
                                    builder: (context) => KedudukanForm(
                                      nik: widget.nik,
                                    ),
                                  ),
                                );
                                if (a != null) {
                                  bumdesBloc.fetchKedudukan(a);
                                }
                              },
                            ),
                          ),
                        ],
                      );
                    } else {
                      bumdesBloc.fetchKedudukan(snapFut.data!);
                      return AFwidget.circularProgress();
                    }
                  },
                );
              } else {
                return AFwidget.circularProgress();
              }
            },
          ),
        ),
      ),
    );
  }
}

class KedudukanForm extends StatefulWidget {
  final String nik;

  const KedudukanForm({
    required this.nik,
    Key? key,
  }) : super(key: key);

  @override
  _KedudukanFormState createState() => _KedudukanFormState();
}

class _KedudukanFormState extends State<KedudukanForm> {
  final BumdesBloc bumdesBloc = BumdesBloc();
  final TextEditingController _txtJabatan = TextEditingController();
  final TextEditingController _txtPeriode = TextEditingController();
  late FocusNode _focJabatan;
  late FocusNode _focPeriode;

  @override
  void initState() {
    super.initState();
    _focJabatan = FocusNode();
    _focPeriode = FocusNode();
  }

  @override
  void dispose() {
    _focJabatan.dispose();
    _focPeriode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Kedudukan'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.fromLTRB(10, 5, 10, 70),
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
            color: Colors.white,
            child: FutureBuilder<KedudukanModel>(
                future: bumdesBloc.getKedudukan(widget.nik),
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtJabatan.text = snap.data!.jabatan;
                    _txtPeriode.text = snap.data!.periode;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtJabatan,
                          focusNode: _focJabatan,
                          label: 'Kedudukan di Desa',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        AFwidget.textField(
                          context: context,
                          kontroler: _txtPeriode,
                          focusNode: _focPeriode,
                          label: 'Periode',
                          suffix: const Icon(
                            Icons.person,
                            size: 20,
                            color: Colors.transparent,
                          ),
                          textCapitalization: TextCapitalization.characters,
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          child: ElevatedButton(
                            child: const Text('Simpan'),
                            onPressed: () async {
                              if (_txtJabatan.text.isEmpty) {
                                AFwidget.snack(context, 'Jabatan harus diisi.');
                                _focJabatan.requestFocus();
                                return;
                              }

                              if (_txtPeriode.text.isEmpty) {
                                AFwidget.snack(context, 'Periode harus diisi.');
                                _focPeriode.requestFocus();
                                return;
                              }

                              KedudukanModel hasilKedudukan = KedudukanModel(
                                nik: widget.nik,
                                jabatan: _txtJabatan.text,
                                periode: _txtPeriode.text,
                              );

                              AFwidget.circularDialog(context);
                              var a = await bumdesBloc
                                  .editKedudukan(hasilKedudukan);
                              Navigator.of(context).pop();

                              if (a['status'].toString() == '1') {
                                await AFwidget.alertDialog(
                                  context,
                                  const Text(
                                      'Data Kedudukan berhasil disimpan.'),
                                );
                                Navigator.of(context)
                                    .pop<KedudukanModel>(hasilKedudukan);
                              } else {
                                AFwidget.alertDialog(
                                    context, Text(a['message'].toString()));
                              }
                            },
                          ),
                        )
                      ],
                    );
                  } else {
                    return AFwidget.circularProgress();
                  }
                }),
          ),
        ),
      ),
    );
  }
}
