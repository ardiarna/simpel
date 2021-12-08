import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_tabel.dart';
import 'package:simpel/utils/af_widget.dart';

class ReportPsmDua extends StatefulWidget {
  final MemberModel team;
  final String pelatihanKode;

  const ReportPsmDua({
    required this.team,
    required this.pelatihanKode,
    Key? key,
  }) : super(key: key);

  @override
  _ReportPsmDuaState createState() => _ReportPsmDuaState();
}

class _ReportPsmDuaState extends State<ReportPsmDua> {
  PelatihanBloc _pelatihanBloc = PelatihanBloc();

  List<String> kolom = ['Peserta', 'Bumdes', 'Desa', 'Saran PSM'];
  List<double> lebar = [100, 100, 200, 150];
  double tinggi = 100;

  Future<List<List<String>>> getData() async {
    List<List<String>> list = [];
    var items = await _pelatihanBloc.getPeserta(widget.pelatihanKode);
    for (var item in items) {
      List<String> a = [];
      a.add(item.nama);
      a.add(item.bumdes);
      a.add(
          '${item.dusun} KEL/DESA : ${item.kelLabel}, KEC : ${item.kecLabel}, KAB : ${item.kabLabel}, PROV : ${item.provLabel}.');
      var b = await _pelatihanBloc.getSaranIdPsm(
        kode: widget.pelatihanKode,
        nik: item.nik,
        psmNik: widget.team.nik,
      );
      a.add(b.psmSaran);
      list.add(a);
    }
    return list;
  }

  @override
  void dispose() {
    _pelatihanBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double tinggiTabel = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text('List Peserta Pelatihan'),
      ),
      body: FutureBuilder<List<List<String>>>(
          future: getData(),
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data!.length > 0) {
                return AFtabelFixedScroll(
                  kolom: kolom,
                  lebar: lebar,
                  tinggi: tinggi,
                  data: snap.data!,
                  tinggiTabel: tinggiTabel,
                );
              } else {
                return Center(child: Text('Data belum tersedia'));
              }
            } else {
              return AFwidget.circularProgress();
            }
          }),
    );
  }
}
