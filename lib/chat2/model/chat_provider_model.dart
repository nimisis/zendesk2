import 'package:zendesk2/zendesk2.dart';

class ChatProviderModel {
  final bool? isChatting;
  final CHAT_SESSION_STATUS chatSessionStatus;
  final Iterable<Agent> agents;
  final Iterable<ChatLog> logs;
  final int? queuePosition;
  final String? queueId;

  ChatProviderModel(
    this.isChatting,
    this.chatSessionStatus,
    this.agents,
    this.logs,
    this.queuePosition,
    this.queueId,
  );

  bool get hasAgents => this.agents.isNotEmpty;

  factory ChatProviderModel.fromJson(Map map) {
    bool? isChatting = map['isChatting'];
    Iterable<Agent> agents =
        ((map['agents'] ?? []) as Iterable).map((e) => Agent.fromJson(e));

    Iterable<ChatLog> logs =
        ((map['logs'] ?? []) as Iterable).map((e) => ChatLog.fromJson(e));

    int? queuePosition = map['queuePosition'];
    String? queueId = map['queueId'];

    CHAT_SESSION_STATUS chatSessionStatus;

    final mChatSessionStatus = map['chatSessionStatus'];

    switch (mChatSessionStatus) {
      case 'CONFIGURING':
        chatSessionStatus = CHAT_SESSION_STATUS.CONFIGURING;
        break;
      case 'ENDED':
        chatSessionStatus = CHAT_SESSION_STATUS.ENDED;
        break;
      case 'ENDING':
        chatSessionStatus = CHAT_SESSION_STATUS.ENDING;
        break;
      case 'INITIALIZING':
        chatSessionStatus = CHAT_SESSION_STATUS.INITIALIZING;
        break;
      case 'STARTED':
        chatSessionStatus = CHAT_SESSION_STATUS.STARTED;
        break;
      default:
        chatSessionStatus = CHAT_SESSION_STATUS.UNKNOWN;
    }

    return ChatProviderModel(
      isChatting,
      chatSessionStatus,
      agents,
      logs,
      queuePosition,
      queueId,
    );
  }
}

class Agent {
  final String? avatar;
  final String? displayName;
  final bool? isTyping;
  final String? nick;

  Agent(this.avatar, this.displayName, this.isTyping, this.nick);

  factory Agent.fromJson(Map map) {
    String? avatar = map['avatar'];
    String? displayName = map['displayName'];
    bool? isTyping = map['isTyping'];
    String? nick = map['nick'];
    return Agent(avatar, displayName, isTyping, nick);
  }
}

class ChatLog {
  final bool? createdByVisitor;
  final DateTime createdTimestamp;
  final String? displayName;
  final DateTime lastModifiedTimestamp;
  final String? nick;
  final ChatLogParticipant chatLogParticipant;
  final ChatLogDeliveryStatus chatLogDeliveryStatus;
  final ChatLogType chatLogType;

  ChatLog(
    this.createdByVisitor,
    this.createdTimestamp,
    this.displayName,
    this.lastModifiedTimestamp,
    this.nick,
    this.chatLogParticipant,
    this.chatLogDeliveryStatus,
    this.chatLogType,
  );

  factory ChatLog.fromJson(Map map) {
    bool? createdByVisitor = map['createdByVisitor'];
    String? displayName = map['displayName'];

    final mCreatedTimestamp = map['createdTimestamp'];
    final mLastModifiedTimestamp = map['lastModifiedTimestamp'];

    DateTime createdTimestamp = DateTime.fromMillisecondsSinceEpoch(
        mCreatedTimestamp is double
            ? mCreatedTimestamp.toInt()
            : mCreatedTimestamp);

    DateTime lastModifiedTimestamp = DateTime.fromMillisecondsSinceEpoch(
        mLastModifiedTimestamp is double
            ? mLastModifiedTimestamp.toInt()
            : mLastModifiedTimestamp);

    String? nick = map['nick'];

    ChatLogParticipant chatLogParticipant =
        ChatLogParticipant.fromJson(map['participant']);
    ChatLogDeliveryStatus chatLogDeliveryStatus =
        ChatLogDeliveryStatus.fromJson(map['deliveryStatus']);

    ChatLogType chatLogType = ChatLogType.fromJson(map['type']);
    return ChatLog(
      createdByVisitor,
      createdTimestamp,
      displayName,
      lastModifiedTimestamp,
      nick,
      chatLogParticipant,
      chatLogDeliveryStatus,
      chatLogType,
    );
  }
}

class ChatLogParticipant {
  final CHAT_PARTICIPANT chatParticipant;

  ChatLogParticipant(this.chatParticipant);

  factory ChatLogParticipant.fromJson(Map map) {
    CHAT_PARTICIPANT chatParticipant = CHAT_PARTICIPANT.SYSTEM;
    String mChatParticipant = map['chatParticipant'];

    switch (mChatParticipant) {
      case 'AGENT':
        chatParticipant = CHAT_PARTICIPANT.AGENT;
        break;
      case 'SYSTEM':
        chatParticipant = CHAT_PARTICIPANT.SYSTEM;
        break;
      case 'TRIGGER':
        chatParticipant = CHAT_PARTICIPANT.TRIGGER;
        break;
      case 'VISITOR':
        chatParticipant = CHAT_PARTICIPANT.VISITOR;
        break;
    }

    return ChatLogParticipant(chatParticipant);
  }
}

class ChatLogDeliveryStatus {
  final bool isFailed;
  final DELIVERY_STATUS deliveryStatus;

