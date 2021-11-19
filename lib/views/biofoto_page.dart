import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simpel/blocs/member_bloc.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/utils/db_helper.dart';
import 'package:simpel/views/home_page.dart';

class BiofotoPage extends StatefulWidget {
  final MemberModel member;
  const BiofotoPage({
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _BiofotoPageState createState() => _BiofotoPageState();
}

class _BiofotoPageState extends State<BiofotoPage> {
  final MemberBloc _memberBloc = MemberBloc();

  @override
  void dispose() {
    _memberBloc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Foto Profil'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
            color: Colors.white,
            child: Column(
              children: [
                widget.member.foto != ''
                    ? InteractiveViewer(
                        child: AFwidget.networkImage(
                          DBHelper.dirImage + 'member/' + widget.member.foto,
                          fit: BoxFit.fitWidth,
                        ),
                      )
                    : const Icon(
                        Icons.person,
                        size: 100,
                      ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
                  child: Text('Ganti Foto Profil'),
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.add_a_photo_outlined),
                  title: const Text('Ambil Foto dari Kamera'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    var a = await ImagePicker().pickImage(
                      source: ImageSource.camera,
                    );
                    if (a != null) {
                      AFwidget.circularDialog(context);
                      var b = await _memberBloc.editFoto(
                        nik: widget.member.nik,
                        pathFoto: a.path,
                      );
                      Navigator.of(context).pop();
                      if (b['status'].toString() == '1') {
                        widget.member.foto = b['data']['pas_foto'];
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              menu: 3,
                              page: 'saya',
                              member: widget.member,
                            ),
                          ),
                        );
                      } else {
                        AFwidget.alertDialog(
                            context, Text(b['message'].toString()));
                      }
                    }
                  },
                ),
                const Divider(),
                ListTile(
                  dense: true,
                  leading: const Icon(Icons.add_photo_alternate_outlined),
                  title: const Text('Ambil Foto dari Galeri'),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                    color: Colors.red,
                  ),
                  onTap: () async {
                    var a = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (a != null) {
                      AFwidget.circularDialog(context);
                      var b = await _memberBloc.editFoto(
                        nik: widget.member.nik,
                        pathFoto: a.path,
                      );
                      Navigator.of(context).pop();
                      if (b['status'].toString() == '1') {
                        widget.member.foto = b['data']['pas_foto'];
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => HomePage(
                              menu: 3,
                              page: 'saya',
                              member: widget.member,
                            ),
                          ),
                        );
                      } else {
                        AFwidget.alertDialog(
                            context, Text(b['message'].toString()));
                      }
                    }
                  },
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
