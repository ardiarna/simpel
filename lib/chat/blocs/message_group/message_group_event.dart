part of "message_group_bloc.dart";

abstract class MessageGroupEvent extends Equatable {
  const MessageGroupEvent();
  factory MessageGroupEvent.onSubscribed(User user) => Subscribed(user);
  factory MessageGroupEvent.onGroupCreated(MessageGroup messageGroup) =>
      MessageGroupCreated(messageGroup);

  @override
  List<Object?> get props => [];
}

class Subscribed extends MessageGroupEvent {
  final User user;
  const Subscribed(this.user);

  @override
  List<Object?> get props => [user];
}

class MessageGroupCreated extends MessageGroupEvent {
  final MessageGroup messageGroup;
  const MessageGroupCreated(this.messageGroup);

  @override
  List<Object?> get props => [messageGroup];
}

class _MessageGroupReceived extends MessageGroupEvent {
  final MessageGroup messageGroup;
  const _MessageGroupReceived(this.messageGroup);

  @override
  List<Object?> get props => [messageGroup];
}