  ChatLogDeliveryStatus(this.isFailed, this.deliveryStatus);

  factory ChatLogDeliveryStatus.fromJson(Map map) {
    bool isFailed = map['isFailed'] ?? false;

    String? mDeliveryStatus = map['status'];
    DELIVERY_STATUS deliveryStatus = DELIVERY_STATUS.UNKNOWN;

    switch (mDeliveryStatus) {
      case 'DELIVERED':
        deliveryStatus = DELIVERY_STATUS.DELIVERED;
        break;
      case 'PENDING':
        deliveryStatus = DELIVERY_STATUS.PENDING;
        break;
      case 'UNKNOWN':
        deliveryStatus = DELIVERY_STATUS.UNKNOWN;
        break;
    }

    return ChatLogDeliveryStatus(isFailed, deliveryStatus);
  }
}

class ChatLogType {
  final LOG_TYPE logType;
  final ChatMessage? chatMessage;
  final ChatOptionsMessage? chatOptionsMessage;
  final ChatAttachment? chatAttachment;

  ChatLogType(
    this.logType,
    this.chatMessage,
    this.chatOptionsMessage,
    this.chatAttachment,
  );

  factory ChatLogType.fromJson(Map map) {
    String mLogType = map['type'];

    LOG_TYPE logType = LOG_TYPE.UNKNOWN;

    switch (mLogType) {
      case 'ATTACHMENT_MESSAGE':
        logType = LOG_TYPE.ATTACHMENT_MESSAGE;
        break;
      case 'MEMBER_JOIN':
        logType = LOG_TYPE.MEMBER_JOIN;
        break;
      case 'MEMBER_LEAVE':
        logType = LOG_TYPE.MEMBER_LEAVE;
        break;
      case 'MESSAGE':
        logType = LOG_TYPE.MESSAGE;
        break;
      case 'OPTIONS_MESSAGE':
        logType = LOG_TYPE.OPTIONS_MESSAGE;
        break;
      case 'UNKNOWN':
        logType = LOG_TYPE.UNKNOWN;
        break;
    }

    ChatOptionsMessage? chatOptionsMessage;
    ChatMessage? chatMessage;
    ChatAttachment? chatAttachment;

    switch (logType) {
      case LOG_TYPE.ATTACHMENT_MESSAGE:
        chatAttachment = ChatAttachment.fromJson(map['chatAttachment']);
        break;
      case LOG_TYPE.MEMBER_JOIN:
      case LOG_TYPE.MEMBER_LEAVE:
      case LOG_TYPE.MESSAGE:
        chatMessage = ChatMessage.fromJson(map['chatMessage']);
        break;
      case LOG_TYPE.OPTIONS_MESSAGE:
        chatOptionsMessage =
            ChatOptionsMessage.fromJson(map['chatOptionsMessage']);
        break;
      case LOG_TYPE.UNKNOWN:
        break;
    }
    return ChatLogType(
      logType,
      chatMessage,
      chatOptionsMessage,
      chatAttachment,
    );
  }
}

class ChatMessage {
  final String? id;
  final String? message;

  ChatMessage(
    this.id,
    this.message,
  );

  factory ChatMessage.fromJson(Map map) {
    String? id = map['id'];
    String? message = map['message'];
    return ChatMessage(id, message);
  }
}

class ChatOptionsMessage {
  final String? message;
  final Iterable<String> options;

  ChatOptionsMessage(this.message, this.options);

  factory ChatOptionsMessage.fromJson(Map map) {
    final String? message = map['message'];
    final Iterable<String> options =
        ((map['options'] ?? []) as Iterable).map((o) => o.toString());
    return ChatOptionsMessage(message, options);
  }
}

class ChatAttachment {
  final String? id;
  final String? message;
  final String? url;
  final ChatAttachmentAttachment chatAttachmentAttachment;

  ChatAttachment(
    this.id,
    this.message,
    this.url,
    this.chatAttachmentAttachment,
  );

  factory ChatAttachment.fromJson(Map map) {
    String? id = map['id'];
    String? message = map['message'];
    String? url = map['url'];
    ChatAttachmentAttachment chatAttachmentAttachment =
        ChatAttachmentAttachment.fromJson(
            map['chatAttachmentAttachment'] ?? {});
    return ChatAttachment(id, message, url, chatAttachmentAttachment);
  }
}

class ChatAttachmentAttachment {
  final String? name;
  final String? localUrl;
  final String? mimeType;
  final int? size;
  final String? url;
  final ATTACHMENT_ERROR attachmentError;

  ChatAttachmentAttachment(
    this.name,
    this.localUrl,
    this.mimeType,
    this.size,
    this.url,
    this.attachmentError,
  );

  factory ChatAttachmentAttachment.fromJson(Map map) {
    String? name = map['name'];
    String? localUrl = map['localUrl'];
    String? mimeType = map['mimeType'];
    int? size = map['size'];
    String? url = map['url'];
    String? mAttachmentError = map['error'];

    ATTACHMENT_ERROR attachmentError;
    switch (mAttachmentError) {
      case 'NONE':
        attachmentError = ATTACHMENT_ERROR.NONE;
        break;
      case 'SIZE_LIMIT':
        attachmentError = ATTACHMENT_ERROR.SIZE_LIMIT;
        break;
      default:
        attachmentError = ATTACHMENT_ERROR.NONE;
    }

    return ChatAttachmentAttachment(
      name,
      localUrl,
      mimeType,
      size,
      url,
      attachmentError,
    );
  }
}