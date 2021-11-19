import 'package:flutter/material.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/models/pelatihan_model.dart';
import 'package:simpel/views/rtl_real_page.dart';
import 'package:simpel/views/rtl_target_page.dart';

class RTLTab extends StatefulWidget {
  final MemberModel member;
  final PelatihanModel pelatihan;

  const RTLTab({
    required this.member,
    required this.pelatihan,
    Key? key,
  }) : super(key: key);

  @override
  _RTLTabState createState() => _RTLTabState();
}

class _RTLTabState extends State<RTLTab> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 35,
                width: double.infinity,
                alignment: Alignment.center,
                color: Colors.green.shade100,
                child: Text(
                  'Rencana Tindak Lanjut (RTL)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                height: 30,
                color: Colors.green.shade100,
                child: TabBar(
                  labelColor: Colors.black,
                  unselectedLabelColor: Colors.black54,
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25),
                    ),
                    color: Colors.white,
                  ),
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Target"),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Text("Realisasi"),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 65),
            child: TabBarView(
              children: [
                RTLtargetPage(
                  member: widget.member,
                  pelatihan: widget.pelatihan,
                ),
                RTLrealPage(
                  member: widget.member,
                  pelatihan: widget.pelatihan,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
