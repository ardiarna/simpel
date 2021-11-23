import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpel/chat/blocs/chats_cubit.dart';
import 'package:simpel/chat/blocs/diskusi_cubit.dart';
import 'package:simpel/chat/blocs/message/message_bloc.dart';
import 'package:simpel/chat/blocs/message_thread/message_thread_cubit.dart';
import 'package:simpel/chat/blocs/receipt/receipt_bloc.dart';
import 'package:simpel/chat/blocs/typing/typing_bloc.dart';
import 'package:simpel/chat/blocs/user_cubit.dart';
import 'package:simpel/chat/data/datasource_contract.dart';
import 'package:simpel/chat/data/sqflite_datasource.dart';
import 'package:simpel/chat/diskusi_route.dart';
import 'package:simpel/chat/local_cache.dart';
import 'package:simpel/chat/views/message_thread.dart';
import 'package:simpel/chat/models/user_model.dart';
import 'package:simpel/chat/services/message_service.dart';
import 'package:simpel/chat/services/message_service_contract.dart';
import 'package:simpel/chat/services/receipt_service.dart';
import 'package:simpel/chat/services/receipt_service_contract.dart';
import 'package:simpel/chat/services/typing_service.dart';
import 'package:simpel/chat/services/typing_service_contract.dart';
import 'package:simpel/chat/services/user_service.dart';
import 'package:simpel/chat/services/user_service_contract.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:simpel/chat/viewmodels/chat_view_model.dart';
import 'package:simpel/chat/viewmodels/chats_view_model.dart';
import 'package:simpel/models/member_model.dart';
import 'package:simpel/utils/af_widget.dart';
import 'package:simpel/utils/db_factory.dart';
import 'package:simpel/views/diskusi_page.dart';
import 'package:sqflite/sqflite.dart';

class CompositionRoot {
  static late IUserService _userService;
  static late IMessageService _messageService;
  static late IDataSource _dataSource;
  static late Database _db;
  static late ILocalCache _localCache;
  static late ITypingNotification _typingNotification;
  static late TypingNotificationBloc _typingNotificationBloc;
  static late MessageBloc _messageBloc;
  static late ChatsCubit _chatsCubit;
  static late UserCubit _userCubit;
  static late DiskusiCubit _diskusiCubit;

  static configure() async {
    _userService = UserService();
    _messageService = MessageService();
    _db = await LocalDatabaseFactory().createDatabase();
    _dataSource = SqfLiteDataSource(_db);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    _typingNotification = TypingNotification(_userService);
    _typingNotificationBloc = TypingNotificationBloc(_typingNotification);
    _messageBloc = MessageBloc(_messageService);
    final viewModel = ChatsViewModel(_dataSource, _userService);
    _chatsCubit = ChatsCubit(viewModel);
    _userCubit = UserCubit(_userService, _localCache);
    _diskusiCubit = DiskusiCubit(_userService);
    // _db.delete('chats');
    // _db.delete('messages');
  }

  static Widget composeDiskusi(MemberModel member) {
    return FutureBuilder<User>(
      future: _userCubit.connect(member.nik, member.nama, member.foto),
      builder: (_, snapUser) {
        if (snapUser.hasData) {
          IDiskusiRouter router =
              DiskusiRouter(showMessageThread: composeDiskusiThread);
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => _diskusiCubit),
              BlocProvider(create: (context) => _messageBloc),
              BlocProvider(create: (context) => _userCubit),
              BlocProvider(create: (context) => _typingNotificationBloc),
              BlocProvider(create: (context) => _chatsCubit),
            ],
            child: DiskusiPage(
              member: member,
              user: snapUser.data!,
              router: router,
            ),
          );
        } else {
          return AFwidget.circularProgress();
        }
      },
    );
  }

  static Widget composeDiskusiThread(
    User receiver,
    User me, {
    String chatId = '',
  }) {
    ChatViewModel viewModel = ChatViewModel(_dataSource);
    MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel);
    IReceiptService receiptService = ReceiptService();
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => messageThreadCubit),
        BlocProvider(create: (context) => receiptBloc),
      ],
      child: MessageThread(
        receiver,
        me,
        _messageBloc,
        _chatsCubit,
        _typingNotificationBloc,
        chatId: chatId,
      ),
    );
  }
}
