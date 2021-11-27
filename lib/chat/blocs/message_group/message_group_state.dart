part of "message_group_bloc.dart";

abstract class MessageGroupState extends Equatable {
  const MessageGroupState();
  factory MessageGroupState.initial() => MessageGroupInitial();
  factory MessageGroupState.created(MessageGroup messageGroup) =>
      MessageGroupCreatedSuccess(messageGroup);
  factory MessageGroupState.received(MessageGroup messageGroup) =>
      MessageGroupReceived(messageGroup);

  @override
  List<Object?> get props => [];
}

class MessageGroupInitial extends MessageGroupState {}

class MessageGroupCreatedSuccess extends MessageGroupState {
  final MessageGroup messageGroup;
  const MessageGroupCreatedSuccess(this.messageGroup);

  @override
  List<Object?> get props => [messageGroup];
}

class MessageGroupReceived extends MessageGroupState {
  final MessageGroup messageGroup;
  const MessageGroupReceived(this.messageGroup);

  @override
  List<Object?> get props => [messageGroup];
}
