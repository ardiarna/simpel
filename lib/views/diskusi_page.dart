import 'package:flutter/material.dart';
import 'package:simpel/blocs/diskusi_bloc.dart';
import 'package:simpel/models/giat_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/utils/af_widget.dart';

class DiskusiPage extends StatefulWidget {
  final MemberModel member;
  const DiskusiPage({required this.member, Key? key}) : super(key: key);

  @override
  _DiskusiPageState createState() => _DiskusiPageState();
}

class _DiskusiPageState extends State<DiskusiPage> {
  final DiskusiBloc _diskusiBloc = DiskusiBloc();

  @override
  Widget build(BuildContext context) {
    // double lebarA = 100;
    return Container(
      color: Colors.white,
      child: CustomScrollView(
        slivers: [
          const SliverPadding(padding: EdgeInsets.all(1)),
          FutureBuilder<List<PelatihanModel>>(
            future: _diskusiBloc.getPelatihans(widget.member.nik),
            builder: (context, snap) {
              if (snap.hasData) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate((context, i) {
                    return Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border(
                          bottom: BorderSide(color: Colors.grey, width: 1),
                        ),
                      ),
                      child: Row(
                        children: [
                          FutureBuilder<GiatModel>(
                              future: _diskusiBloc
                                  .getGiatId(snap.data![i].giatKode),
                              builder: (context, snapGiat) {
                                if (snapGiat.hasData &&
                                    snapGiat.data!.image != '') {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    child: AFwidget.networkImage(
                                      _diskusiBloc.dirImageGiat +
                                          snapGiat.data!.image,
                                      fit: BoxFit.fill,
                                      width: 50,
                                      height: 50,
                                    ),
                                  );
                                } else {
                                  return Container(
                                    height: 50,
                                    width: 50,
                                    decoration: const BoxDecoration(
                                      color: Colors.grey,
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }
                              }),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
                            child: Column(
                              children: [
                                Text(
                                  snap.data![i].nama,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
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
