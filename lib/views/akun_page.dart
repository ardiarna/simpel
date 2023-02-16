import 'package:flutter/material.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_cache.dart';
import 'package:simpel/utils/af_constant.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/utils/db_helper.dart';
import 'package:simpel/utils/font_awesome5.dart';
import 'package:simpel/views/about_page.dart';
import 'package:simpel/views/biodata_page.dart';
import 'package:simpel/views/biofoto_page.dart';
import 'package:simpel/views/biopassword_page.dart';
import 'package:simpel/views/bumdes_page.dart';

class AkunPage extends StatefulWidget {
  final MemberModel member;
  const AkunPage({required this.member, Key? key}) : super(key: key);

  @override
  _AkunPageState createState() => _AkunPageState();
}

class _AkunPageState extends State<AkunPage> {
  final AFcache _aFcache = AFcache();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 15),
          color: Colors.white,
          child: Center(
            child: GestureDetector(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade500,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(55),
                      ),
                    ),
                    child: widget.member.foto != ''
                        ? ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(55),
                            ),
                            child: AFwidget.cachedNetworkImage(
                              '${DBHelper.dirImage}${widget.member.kategori}/${widget.member.foto}',
                              fit: BoxFit.fill,
                              width: 150,
                              height: 150,
                            ),
                          )
                        : const Icon(
                            Icons.person,
                            size: 100,
                          ),
                  ),
                  Container(
                    height: 30,
                    width: 30,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt),
                  ),
                ],
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => BiofotoPage(
                      member: widget.member,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        kontener(
          ikon: FontAwesome5.idCardAlt,
          label: widget.member.nik,
          aksi: () {},
          withPanah: false,
        ),
        kontener(
          ikon: FontAwesome5.idCard,
          label: widget.member.nama,
          aksi: () {},
          withPanah: false,
        ),
        widget.member.kategori == 'member'
            ? kontener(
          ikon: FontAwesome5.storeAlt,
          label: 'Data Bumdes',
          aksi: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BumdesPage(
                  nik: widget.member.nik,
                ),
              ),
            );
          },
        )
            : Container(),
        widget.member.kategori == 'member'
            ? kontener(
                ikon: FontAwesome5.userTie,
                label: 'Kedudukan di Desa',
                aksi: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => KedudukanPage(
                        nik: widget.member.nik,
                      ),
                    ),
                  );
                },
              )
            : Container(),
        kontener(
          ikon: FontAwesome5.userEdit,
          label: 'Ubah Data Diri',
          aksi: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BiodataPage(
                  member: widget.member,
                ),
              ),
            );
          },
        ),
        kontener(
          ikon: FontAwesome5.key,
          label: 'Ubah Password',
          aksi: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => BiopasswordPage(
                  member: widget.member,
                ),
              ),
            );
          },
        ),
        kontener(
          ikon: FontAwesome5.infoCircle,
          label: 'Tentang Aplikasi',
          aksi: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => const AboutPage(),
              ),
            );
          },
        ),
        Container(
          margin: const EdgeInsets.only(top: 7),
          color: Colors.white,
          child: TextButton(
            child: const Text(
              'Logout',
              style: TextStyle(
                fontSize: 15,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              _aFcache.removeUser().whenComplete(() {
                Navigator.of(context).pushReplacementNamed(splashRoute);
              });
            },
          ),
        ),
        Container(
          alignment: Alignment.center,
          margin: const EdgeInsets.only(top: 30, bottom: 15),
          child: Text(
            'Versi Aplikasi 1.0.0',
            style: TextStyle(
              color: Colors.grey.shade700,
            ),
          ),
        ),
      ],
    );
  }

  Widget kontener({
    required IconData ikon,
    required String label,
    required void Function()? aksi,
    bool withPanah = true,
  }) {
    return GestureDetector(
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(15, 0, 0, 0),
        child: Row(
          children: [
            Icon(
              ikon,
              color: Colors.green,
            ),
            Expanded(
              child: Container(
                margin: const EdgeInsets.fromLTRB(15, 0, 5, 0),
                padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        label,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          // fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Visibility(
                      visible: withPanah,
                      child: const Icon(
                        Icons.arrow_forward_ios,
                        size: 15,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      onTap: aksi,
    );
  }
}
