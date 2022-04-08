import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:tennis_match_app/locator.dart';
import 'package:tennis_match_app/models/chat_room_info.dart';
import 'package:tennis_match_app/models/user.dart';
import 'package:tennis_match_app/services/chat_service.dart';

part 'chat_list_event.dart';
part 'chat_list_state.dart';

class ChatListBloc extends Bloc<ChatListEvent, ChatListState> {
  final UserProfile user;

  ChatListBloc({this.user}) : super(ChatListInitial());

  ChatService _chatService = locator<ChatService>();

  StreamSubscription chatList;
  StreamSubscription chatRoomInfoList;

  @override
  Stream<ChatListState> mapEventToState(
    ChatListEvent event,
  ) async* {
    if (event is ChatListStart) {
      yield ChatListLoading();

      chatList?.cancel();
      chatList = _chatService.getChatList(user.uid).listen((list) {
        chatRoomInfoList?.cancel();
        if (list.length == 0) {
          add(ChatListLoad(chatList: []));
        } else {
          chatRoomInfoList = _chatService.getChatRoomInfo(list).listen((rooms) {
            add(ChatListLoad(chatList: rooms));
          });
        }
      });
    } else if (event is ChatListLoad) {
      yield* _mapChatListLoadToState(event.chatList);
    } else if (event is ChatListAdd) {
      yield* _mapChatListAddToState(event.title);
    }
  }

  Stream<ChatListState> _mapChatListLoadToState(
      List<ChatRoomInfo> rooms) async* {
    rooms.sort((a, b) {
      return b.lastModified.compareTo(a.lastModified);
    });

    yield ChatListLoadSuccess(chatList: rooms);
  }

  Stream<ChatListState> _mapChatListAddToState(String title) async* {
    await _chatService.addChatList(user.uid, title);
    yield ChatListAddSucecss();
  }

  @override
  Future<void> close() {
    chatList?.cancel();
    chatRoomInfoList?.cancel();
    return super.close();
  }
}
