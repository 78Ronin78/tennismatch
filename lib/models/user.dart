class UserProfile {
  final String id;
  final String email;
  final String name;
  final String imgUrl;

  UserProfile({this.id, this.email, this.name, this.imgUrl});

  factory UserProfile.fromJson(Map json) => UserProfile(
      id: json['uid'] ?? null,
      name: json['name'] ?? null,
      email: json['email'] ?? null,
      imgUrl: json['imgUrl'] ?? null
      // city: json['city'] ?? null,
      // gender: json['gender'] != null ? Gender.values[json['gender']] : null,
      // age: json['age'] ?? null,
      // rise: json['rise'] ?? null,
      // avatar: json['avatar'] ?? null,
      // ipAddresses: json['ipAddresses'] ?? null,
      // weight: json['weight'] ?? null,
      // showDistanceForMy: json['showDistanceForMy'] ?? false,
      // geolocation: json['geolocation'] != null
      //     ? Geolocal.fromMap(json['geolocation'])
      //     : null,
      // targetOfDating: json['targetOfDating'] != null
      //     ? mapTargetOfDatingFromFirebase(json['targetOfDating'])
      //     : null,
      // aboutMe: json['aboutMe'] ?? null,
      // userChatingId:
      //     json['chattingWith'] is List ? json['chattingWith'] ?? null : null,
      // mainImage: json['mainImage'] ?? null,
      // receivesCalls: json['receivesCalls'] ?? null,
      // status: json["statusOnline"] != null
      //     ? UserStatus.fromMap(json["statusOnline"])
      //     : null,
      // imageProfile: json['imageProfile'] ?? null,
      // notificationsCall: json['notificationsCall'] ?? null,
      // notificationsGuest: json['notificationsGuest'] ?? null,
      // premium:
      //     json['premium'] != null ? Premium.fromMap(json['premium']) : null,
      // blackList: json['blackList'] is List ? json['blackList'] ?? [] : [],
      // guests: json['guests'] ?? [],
      // fcmToken: json['fcmToken'] ?? '',
      // isVisible: json['isVisible'] ?? true,
      // settingsCall: json['settingsCall'] ?? 3,
      // callRequestsUsersList: json['callRequestsUsersList'] ?? [],
      // canCallUsersList: json['canCallUsersList'] ?? [],
      // isFirstLogin: json['isFirstLogin'] ?? false,
      // promotion: json['promotion'] ?? null,
      // complaints: json['complaints'] ?? [],
      // validAvatar: json['validAvatar'] ?? null,
      // audioStoryId: json['audioStories'] ?? null,
      // timeLastStory: json['timeLastStory'] ?? null,
      // anonimCallsParamsId: json['anonimCallsParamsId'] ?? null,
      // lastAnonimCalls: json['lastAnonimCalls'] != null
      //     ? getAnonimCalls(json['lastAnonimCalls'])
      //     : [],
      // lastAnonimProfileCallId: json['lastAnonimProfileCallId'] ?? null,
      // anonimParams: json['anonimParams'] != null
      //     ? SearchParametrsModel.fromJson(json['anonimParams'])
      //     : null,
      // createdNews: json['created_news'] ?? false);
      );
}
