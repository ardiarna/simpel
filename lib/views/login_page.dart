import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simpel/blocs/beranda_bloc.dart';
import 'package:simpel/blocs/member_bloc.dart';
import 'package:simpel/chat/data/datasource_contract.dart';
import 'package:simpel/chat/data/sqflite_datasource.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/models/message_group_model.dart';
import 'package:simpel/chat/services/group_service.dart';
import 'package:simpel/chat/services/user_service.dart';
import 'package:simpel/chat/services/user_service_contract.dart';
import 'package:simpel/chat/viewmodels/chats_view_model.dart';
import 'package:simpel/chat/views/color_generator.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_cache.dart';
import 'package:simpel/utils/af_combobox.dart';
import 'package:simpel/utils/af_convert.dart';
import 'package:simpel/utils/af_page_transisi.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simpel/utils/db_factory.dart';
import 'package:simpel/views/home_page.dart';
import 'package:sqflite/sqflite.dart';

List<Opsi> _listOpsiAgama = [];
List<Opsi> _listOpsiKelamin = [];
List<Opsi> _listOpsiKawin = [];
List<Opsi> _listOpsiPendidikan = [];
List<Opsi> _listOpsiProvinsi = [];

Widget logo() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: const [
      Padding(padding: EdgeInsets.all(15)),
      Image(
        image: AssetImage('images/logo.png'),
      ),
      Padding(
        padding: EdgeInsets.fromLTRB(15, 0, 15, 30),
        child: Text(
          'Simpel',
          style: TextStyle(
            color: Colors.green,
            fontSize: 27,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ],
  );
}

Widget kepalaStep(int step, {required double lebar}) {
  double pjgGaris = (lebar - 300) / 3;
  return Padding(
    padding: const EdgeInsets.only(bottom: 10),
    child: SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(left: 15, right: 5),
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step == 1 ? Colors.blue : Colors.grey,
            ),
            child: const Text(
              '1',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: step == 1 ? 85 : 0,
            child: Text(
              step == 1 ? 'Data Login' : '',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            width: pjgGaris,
            child: const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step == 2 ? Colors.blue : Colors.grey,
            ),
            child: const Text(
              '2',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: step == 2 ? 85 : 0,
            child: Text(
              step == 2 ? 'Data Diri' : '',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            width: pjgGaris,
            child: const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step == 3 ? Colors.blue : Colors.grey,
            ),
            child: const Text(
              '3',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: step == 3 ? 85 : 0,
            child: Text(
              step == 3 ? 'Status Diri' : '',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            width: pjgGaris,
            child: const Divider(
              thickness: 2,
              color: Colors.grey,
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 5, right: 5),
            alignment: Alignment.center,
            height: 30,
            width: 30,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: step == 4 ? Colors.blue : Colors.grey,
            ),
            child: const Text(
              '4',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: step == 4 ? 85 : 0,
            child: Text(
              step == 4 ? 'Data Domisili' : '',
              style: const TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(padding: EdgeInsets.only(right: 10)),
        ],
      ),
    ),
  );
}

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final MemberBloc _memberBloc = MemberBloc();
  final AFcache _aFcache = AFcache();
  final TextEditingController _txtNIK = TextEditingController();
  final TextEditingController _txtPass = TextEditingController();
  final TextEditingController _txtLupa = TextEditingController();
  late FocusNode _focNIK;
  late FocusNode _focPass;
  late FocusNode _focLupa;
  String _kategori = '';
  List<Opsi> _listOpsiKategori = [];
  final Map<String, String> _mapKategori = {
    'member': 'Peserta',
    'team': 'Tim',
    // 'dinas': 'Dinas',
    '': '',
  };

  void fetchKategori(String nilai) {
    _kategori = nilai;
    _memberBloc.fetchKategori(nilai);
  }

  @override
  void initState() {
    super.initState();
    _aFcache.cekUserId().then((value) {
      if (value != null) {
        _aFcache.getUser().then((member) async {
          return Timer(
            const Duration(milliseconds: 1000),
            () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) =>
                    HomePage(menu: 0, page: 'beranda', member: member),
              ),
            ),
          );
        });
      }
    });
    _mapKategori.forEach((key, value) {
      _listOpsiKategori.add(Opsi(id: key, label: value));
    });
    _focNIK = FocusNode();
    _focPass = FocusNode();
    _focLupa = FocusNode();
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focNIK.dispose();
    _focPass.dispose();
    _focLupa.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topEnd,
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  logo(),
                  AFwidget.textField(
                    context: context,
                    kontroler: _txtNIK,
                    focusNode: _focNIK,
                    label: 'NIK',
                    suffix: const Icon(
                      Icons.person,
                      size: 20,
                      color: Colors.transparent,
                    ),
                  ),
                  StreamBuilder<bool>(
                    stream: _memberBloc.streamTampilPassword,
                    builder: (context, snapTampil) {
                      if (snapTampil.hasData) {
                        return AFwidget.textField(
                          context: context,
                          kontroler: _txtPass,
                          focusNode: _focPass,
                          label: 'Password',
                          obscuretext: !snapTampil.data!,
                          suffix: GestureDetector(
                            child: Icon(
                              snapTampil.data!
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              size: 20,
                            ),
                            onTap: () {
                              _memberBloc
                                  .fetchTampilPassword(!snapTampil.data!);
                            },
                          ),
                        );
                      } else {
                        _memberBloc.fetchTampilPassword(false);
                        return Container();
                      }
                    },
                  ),
                  StreamBuilder<String>(
                      stream: _memberBloc.streamKategori,
                      builder: (context, snapKategori) {
                        if (snapKategori.hasData) {
                          if (snapKategori.data == 'member') {
                            return Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.fromLTRB(5, 15, 5, 0),
                              child: TextButton(
                                child: const Text('Belum Punya Akun ? Daftar'),
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginStep1(
                                        member: MemberModel(),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          } else {
                            return Container();
                          }
                        } else {
                          if (_kategori == '') fetchKategori('member');
                          return Container();
                        }
                      }),
                  Container(
                    alignment: Alignment.topLeft,
                    padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                    child: TextButton(
                      child: const Text('Lupa Password ? Reset'),
                      onPressed: () {
                        AFwidget.simpleDialog(
                          context,
                          [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(10, 0, 10, 25),
                              child: AFwidget.textField(
                                context: context,
                                kontroler: _txtLupa,
                                focusNode: _focLupa,
                                label: 'NIK',
                                suffix: const Icon(
                                  Icons.person,
                                  size: 20,
                                  color: Colors.transparent,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ElevatedButton(
                                  child: const Text('Batal'),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.red.shade500,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                                ElevatedButton(
                                  child: const Text('Kirim'),
                                  onPressed: () {
                                    if (_txtLupa.text.isEmpty) {
                                      AFwidget.snack(
                                          context, 'NIK harus diisi.');
                                      _focLupa.requestFocus();
                                      return;
                                    }
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            ),
                          ],
                          judul: Text('Lupa Password'),
                        );
                      },
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(10),
                    child: ElevatedButton(
                      child: const Text('Login'),
                      onPressed: () async {
                        if (_txtNIK.text.isEmpty) {
                          AFwidget.snack(context, 'NIK harus diisi.');
                          _focNIK.requestFocus();
                          return;
                        }

                        if (_txtPass.text.isEmpty) {
                          AFwidget.snack(context, 'Password harus diisi.');
                          _focPass.requestFocus();
                          return;
                        }

                        AFwidget.circularDialog(context);
                        var a = await _memberBloc.signIn(
                          kategori: _kategori,
                          nik: _txtNIK.text,
                          password: _txtPass.text,
                        );
                        Navigator.of(context).pop();

                        if (a['status'].toString() == '1') {
                          a['data']['kategori'] = _kategori;
                          var member = MemberModel.dariMap(a['data']);
                          await _aFcache.setUser(member.kategori, member.nik);
                          BerandaBloc _berandaBloc = BerandaBloc();
                          var _listPelatihan =
                              await _berandaBloc.getPelatihanTeam(member.nik);
                          if (_listPelatihan.isNotEmpty) {
                            Database _db =
                                await LocalDatabaseFactory().createDatabase();
                            IDataSource _dataSource = SqfLiteDataSource(_db);
                            IUserService _userService = UserService();
                            MessageGroupService messageGroupService =
                                MessageGroupService();
                            ChatsViewModel chatsViewModel =
                                ChatsViewModel(_dataSource, _userService);
                            for (var _pelatihan in _listPelatihan) {
                              var messageGroup = MessageGroup(
                                name:
                                    '${_pelatihan.singkatan} ${_pelatihan.angkatan}-${_pelatihan.tahun}',
                                createdBy: member.nik,
                                members: [member.nik],
                                photoUrl: _pelatihan.giatImage,
                              );
                              var msgrupFromServer = await messageGroupService
                                  .create(messageGroup);
                              final membersId = msgrupFromServer.members
                                  .map((e) => {
                                        e: RandomColorGenerator.getColor()
                                            .value
                                            .toString()
                                      })
                                  .toList();
                              Chat chat = Chat(
                                msgrupFromServer.id,
                                ChatType.group,
                                membersId: membersId,
                                name: msgrupFromServer.name,
                                photoUrl: msgrupFromServer.photoUrl,
                              );
                              await chatsViewModel.createNewChat(chat);
                            }
                          }
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                menu: 0,
                                page: 'beranda',
                                member: member,
                              ),
                            ),
                          );
                        } else {
                          AFwidget.alertDialog(
                            context,
                            Text(a['message'].toString()),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            StreamBuilder<String>(
              stream: _memberBloc.streamKategori,
              builder: (context, snapKategori) {
                if (snapKategori.hasData) {
                  return Padding(
                    padding: EdgeInsets.fromLTRB(15, 5, 15, 15),
                    child: TextButton.icon(
                      icon: Text(
                        _mapKategori[_kategori]!,
                        style: TextStyle(
                          fontSize: 13,
                        ),
                      ),
                      label: Icon(
                        Icons.expand_more,
                        size: 19,
                      ),
                      style: TextButton.styleFrom(
                        side: BorderSide(color: Colors.green),
                      ),
                      onPressed: () async {
                        var a = await AFcombobox.modalBottom(
                          context: context,
                          listOpsi: _listOpsiKategori,
                          idSelected: _kategori,
                          judul: 'Login Sebagai :',
                          isScrollControlled: false,
                          withCari: false,
                        );
                        if (a != null) {
                          fetchKategori(a.id);
                        }
                      },
                    ),
                  );
                } else {
                  fetchKategori(_kategori);
                  return Container();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class LoginStep1 extends StatefulWidget {
  final MemberModel member;

  const LoginStep1({
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _LoginStep1State createState() => _LoginStep1State();
}

class _LoginStep1State extends State<LoginStep1> {
  final MemberBloc _memberBloc = MemberBloc();
  final TextEditingController _txtNIK = TextEditingController();
  final TextEditingController _txtPass = TextEditingController();
  final TextEditingController _txtNama = TextEditingController();
  final TextEditingController _txtEmail = TextEditingController();
  late FocusNode _focNIK;
  late FocusNode _focPass;
  late FocusNode _focNama;
  late FocusNode _focEmail;
  String _pathFoto = '';

  void fetchFoto(String nilai) {
    _pathFoto = nilai;
    _memberBloc.fetchFoto(nilai);
  }

  @override
  void initState() {
    super.initState();
    _txtNIK.text = widget.member.nik;
    _txtPass.text = widget.member.password;
    _txtNama.text = widget.member.nama;
    _txtEmail.text = widget.member.email;
    fetchFoto(widget.member.foto);
    _focNIK = FocusNode();
    _focPass = FocusNode();
    _focNama = FocusNode();
    _focEmail = FocusNode();
    if (_listOpsiAgama.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'agama')
          .then((value) => _listOpsiAgama = value);
    }
    if (_listOpsiKelamin.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'gender')
          .then((value) => _listOpsiKelamin = value);
    }
    if (_listOpsiKawin.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'kawin')
          .then((value) => _listOpsiKawin = value);
    }
    if (_listOpsiPendidikan.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'pendidikan')
          .then((value) => _listOpsiPendidikan = value);
    }
    if (_listOpsiProvinsi.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'domisili', mode: 'provinsi')
          .then((value) => _listOpsiProvinsi = value);
    }
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focNIK.dispose();
    _focPass.dispose();
    _focNama.dispose();
    _focEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(),
              kepalaStep(1, lebar: MediaQuery.of(context).size.width),
              AFwidget.textField(
                context: context,
                kontroler: _txtNIK,
                focusNode: _focNIK,
                label: 'NIK',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
              ),
              AFwidget.textField(
                context: context,
                kontroler: _txtNama,
                focusNode: _focNama,
                label: 'Nama',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              AFwidget.textField(
                context: context,
                kontroler: _txtEmail,
                focusNode: _focEmail,
                label: 'Email',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
              ),
              StreamBuilder<bool>(
                stream: _memberBloc.streamTampilPassword,
                builder: (context, snapTampil) {
                  if (snapTampil.hasData) {
                    return AFwidget.textField(
                      context: context,
                      kontroler: _txtPass,
                      focusNode: _focPass,
                      label: 'Password',
                      obscuretext: !snapTampil.data!,
                      suffix: GestureDetector(
                        child: Icon(
                          snapTampil.data!
                              ? Icons.visibility
                              : Icons.visibility_off,
                          size: 20,
                        ),
                        onTap: () {
                          _memberBloc.fetchTampilPassword(!snapTampil.data!);
                        },
                      ),
                    );
                  } else {
                    _memberBloc.fetchTampilPassword(false);
                    return Container();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade500,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(25),
                        ),
                      ),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomEnd,
                        children: [
                          StreamBuilder<String>(
                            stream: _memberBloc.streamFoto,
                            builder: (context, snapFoto) {
                              if (snapFoto.hasData) {
                                if (snapFoto.data != '') {
                                  return ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                      Radius.circular(25),
                                    ),
                                    child: Image.file(
                                      File(snapFoto.data!),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  );
                                } else {
                                  return const Icon(
                                    Icons.person,
                                    size: 100,
                                  );
                                }
                              } else {
                                fetchFoto(_pathFoto);
                                return const Icon(
                                  Icons.person,
                                  size: 100,
                                );
                              }
                            },
                          ),
                          Container(
                              height: 30,
                              width: 30,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt)),
                        ],
                      ),
                    ),
                    onTap: () {
                      AFwidget.modalBottom(
                        context: context,
                        isScrollControlled: false,
                        judul: 'Upload Pas Foto',
                        konten: Column(
                          children: [
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
                                  fetchFoto(a.path);
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            const Divider(),
                            ListTile(
                              dense: true,
                              leading: const Icon(
                                  Icons.add_photo_alternate_outlined),
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
                                  fetchFoto(a.path);
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(5, 20, 15, 10),
                    child: TextButton(
                      child: const Text('Sudah Punya Akun ? Login'),
                      onPressed: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Spacer(),
                    ElevatedButton(
                      child: const Text('Selanjutnya'),
                      onPressed: () async {
                        if (_txtNIK.text.isEmpty) {
                          AFwidget.snack(context, 'NIK harus diisi.');
                          _focNIK.requestFocus();
                          return;
                        }
                        if (_txtNIK.text.length < 16) {
                          AFwidget.snack(context,
                              'NIK minimal harus 16 karakter, anda baru memasukan ${_txtNIK.text.length} karakter.');
                          _focNIK.requestFocus();
                          return;
                        }
                        if (_txtNama.text.isEmpty) {
                          AFwidget.snack(context, 'Nama harus diisi.');
                          _focNama.requestFocus();
                          return;
                        }
                        bool emailValid = RegExp(
                                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(_txtEmail.text);
                        if (!emailValid) {
                          AFwidget.snack(context, 'Alamat email tidak benar.');
                          _focEmail.requestFocus();
                          return;
                        }
                        if (_txtPass.text.isEmpty) {
                          AFwidget.snack(context, 'Password harus diisi.');
                          _focPass.requestFocus();
                          return;
                        }
                        if (_pathFoto.isEmpty) {
                          AFwidget.snack(
                              context, 'Anda belum mengupload foto.');
                          return;
                        }

                        MemberModel hasilMember = MemberModel(
                          nik: _txtNIK.text,
                          password: _txtPass.text,
                          nama: _txtNama.text,
                          email: _txtEmail.text,
                          foto: _pathFoto,
                          tglLahir: widget.member.tglLahir,
                          tmptLahir: widget.member.tmptLahir,
                          phone: widget.member.phone,
                          kelamin: widget.member.kelamin,
                          kelaminLabel: widget.member.kelaminLabel,
                          agama: widget.member.agama,
                          agamaLabel: widget.member.agamaLabel,
                          kawin: widget.member.kawin,
                          kawinLabel: widget.member.kawinLabel,
                          pekerjaan: widget.member.pekerjaan,
                          pendidikan: widget.member.pendidikan,
                          pendidikanLabel: widget.member.pendidikanLabel,
                          jurusan: widget.member.jurusan,
                          provId: widget.member.provId,
                          kabId: widget.member.kabId,
                          kecId: widget.member.kecId,
                          kelId: widget.member.kelId,
                          provLabel: widget.member.provLabel,
                          kabLabel: widget.member.kabLabel,
                          kecLabel: widget.member.kecLabel,
                          kelLabel: widget.member.kelLabel,
                          dusun: widget.member.dusun,
                        );

                        AFwidget.circularDialog(context);
                        var a = await _memberBloc.cekDuplikasi(
                          nik: _txtNIK.text,
                          email: _txtEmail.text,
                        );
                        Navigator.of(context).pop();

                        if (a['status'].toString() == '1') {
                          Navigator.of(context).pushReplacement(
                            AFpageTransisi.slide(
                              page: LoginStep2(member: hasilMember),
                              dx: 1,
                              dy: 0,
                            ),
                          );
                        } else {
                          AFwidget.alertDialog(
                            context,
                            Text(a['message'].toString()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginStep2 extends StatefulWidget {
  final MemberModel member;

  const LoginStep2({
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _LoginStep2State createState() => _LoginStep2State();
}

class _LoginStep2State extends State<LoginStep2> {
  final MemberBloc _memberBloc = MemberBloc();
  final TextEditingController _txtTglLahir = TextEditingController();
  final TextEditingController _txtTmptLahir = TextEditingController();
  final TextEditingController _txtPhone = TextEditingController();
  final TextEditingController _txtKelamin = TextEditingController();
  final TextEditingController _txtAgama = TextEditingController();
  late FocusNode _focTglLahir;
  late FocusNode _focTmptLahir;
  late FocusNode _focPhone;
  late FocusNode _focKelamin;
  late FocusNode _focAgama;
  DateTime? _tglLahir;
  String _kelamin = '';
  int _agama = 0;

  void fetchTglLahir(DateTime nilai) {
    _tglLahir = nilai;
    _memberBloc.fetchTglLahir(nilai);
  }

  void fetchKelamin(String id, String label) {
    _kelamin = id;
    _memberBloc.fetchKelamin(label);
  }

  void fetchAgama(int id, String label) {
    _agama = id;
    _memberBloc.fetchAgama(label);
  }

  @override
  void initState() {
    super.initState();
    _txtTmptLahir.text = widget.member.tmptLahir;
    _txtPhone.text = widget.member.phone;
    _txtKelamin.text = widget.member.kelaminLabel;
    _txtAgama.text = widget.member.agamaLabel;
    _kelamin = widget.member.kelamin;
    _agama = widget.member.agama;
    if (widget.member.tglLahir != null) fetchTglLahir(widget.member.tglLahir!);
    if (_listOpsiKelamin.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'gender')
          .then((value) => _listOpsiKelamin = value);
    }
    if (_listOpsiAgama.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'agama')
          .then((value) => _listOpsiAgama = value);
    }

    _focTglLahir = FocusNode();
    _focTmptLahir = FocusNode();
    _focPhone = FocusNode();
    _focKelamin = FocusNode();
    _focAgama = FocusNode();
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focTglLahir.dispose();
    _focTmptLahir.dispose();
    _focPhone.dispose();
    _focKelamin.dispose();
    _focAgama.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(),
              kepalaStep(2, lebar: MediaQuery.of(context).size.width),
              StreamBuilder<DateTime>(
                stream: _memberBloc.streamTglLahir,
                builder: (context, snap) {
                  late DateTime nilai;
                  if (snap.hasData) {
                    nilai = snap.data!;
                    _txtTglLahir.text = AFconvert.matDate(snap.data);
                  } else {
                    nilai = DateTime(2000);
                    if (widget.member.tglLahir != null) {
                      fetchTglLahir(widget.member.tglLahir!);
                    }
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtTglLahir,
                    focusNode: _focTglLahir,
                    label: 'Tanggal Lahir',
                    readonly: true,
                    prefix: const Icon(
                      Icons.calendar_today,
                      size: 20,
                    ),
                    ontap: () async {
                      var a = await showDatePicker(
                        context: context,
                        initialDate: nilai,
                        firstDate: DateTime(1950),
                        lastDate: DateTime.now(),
                      );
                      if (a != null) {
                        fetchTglLahir(a);
                      }
                    },
                  );
                },
              ),
              AFwidget.textField(
                context: context,
                kontroler: _txtTmptLahir,
                focusNode: _focTmptLahir,
                label: 'Tempat Lahir',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              AFwidget.textField(
                context: context,
                kontroler: _txtPhone,
                focusNode: _focPhone,
                label: 'Nomor Handphone',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
                keyboard: TextInputType.phone,
              ),
              StreamBuilder<String>(
                stream: _memberBloc.streamKelamin,
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtKelamin.text = snap.data!;
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtKelamin,
                    focusNode: _focKelamin,
                    label: 'Jenis Kelamin',
                    readonly: true,
                    suffix: const Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                    ontap: () async {
                      var a = await AFcombobox.modalBottom(
                        context: context,
                        listOpsi: _listOpsiKelamin,
                        idSelected: _kelamin,
                        judul: 'Jenis Kelamin',
                        isScrollControlled: false,
                        withCari: false,
                      );
                      if (a != null) {
                        fetchKelamin(a.id, a.label);
                      }
                    },
                  );
                },
              ),
              StreamBuilder<String>(
                  stream: _memberBloc.streamAgama,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      _txtAgama.text = snap.data!;
                    }
                    return AFwidget.textField(
                      context: context,
                      kontroler: _txtAgama,
                      focusNode: _focAgama,
                      label: 'Agama',
                      readonly: true,
                      suffix: const Icon(
                        Icons.expand_more,
                        size: 20,
                      ),
                      ontap: () async {
                        var a = await AFcombobox.modalBottom(
                          context: context,
                          listOpsi: _listOpsiAgama,
                          idSelected: _agama.toString(),
                          judul: 'Agama',
                        );
                        if (a != null) {
                          fetchAgama(int.parse(a.id), a.label);
                        }
                      },
                    );
                  }),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: const Text('Sebelumnya'),
                      onPressed: () {
                        MemberModel hasilMember = MemberModel(
                          nik: widget.member.nik,
                          password: widget.member.password,
                          nama: widget.member.nama,
                          email: widget.member.email,
                          foto: widget.member.foto,
                          tglLahir: _tglLahir,
                          tmptLahir: _txtTmptLahir.text,
                          phone: _txtPhone.text,
                          kelamin: _kelamin,
                          kelaminLabel: _txtKelamin.text,
                          agama: _agama,
                          agamaLabel: _txtAgama.text,
                          kawin: widget.member.kawin,
                          kawinLabel: widget.member.kawinLabel,
                          pekerjaan: widget.member.pekerjaan,
                          pendidikan: widget.member.pendidikan,
                          pendidikanLabel: widget.member.pendidikanLabel,
                          jurusan: widget.member.jurusan,
                          provId: widget.member.provId,
                          kabId: widget.member.kabId,
                          kecId: widget.member.kecId,
                          kelId: widget.member.kelId,
                          provLabel: widget.member.provLabel,
                          kabLabel: widget.member.kabLabel,
                          kecLabel: widget.member.kecLabel,
                          kelLabel: widget.member.kelLabel,
                          dusun: widget.member.dusun,
                        );
                        Navigator.of(context).pushReplacement(
                          AFpageTransisi.slide(
                            page: LoginStep1(member: hasilMember),
                            dx: -1,
                            dy: 0,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Selanjutnya'),
                      onPressed: () {
                        if (_tglLahir == null) {
                          AFwidget.snack(context, 'Tanggal lahir harus diisi.');
                          _focTglLahir.requestFocus();
                          return;
                        }

                        if (_txtTmptLahir.text.isEmpty) {
                          AFwidget.snack(context, 'Tempat lahir harus diisi.');
                          _focTmptLahir.requestFocus();
                          return;
                        }

                        if (_txtPhone.text.isEmpty) {
                          AFwidget.snack(context, 'Nomor HP harus diisi.');
                          _focPhone.requestFocus();
                          return;
                        }

                        if (_kelamin == '') {
                          AFwidget.snack(context, 'Jenis kelamin harus diisi.');
                          _focKelamin.requestFocus();
                          return;
                        }

                        if (_agama == 0) {
                          AFwidget.snack(context, 'Agama harus diisi.');
                          _focAgama.requestFocus();
                          return;
                        }

                        MemberModel hasilMember = MemberModel(
                          nik: widget.member.nik,
                          password: widget.member.password,
                          nama: widget.member.nama,
                          email: widget.member.email,
                          foto: widget.member.foto,
                          tglLahir: _tglLahir,
                          tmptLahir: _txtTmptLahir.text,
                          phone: _txtPhone.text,
                          kelamin: _kelamin,
                          kelaminLabel: _txtKelamin.text,
                          agama: _agama,
                          agamaLabel: _txtAgama.text,
                          kawin: widget.member.kawin,
                          kawinLabel: widget.member.kawinLabel,
                          pekerjaan: widget.member.pekerjaan,
                          pendidikan: widget.member.pendidikan,
                          pendidikanLabel: widget.member.pendidikanLabel,
                          jurusan: widget.member.jurusan,
                          provId: widget.member.provId,
                          kabId: widget.member.kabId,
                          kecId: widget.member.kecId,
                          kelId: widget.member.kelId,
                          provLabel: widget.member.provLabel,
                          kabLabel: widget.member.kabLabel,
                          kecLabel: widget.member.kecLabel,
                          kelLabel: widget.member.kelLabel,
                          dusun: widget.member.dusun,
                        );
                        Navigator.of(context).pushReplacement(
                          AFpageTransisi.slide(
                            page: LoginStep3(member: hasilMember),
                            dx: 1,
                            dy: 0,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginStep3 extends StatefulWidget {
  final MemberModel member;

  const LoginStep3({
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _LoginStep3State createState() => _LoginStep3State();
}

class _LoginStep3State extends State<LoginStep3> {
  final MemberBloc _memberBloc = MemberBloc();
  final TextEditingController _txtKawin = TextEditingController();
  final TextEditingController _txtPekerjaan = TextEditingController();
  final TextEditingController _txtPendidikan = TextEditingController();
  final TextEditingController _txtJurusan = TextEditingController();
  late FocusNode _focKawin;
  late FocusNode _focPekerjaan;
  late FocusNode _focPendidikan;
  late FocusNode _focJurusan;
  int _kawin = 0;
  String _pendidikan = '';

  void fetchKawin(int id, String label) {
    _kawin = id;
    _memberBloc.fetchKawin(label);
  }

  void fetchPendidikan(String id, String label) {
    _pendidikan = id;
    _memberBloc.fetchPendidikan(label);
  }

  @override
  void initState() {
    super.initState();
    _txtPekerjaan.text = widget.member.pekerjaan;
    _txtJurusan.text = widget.member.jurusan;
    _txtKawin.text = widget.member.kawinLabel;
    _txtPendidikan.text = widget.member.pendidikanLabel;
    _kawin = widget.member.kawin;
    _pendidikan = widget.member.pendidikan;
    if (_listOpsiKawin.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'kawin')
          .then((value) => _listOpsiKawin = value);
    }
    if (_listOpsiPendidikan.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'combo', mode: 'pendidikan')
          .then((value) => _listOpsiPendidikan = value);
    }

    _focKawin = FocusNode();
    _focPekerjaan = FocusNode();
    _focPendidikan = FocusNode();
    _focJurusan = FocusNode();
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focKawin.dispose();
    _focPekerjaan.dispose();
    _focPendidikan.dispose();
    _focJurusan.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(),
              kepalaStep(3, lebar: MediaQuery.of(context).size.width),
              StreamBuilder<String>(
                stream: _memberBloc.streamKawin,
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtKawin.text = snap.data!;
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtKawin,
                    focusNode: _focKawin,
                    label: 'Status',
                    readonly: true,
                    suffix: const Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                    ontap: () async {
                      var a = await AFcombobox.modalBottom(
                        context: context,
                        listOpsi: _listOpsiKawin,
                        idSelected: _kawin.toString(),
                        judul: 'Status',
                        isScrollControlled: false,
                      );
                      if (a != null) {
                        fetchKawin(int.parse(a.id), a.label);
                      }
                    },
                  );
                },
              ),
              AFwidget.textField(
                context: context,
                kontroler: _txtPekerjaan,
                focusNode: _focPekerjaan,
                label: 'Pekerjaan',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              StreamBuilder<String>(
                stream: _memberBloc.streamPendidikan,
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtPendidikan.text = snap.data!;
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtPendidikan,
                    focusNode: _focPendidikan,
                    label: 'Pendidikan',
                    readonly: true,
                    suffix: const Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                    ontap: () async {
                      var a = await AFcombobox.modalBottom(
                        context: context,
                        listOpsi: _listOpsiPendidikan,
                        idSelected: _pendidikan,
                        judul: 'Pendidikan',
                      );
                      if (a != null) {
                        fetchPendidikan(a.id, a.label);
                      }
                    },
                  );
                },
              ),
              AFwidget.textField(
                context: context,
                kontroler: _txtJurusan,
                focusNode: _focJurusan,
                label: 'Jurusan',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: const Text('Sebelumnya'),
                      onPressed: () {
                        MemberModel hasilMember = MemberModel(
                          nik: widget.member.nik,
                          password: widget.member.password,
                          nama: widget.member.nama,
                          email: widget.member.email,
                          foto: widget.member.foto,
                          tglLahir: widget.member.tglLahir,
                          tmptLahir: widget.member.tmptLahir,
                          phone: widget.member.phone,
                          kelamin: widget.member.kelamin,
                          kelaminLabel: widget.member.kelaminLabel,
                          agama: widget.member.agama,
                          agamaLabel: widget.member.agamaLabel,
                          kawin: _kawin,
                          kawinLabel: _txtKawin.text,
                          pekerjaan: _txtPekerjaan.text,
                          pendidikan: _pendidikan,
                          pendidikanLabel: _txtPendidikan.text,
                          jurusan: _txtJurusan.text,
                          provId: widget.member.provId,
                          kabId: widget.member.kabId,
                          kecId: widget.member.kecId,
                          kelId: widget.member.kelId,
                          provLabel: widget.member.provLabel,
                          kabLabel: widget.member.kabLabel,
                          kecLabel: widget.member.kecLabel,
                          kelLabel: widget.member.kelLabel,
                          dusun: widget.member.dusun,
                        );
                        Navigator.of(context).pushReplacement(
                          AFpageTransisi.slide(
                            page: LoginStep2(member: hasilMember),
                            dx: -1,
                            dy: 0,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Selanjutnya'),
                      onPressed: () {
                        if (_kawin == 0) {
                          AFwidget.snack(context, 'Status harus diisi.');
                          _focKawin.requestFocus();
                          return;
                        }

                        if (_txtPekerjaan.text.isEmpty) {
                          AFwidget.snack(context, 'Pekerjaan harus diisi.');
                          _focPekerjaan.requestFocus();
                          return;
                        }

                        if (_pendidikan == '') {
                          AFwidget.snack(context, 'Pendidikan harus diisi.');
                          _focPendidikan.requestFocus();
                          return;
                        }

                        if (_txtJurusan.text.isEmpty) {
                          AFwidget.snack(context, 'Jurusan harus diisi.');
                          _focJurusan.requestFocus();
                          return;
                        }

                        MemberModel hasilMember = MemberModel(
                          nik: widget.member.nik,
                          password: widget.member.password,
                          nama: widget.member.nama,
                          email: widget.member.email,
                          foto: widget.member.foto,
                          tglLahir: widget.member.tglLahir,
                          tmptLahir: widget.member.tmptLahir,
                          phone: widget.member.phone,
                          kelamin: widget.member.kelamin,
                          kelaminLabel: widget.member.kelaminLabel,
                          agama: widget.member.agama,
                          agamaLabel: widget.member.agamaLabel,
                          kawin: _kawin,
                          kawinLabel: _txtKawin.text,
                          pekerjaan: _txtPekerjaan.text,
                          pendidikan: _pendidikan,
                          pendidikanLabel: _txtPendidikan.text,
                          jurusan: _txtJurusan.text,
                          provId: widget.member.provId,
                          kabId: widget.member.kabId,
                          kecId: widget.member.kecId,
                          kelId: widget.member.kelId,
                          provLabel: widget.member.provLabel,
                          kabLabel: widget.member.kabLabel,
                          kecLabel: widget.member.kecLabel,
                          kelLabel: widget.member.kelLabel,
                          dusun: widget.member.dusun,
                        );
                        Navigator.of(context).pushReplacement(
                          AFpageTransisi.slide(
                            page: LoginStep4(member: hasilMember),
                            dx: 1,
                            dy: 0,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginStep4 extends StatefulWidget {
  final MemberModel member;

  const LoginStep4({
    required this.member,
    Key? key,
  }) : super(key: key);

  @override
  _LoginStep4State createState() => _LoginStep4State();
}

class _LoginStep4State extends State<LoginStep4> {
  final MemberBloc _memberBloc = MemberBloc();
  final AFcache _aFcache = AFcache();
  final TextEditingController _txtProvinsi = TextEditingController();
  final TextEditingController _txtKabupaten = TextEditingController();
  final TextEditingController _txtKecamatan = TextEditingController();
  final TextEditingController _txtKelurahan = TextEditingController();
  final TextEditingController _txtDusun = TextEditingController();
  late FocusNode _focProvinsi;
  late FocusNode _focKabupaten;
  late FocusNode _focKecamatan;
  late FocusNode _focKelurahan;
  late FocusNode _focDusun;
  String _provinsi = '';
  String _kabupaten = '';
  String _kecamatan = '';
  String _kelurahan = '';

  void fetchProvinsi(String id, String label) {
    _provinsi = id;
    _memberBloc.fetchProvinsi(label);
  }

  void fetchKabupaten(String id, String label) {
    _kabupaten = id;
    _memberBloc.fetchKabupaten(label);
  }

  void fetchKecamatan(String id, String label) {
    _kecamatan = id;
    _memberBloc.fetchKecamatan(label);
  }

  void fetchKelurahan(String id, String label) {
    _kelurahan = id;
    _memberBloc.fetchKelurahan(label);
  }

  @override
  void initState() {
    super.initState();
    _txtProvinsi.text = widget.member.provLabel;
    _txtKabupaten.text = widget.member.kabLabel;
    _txtKecamatan.text = widget.member.kecLabel;
    _txtKelurahan.text = widget.member.kelLabel;
    _txtDusun.text = widget.member.dusun;
    _provinsi = widget.member.provId;
    _kabupaten = widget.member.kabId;
    _kecamatan = widget.member.kecId;
    _kelurahan = widget.member.kelId;
    if (_listOpsiProvinsi.isEmpty) {
      _memberBloc
          .getOpsies(rute: 'domisili', mode: 'provinsi')
          .then((value) => _listOpsiProvinsi = value);
    }

    _focProvinsi = FocusNode();
    _focKabupaten = FocusNode();
    _focKecamatan = FocusNode();
    _focKelurahan = FocusNode();
    _focDusun = FocusNode();
  }

  @override
  void dispose() {
    _memberBloc.dispose();
    _focProvinsi.dispose();
    _focKabupaten.dispose();
    _focKecamatan.dispose();
    _focKelurahan.dispose();
    _focDusun.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              logo(),
              kepalaStep(4, lebar: MediaQuery.of(context).size.width),
              StreamBuilder<String>(
                stream: _memberBloc.streamProvinsi,
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtProvinsi.text = snap.data!;
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtProvinsi,
                    focusNode: _focProvinsi,
                    label: 'Provinsi',
                    readonly: true,
                    suffix: const Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                    ontap: () async {
                      var a = await AFcombobox.modalBottom(
                        context: context,
                        listOpsi: _listOpsiProvinsi,
                        idSelected: _provinsi.toString(),
                        judul: 'Provinsi',
                        isScrollControlled: false,
                      );
                      if (a != null) {
                        fetchProvinsi(a.id, a.label);
                        fetchKabupaten('', '');
                        fetchKecamatan('', '');
                        fetchKelurahan('', '');
                      }
                    },
                  );
                },
              ),
              StreamBuilder<String>(
                stream: _memberBloc.streamKabupaten,
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtKabupaten.text = snap.data!;
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtKabupaten,
                    focusNode: _focKabupaten,
                    label: 'Kabupaten',
                    readonly: true,
                    suffix: const Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                    ontap: () async {
                      if (_provinsi != '') {
                        AFwidget.circularDialog(context);
                        var _list = await _memberBloc.getOpsies(
                            rute: 'domisili', mode: 'kabupaten/$_provinsi');
                        Navigator.of(context).pop();
                        var a = await AFcombobox.modalBottom(
                          context: context,
                          listOpsi: _list,
                          idSelected: _kabupaten,
                          judul: 'Kabupaten',
                        );
                        if (a != null) {
                          fetchKabupaten(a.id, a.label);
                          fetchKecamatan('', '');
                          fetchKelurahan('', '');
                        }
                      } else {
                        AFwidget.snack(
                            context, 'Silakan isi provinsi terlebih dahulu.');
                        _focProvinsi.requestFocus();
                      }
                    },
                  );
                },
              ),
              StreamBuilder<String>(
                stream: _memberBloc.streamKecamatan,
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtKecamatan.text = snap.data!;
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtKecamatan,
                    focusNode: _focKecamatan,
                    label: 'Kecamatan',
                    readonly: true,
                    suffix: const Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                    ontap: () async {
                      if (_kabupaten != '') {
                        AFwidget.circularDialog(context);
                        var _list = await _memberBloc.getOpsies(
                            rute: 'domisili', mode: 'kecamatan/$_kabupaten');
                        Navigator.of(context).pop();
                        var a = await AFcombobox.modalBottom(
                          context: context,
                          listOpsi: _list,
                          idSelected: _kecamatan,
                          judul: 'Kecamatan',
                        );
                        if (a != null) {
                          fetchKecamatan(a.id, a.label);
                          fetchKelurahan('', '');
                        }
                      } else {
                        AFwidget.snack(
                            context, 'Silakan isi kabupaten terlebih dahulu.');
                        _focKabupaten.requestFocus();
                      }
                    },
                  );
                },
              ),
              StreamBuilder<String>(
                stream: _memberBloc.streamKelurahan,
                builder: (context, snap) {
                  if (snap.hasData) {
                    _txtKelurahan.text = snap.data!;
                  }
                  return AFwidget.textField(
                    context: context,
                    kontroler: _txtKelurahan,
                    focusNode: _focKelurahan,
                    label: 'Kelurahan / Desa',
                    readonly: true,
                    suffix: const Icon(
                      Icons.expand_more,
                      size: 20,
                    ),
                    ontap: () async {
                      if (_kecamatan != '') {
                        AFwidget.circularDialog(context);
                        var _list = await _memberBloc.getOpsies(
                            rute: 'domisili', mode: 'kelurahan/$_kecamatan');
                        Navigator.of(context).pop();
                        var a = await AFcombobox.modalBottom(
                          context: context,
                          listOpsi: _list,
                          idSelected: _kelurahan,
                          judul: 'Kelurahan',
                        );
                        if (a != null) {
                          fetchKelurahan(a.id, a.label);
                        }
                      } else {
                        AFwidget.snack(
                            context, 'Silakan isi kecamatan terlebih dahulu.');
                        _focKecamatan.requestFocus();
                      }
                    },
                  );
                },
              ),
              AFwidget.textField(
                context: context,
                kontroler: _txtDusun,
                focusNode: _focDusun,
                label: 'Dusun',
                suffix: const Icon(
                  Icons.person,
                  size: 20,
                  color: Colors.transparent,
                ),
                textCapitalization: TextCapitalization.characters,
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    ElevatedButton(
                      child: const Text('Sebelumnya'),
                      onPressed: () {
                        MemberModel hasilMember = MemberModel(
                          nik: widget.member.nik,
                          password: widget.member.password,
                          nama: widget.member.nama,
                          email: widget.member.email,
                          foto: widget.member.foto,
                          tglLahir: widget.member.tglLahir,
                          tmptLahir: widget.member.tmptLahir,
                          phone: widget.member.phone,
                          kelamin: widget.member.kelamin,
                          kelaminLabel: widget.member.kelaminLabel,
                          agama: widget.member.agama,
                          agamaLabel: widget.member.agamaLabel,
                          kawin: widget.member.kawin,
                          kawinLabel: widget.member.kawinLabel,
                          pekerjaan: widget.member.pekerjaan,
                          pendidikan: widget.member.pendidikan,
                          pendidikanLabel: widget.member.pendidikanLabel,
                          jurusan: widget.member.jurusan,
                          provId: _provinsi,
                          kabId: _kabupaten,
                          kecId: _kecamatan,
                          kelId: _kelurahan,
                          provLabel: _txtProvinsi.text,
                          kabLabel: _txtKabupaten.text,
                          kecLabel: _txtKecamatan.text,
                          kelLabel: _txtKelurahan.text,
                          dusun: _txtDusun.text,
                        );
                        Navigator.of(context).pushReplacement(
                          AFpageTransisi.slide(
                            page: LoginStep3(member: hasilMember),
                            dx: -1,
                            dy: 0,
                          ),
                        );
                      },
                    ),
                    ElevatedButton(
                      child: const Text('Daftar'),
                      onPressed: () async {
                        if (_provinsi == '') {
                          AFwidget.snack(context, 'Provinsi harus diisi.');
                          _focProvinsi.requestFocus();
                          return;
                        }

                        if (_kabupaten == '') {
                          AFwidget.snack(context, 'Kabupaten harus diisi.');
                          _focKabupaten.requestFocus();
                          return;
                        }

                        if (_kecamatan == '') {
                          AFwidget.snack(context, 'Kecamatan harus diisi.');
                          _focKecamatan.requestFocus();
                          return;
                        }

                        if (_kelurahan == '') {
                          AFwidget.snack(context, 'Kelurahan harus diisi.');
                          _focKelurahan.requestFocus();
                          return;
                        }

                        if (_txtDusun.text.isEmpty) {
                          AFwidget.snack(context, 'Dusun harus diisi.');
                          _focDusun.requestFocus();
                          return;
                        }

                        MemberModel hasilMember = MemberModel(
                          kategori: 'member',
                          nik: widget.member.nik,
                          password: widget.member.password,
                          nama: widget.member.nama,
                          email: widget.member.email,
                          foto: widget.member.foto,
                          tglLahir: widget.member.tglLahir,
                          tmptLahir: widget.member.tmptLahir,
                          phone: widget.member.phone,
                          kelamin: widget.member.kelamin,
                          kelaminLabel: widget.member.kelaminLabel,
                          agama: widget.member.agama,
                          agamaLabel: widget.member.agamaLabel,
                          kawin: widget.member.kawin,
                          kawinLabel: widget.member.kawinLabel,
                          pekerjaan: widget.member.pekerjaan,
                          pendidikan: widget.member.pendidikan,
                          pendidikanLabel: widget.member.pendidikanLabel,
                          jurusan: widget.member.jurusan,
                          provId: _provinsi,
                          kabId: _kabupaten,
                          kecId: _kecamatan,
                          kelId: _kelurahan,
                          provLabel: _txtProvinsi.text,
                          kabLabel: _txtKabupaten.text,
                          kecLabel: _txtKecamatan.text,
                          kelLabel: _txtKelurahan.text,
                          dusun: _txtDusun.text,
                        );

                        AFwidget.circularDialog(context);
                        var a = await _memberBloc.signUp(hasilMember);
                        Navigator.of(context).pop();

                        if (a['status'].toString() == '1') {
                          _aFcache.setUser('member', hasilMember.nik);
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomePage(
                                menu: 0,
                                page: 'beranda',
                                member: hasilMember,
                              ),
                            ),
                          );
                        } else {
                          AFwidget.alertDialog(
                            context,
                            Text(a['message'].toString()),
                          );
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
