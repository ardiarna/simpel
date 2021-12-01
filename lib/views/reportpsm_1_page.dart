import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_tabel.dart';
import 'package:simpel/utils/af_widget.dart';

class ReportPsmSatu extends StatefulWidget {
  final MemberModel team;

  const ReportPsmSatu({required this.team, Key? key}) : super(key: key);

  @override
  _ReportPsmSatuState createState() => _ReportPsmSatuState();
}

class _ReportPsmSatuState extends State<ReportPsmSatu> {
  PelatihanBloc _pelatihanBloc = PelatihanBloc();

  List<String> kolom = ['Pelatihan', 'Tahun', 'Angkatan'];
  List<double> lebar = [100, 70, 80];
  double tinggi = 50;

  Future<List<List<String>>> getData() async {
    List<List<String>> list = [];
    var items = await _pelatihanBloc.getPelatihanTeam(widget.team.nik);
    for (var item in items) {
      List<String> a = [];
      a.add(item.singkatan);
      a.add(item.tahun.toString());
      a.add(item.angkatan.toString());
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
    return Scaffold(
      appBar: AppBar(
        title: Text('List Pelatihan'),
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
