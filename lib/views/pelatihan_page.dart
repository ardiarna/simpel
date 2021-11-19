import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/giat_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/pelatihan_form.dart';

class PelatihanPage extends StatefulWidget {
  final MemberModel member;
  const PelatihanPage({required this.member, Key? key}) : super(key: key);

  @override
  _PelatihanPageState createState() => _PelatihanPageState();
}

class _PelatihanPageState extends State<PelatihanPage> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();

  @override
  Widget build(BuildContext context) {
    double lebarA = 100;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pelatihan'),
      ),
      body: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.all(1)),
          FutureBuilder<List<PelatihanModel>>(
            future: _pelatihanBloc.getPelatihans(widget.member.nik),
            builder: (context, snap) {
              if (snap.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Container(
                      margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                      padding: const EdgeInsets.fromLTRB(10, 20, 10, 15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
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
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: lebarA,
                                child: const Text('Nama Pelatihan'),
                              ),
                              const Text(' : '),
                              FutureBuilder<GiatModel>(
                                  future: _pelatihanBloc
                                      .getGiatId(snap.data![i].giatKode),
                                  builder: (context, snapGiat) {
                                    String singkatan = '';
                                    if (snapGiat.hasData)
                                      singkatan =
                                          '(${snapGiat.data!.singkatan})';
                                    return Expanded(
                                      child: Text(
                                        '${snap.data![i].nama} $singkatan',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    );
                                  }),
                            ],
                          ),
                          const Padding(padding: EdgeInsets.only(bottom: 15)),
                          Row(
                            children: [
                              SizedBox(
                                width: lebarA,
                                child: const Text('Tahun'),
                              ),
                              const Text(' : '),
                              Text(
                                snap.data![i].tahun.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(right: 25),
                              ),
                              const Text('Angkatan : '),
                              Text(
                                snap.data![i].angkatan.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: lebarA,
                          //       child: const Text('Sertifikat'),
                          //     ),
                          //     const Text(' : '),
                          //     Container(
                          //       padding:
                          //           const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          //       decoration: BoxDecoration(
                          //         color: snap.data![i].fileSertifikat != ''
                          //             ? Colors.green
                          //             : Colors.red,
                          //         borderRadius: const BorderRadius.all(
                          //           Radius.circular(15),
                          //         ),
                          //       ),
                          //       child: Text(
                          //         snap.data![i].fileSertifikat != ''
                          //             ? 'Sudah Terbit'
                          //             : 'Belum Terbit',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //     IconButton(
                          //       icon: Icon(
                          //         Icons.download,
                          //         color: snap.data![i].fileSertifikat != ''
                          //             ? Colors.green
                          //             : Colors.transparent,
                          //       ),
                          //       onPressed: snap.data![i].fileSertifikat != ''
                          //           ? () {}
                          //           : null,
                          //     ),
                          //   ],
                          // ),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: lebarA,
                          //       child: const Text('Evaluasi'),
                          //     ),
                          //     const Text(' : '),
                          //     Container(
                          //       padding:
                          //           const EdgeInsets.fromLTRB(15, 5, 15, 5),
                          //       decoration: BoxDecoration(
                          //         color: snap.data![i].fevaluasi == 'Y'
                          //             ? Colors.green
                          //             : Colors.red,
                          //         borderRadius: const BorderRadius.all(
                          //           Radius.circular(15),
                          //         ),
                          //       ),
                          //       child: Text(
                          //         snap.data![i].fevaluasi == 'Y'
                          //             ? 'Sudah'
                          //             : 'Belum',
                          //         style: TextStyle(
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          FutureBuilder<RekrutmenModel>(
                              future: _pelatihanBloc
                                  .getRekrutmen(snap.data![i].kode),
                              builder: (context, snapRek) {
                                RekrutmenModel rekrutmen = snapRek.hasData
                                    ? snapRek.data!
                                    : RekrutmenModel();
                                return Column(
                                  children: [
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 15)),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.calendar_today_outlined,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                        const Padding(
                                            padding: EdgeInsets.only(right: 5)),
                                        const Text('Tanggal : '),
                                        Text(
                                          AFconvert.matDate(rekrutmen.tglMulai),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Text(' s/d '),
                                        Text(
                                          AFconvert.matDate(
                                              rekrutmen.tglSelesai),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Padding(
                                        padding: EdgeInsets.only(bottom: 10)),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.location_on_outlined,
                                          size: 20,
                                          color: Colors.green,
                                        ),
                                        Padding(
                                            padding: EdgeInsets.only(right: 5)),
                                        Text('Lokasi : '),
                                      ],
                                    ),
                                    Container(
                                      margin: const EdgeInsets.fromLTRB(
                                          25, 5, 0, 10),
                                      child: Text(
                                        '${rekrutmen.dusun} KEL/DESA : ${rekrutmen.kelLabel}, KEC : ${rekrutmen.kecLabel}, KAB : ${rekrutmen.kabLabel}, PROV : ${rekrutmen.provLabel}.',
                                        maxLines: 4,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                );
                              }),
                          Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              child: Text('Lihat'),
                              style: TextButton.styleFrom(
                                backgroundColor: Colors.limeAccent.shade700,
                              ),
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PelatihanForm(
                                      member: widget.member,
                                      pelatihan: snap.data![i],
                                    ),
                                  ),
                                );
                              },
                            ),
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
      ),
    );
  }
}
