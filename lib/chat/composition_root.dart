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
  static late Database _db;
  static late IDataSource _dataSource;
  static late ILocalCache _localCache;

  static configure() async {
    _db = await LocalDatabaseFactory().createDatabase();
    _dataSource = SqfLiteDataSource(_db);
    final sp = await SharedPreferences.getInstance();
    _localCache = LocalCache(sp);
    // _db.delete('chats');
    // _db.delete('messages');
  }

  static Widget composeDiskusi(MemberModel member) {
    IUserService _userService = UserService();
    IMessageService _messageService = MessageService();
    UserCubit userCubit = UserCubit(_userService, _localCache);
    return FutureBuilder<User>(
      future: userCubit.connect(member.nik, member.nama, member.foto),
      builder: (_, snapUser) {
        if (snapUser.hasData) {
          DiskusiCubit diskusiCubit = DiskusiCubit(_userService);
          MessageBloc messageBloc = MessageBloc(_messageService);
          final viewModel = ChatsViewModel(_dataSource, _userService);
          ChatsCubit chatsCubit = ChatsCubit(viewModel);
          ITypingNotification typingNotification =
              TypingNotification(_userService);
          TypingNotificationBloc typingNotificationBloc =
              TypingNotificationBloc(typingNotification);
          IDiskusiRouter router =
              DiskusiRouter(showMessageThread: composeDiskusiThread);
          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) => diskusiCubit),
              BlocProvider(create: (context) => messageBloc),
              BlocProvider(create: (context) => userCubit),
              BlocProvider(create: (context) => typingNotificationBloc),
              BlocProvider(create: (context) => chatsCubit),
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
    IUserService _userService = UserService();
    IMessageService _messageService = MessageService();
    MessageBloc messageBloc = MessageBloc(_messageService);
    final viewsModel = ChatsViewModel(_dataSource, _userService);
    ChatsCubit chatsCubit = ChatsCubit(viewsModel);
    ITypingNotification typingNotification = TypingNotification(_userService);
    TypingNotificationBloc typingNotificationBloc =
        TypingNotificationBloc(typingNotification);
    final ChatViewModel viewModel = ChatViewModel(_dataSource);
    MessageThreadCubit messageThreadCubit = MessageThreadCubit(viewModel);
    IReceiptService receiptService = ReceiptService();
    ReceiptBloc receiptBloc = ReceiptBloc(receiptService);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => messageThreadCubit),
        BlocProvider(create: (context) => receiptBloc),
        BlocProvider(create: (context) => messageBloc),
      ],
      child: MessageThread(
        receiver,
        me,
        chatsCubit,
        typingNotificationBloc,
        chatId: chatId,
      ),
    );
  }
}
