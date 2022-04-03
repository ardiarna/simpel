import 'package:basic_utils/basic_utils.dart';
import 'package:flutter/material.dart';
import 'package:simpel/blocs/pelatihan_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/models/rekrutmen_model.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/views/pelatihan_form.dart';
import 'package:simpel/views/saran_dinas_page.dart';
import 'package:simpel/views/saran_psm_page.dart';

class PelatihanPage extends StatefulWidget {
  final MemberModel member;
  const PelatihanPage({
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _PelatihanPageState createState() => _PelatihanPageState();
}

class _PelatihanPageState extends State<PelatihanPage> {
  final PelatihanBloc _pelatihanBloc = PelatihanBloc();

  @override
  Widget build(BuildContext context) {
    double _lebarMedia = MediaQuery.of(context).size.width;
    double lebarA = 65;
    return FutureBuilder<List<PelatihanModel>>(
      future: _pelatihanBloc.getPelatihans(widget.member.nik),
      builder: (context, snap) {
        if (snap.hasData) {
          String labelStatus = '';
          bool statusYa = false;
          if (snap.data!.length > 0) {
            return SliverList(
              delegate: SliverChildBuilderDelegate((context, i) {
                if (snap.data![i].fstatus == 'Y') {
                  labelStatus = 'Lihat';
                  statusYa = true;
                } else if (snap.data![i].fstatus == 'N') {
                  labelStatus = 'Tidak Lulus Seleksi';
                  statusYa = false;
                } else {
                  labelStatus = 'Belum Diseleksi';
                  statusYa = false;
                }
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
                          Expanded(
                            child: Text(
                              '${snap.data![i].singkatan} ${snap.data![i].angkatan}-${snap.data![i].tahun}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 5)),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              '${snap.data![i].nama}',
                              style: const TextStyle(
                                fontSize: 11,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 5)),
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
                        future: _pelatihanBloc.getRekrutmen(snap.data![i].kode),
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
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.calendar_today_outlined,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    width: lebarA,
                                    child: const Text('Tanggal'),
                                  ),
                                  const Text(' : '),
                                  Expanded(
                                    child: Text(
                                      '${AFconvert.matDate(rekrutmen.tglMulai)} s/d ${AFconvert.matDate(rekrutmen.tglSelesai)}',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Padding(
                                  padding: EdgeInsets.only(bottom: 10)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(right: 5),
                                    child: Icon(
                                      Icons.location_on_outlined,
                                      size: 20,
                                      color: Colors.green,
                                    ),
                                  ),
                                  SizedBox(
                                    width: lebarA,
                                    child: const Text('Lokasi'),
                                  ),
                                  const Text(' : '),
                                  Expanded(
                                    child: Text(
                                      StringUtils.capitalize(
                                        '${rekrutmen.provLabel}, ${rekrutmen.kabLabel},  ${rekrutmen.kecLabel}, ${rekrutmen.kelLabel}.',
                                        allWords: true,
                                      ),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                      const Padding(padding: EdgeInsets.only(bottom: 20)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          statusYa
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: ElevatedButton(
                                    child: Text('Saran Dinas'),
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.all(10),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SaranDinasPage(
                                            nikPeserta: widget.member.nik,
                                            pelatihan: snap.data![i],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          statusYa
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 5),
                                  child: ElevatedButton(
                                    child: Text('Saran Psm'),
                                    style: TextButton.styleFrom(
                                      minimumSize: Size.zero,
                                      padding: EdgeInsets.all(10),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) => SaranPage(
                                            member: widget.member,
                                            pelatihan: snap.data![i],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          ElevatedButton(
                            child: Text(
                              labelStatus,
                              style: TextStyle(
                                color: statusYa ? Colors.white : Colors.red,
                              ),
                            ),
                            style: TextButton.styleFrom(
                              backgroundColor:
                                  statusYa ? Colors.green : Colors.white,
                            ),
                            onPressed: statusYa
                                ? () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => PelatihanForm(
                                          member: widget.member,
                                          pelatihan: snap.data![i],
                                        ),
                                      ),
                                    );
                                  }
                                : null,
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }, childCount: snap.data!.length),
            );
          } else {
            return SliverToBoxAdapter(
              child: Container(
                width: _lebarMedia,
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
                margin: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                child: FutureBuilder<String>(
                  future: _pelatihanBloc.getIdentity('home'),
                  builder: (context, snap) {
                    if (snap.hasData) {
                      return AFwidget.html(snap.data!);
                    } else {
                      return AFwidget.circularProgress();
                    }
                  },
                ),
              ),
            );
          }
        } else {
          return SliverToBoxAdapter(child: AFwidget.circularProgress());
        }
      },
    );
  }
}
