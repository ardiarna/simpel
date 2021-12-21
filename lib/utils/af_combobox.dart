import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_sliver_subheader.dart';
import 'package:simpel/utils/af_widget.dart';

class Opsi {
  String id;
  String label;

  Opsi({
    this.id = '',
    this.label = '',
  });

  factory Opsi.dariMap(Map<String, dynamic> map) {
    return Opsi(
      id: AFconvert.keString(map['id']),
      label: AFconvert.keString(map['label']),
    );
  }
}

class DaftarOpsi extends StatefulWidget {
  final List<Opsi> listOpsi;
  final String idSelected;
  final bool withCari;

  const DaftarOpsi({
    required this.listOpsi,
    this.idSelected = '',
    this.withCari = true,
    Key? key,
  }) : super(key: key);

  @override
  _DaftarOpsiState createState() => _DaftarOpsiState();
}

class _DaftarOpsiState extends State<DaftarOpsi> {
  List<Opsi> _listFilter = [];
  final _strOpsi = StreamController<List<Opsi>>.broadcast();
  Stream<List<Opsi>> get streamOpsi => _strOpsi.stream;
  void fetchOpsi(List<Opsi> list) async {
    _strOpsi.sink.add(list);
  }

  bool _isAwalFetchOpsi = true;

  @override
  void dispose() {
    _strOpsi.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        widget.withCari
            ? AFsliverSubHeader(
                maxHeight: 60,
                minHeight: 60,
                child: AFwidget.textField(
                  context: context,
                  label: 'Cari ...',
                  prefix: const Icon(Icons.search),
                  onchanged: (value) {
                    _listFilter = [];
                    for (var opsi in widget.listOpsi) {
                      bool cek = opsi.label
                          .toLowerCase()
                          .contains(value.toLowerCase());
                      if (cek) {
                        _listFilter.add(opsi);
                      }
                    }
                    fetchOpsi(_listFilter);
                  },
                ),
              )
            : const SliverPadding(padding: EdgeInsets.all(0)),
        const SliverPadding(padding: EdgeInsets.all(5)),
        StreamBuilder<List<Opsi>>(
          stream: streamOpsi,
          builder: (context, snap) {
            if (snap.hasData) {
              if (snap.data!.isNotEmpty) {
                return SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      return GestureDetector(
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(0, 0, 15, 0),
                          child: Row(
                            children: [
                              Radio<String>(
                                value: snap.data![i].id,
                                groupValue: widget.idSelected,
                                onChanged: (value) {
                                  Navigator.pop(context, snap.data![i]);
                                },
                              ),
                              Text(
                                snap.data![i].label,
                              ),
                            ],
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context, snap.data![i]);
                        },
                      );
                    },
                    childCount: snap.data!.length,
                  ),
                );
              } else {
                return const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(15),
                    child: Text('Data tidak ditemukan.'),
                  ),
                );
              }
            } else {
              if (_isAwalFetchOpsi) {
                _isAwalFetchOpsi = false;
                fetchOpsi(widget.listOpsi);
              }
              return SliverToBoxAdapter(
                child: AFwidget.circularProgress(),
              );
            }
          },
        ),
      ],
    );
  }
}

abstract class AFcombobox {
  static Future<Opsi?> modalBottom({
    required BuildContext context,
    required List<Opsi> listOpsi,
    String idSelected = '',
    String judul = '',
    double? tinggi,
    bool isScrollControlled = true,
    bool withCari = true,
  }) {
    return showModalBottomSheet<Opsi>(
      constraints: BoxConstraints(
        maxHeight: tinggi ?? MediaQuery.of(context).size.height - 29,
      ),
      backgroundColor: Colors.transparent,
      context: context,
      isScrollControlled: isScrollControlled,
      builder: (context) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            GestureDetector(
              child: Container(
                margin: const EdgeInsets.only(right: 15, bottom: 10),
                alignment: Alignment.center,
                height: 35,
                width: 35,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.close),
              ),
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                  ),
                ),
                child: Text(
                  judul,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                color: Colors.white,
                child: DaftarOpsi(
                  listOpsi: listOpsi,
                  idSelected: idSelected,
                  withCari: withCari,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
