import 'package:flutter/material.dart';
import 'package:vtv_common/chat.dart';
import 'package:vtv_common/core.dart';

import '../../../../service_locator.dart';
import 'vendor_chat_page.dart';

class VendorChatRoomPage extends StatelessWidget {
  const VendorChatRoomPage({super.key});

  // static const routeName = 'chat-room';
  // static const path = '/user/chat-room';

  @override
  Widget build(BuildContext context) {
    final lazyListController = LazyListController<ChatRoomEntity>(
      items: [],
      paginatedData: sl<ChatRepository>().getPaginatedChatRoom,
      itemBuilder: (context, index, data) => chatRoomItem(context, data),
      useGrid: false,
    )..init();

    return ChatRoomPage(lazyListController: lazyListController, title: 'Chat với khách hàng');
  }

  ChatRoomItem chatRoomItem(BuildContext context, ChatRoomEntity room) {
    return ChatRoomItem(
      room: room,
      onPressed: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) {
              return VendorChatPage(room: room);
            },
          ),
        );
      },
    );
  }
}
