import 'package:bloc/bloc.dart';
import 'package:simpel/chat/models/chat_model.dart';
import 'package:simpel/chat/viewmodels/chats_view_model.dart';

class ChatsCubit extends Cubit<List<Chat>> {
  final ChatsViewModel viewModel;
  ChatsCubit(this.viewModel) : super([]);

  Future<void> chats() async {
    final chats = await viewModel.getChats();
    emit(chats);
  }
}
