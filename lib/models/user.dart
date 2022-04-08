class UserProfile {
  final String uid; //идентификатор пользователя
  final String email; //email
  final String name; //имя
  final String lastName; // фамилия
  final String avatarUrl; // ссылка на аватар
  final Gender gender; // Пол
  final String phone; // номер телефона
  final String skillLevel; // уровень мастерства
  final String gameExperience; //опыт игры в теннис в годах
  final String country; //страна
  final String city; // город
  final String
      ipAddresses; // ip адрес пользователя с которого он входил в аккаунт
  final String birthDate; // дата рождения
  final String rise; //Рост
  final String weight; //Вес
  final String weeksAvailability; // доступность в будни
  final String weekendAvailability; // доступность в выходные
  final String about; // информация о себе

  UserProfile(
      {this.uid,
      this.email,
      this.name,
      this.avatarUrl,
      this.lastName,
      this.gender,
      this.phone,
      this.skillLevel,
      this.gameExperience,
      this.country,
      this.city,
      this.ipAddresses,
      this.birthDate,
      this.rise,
      this.weight,
      this.weeksAvailability,
      this.weekendAvailability,
      this.about});

  factory UserProfile.fromJson(Map json) => UserProfile(
        uid: json['uid'] ?? null,
        name: json['name'] ?? null,
        lastName: json['lastName'] ?? null,
        email: json['email'] ?? null,
        avatarUrl: json['avatarUrl'] ?? null,

        gender: json['gender'] != null ? Gender.values[json['gender']] : null,
        phone: json['phone'] ?? null,
        skillLevel: json['skillLevel'] ?? null,
        gameExperience: json['gameExperience'] ?? null,
        country: json['country'] ?? null,
        city: json['city'] ?? null,
        ipAddresses: json['ipAddresses'] ?? null,
        birthDate: json['birthDate'] ?? null,
        rise: json['rise'] ?? null,
        weight: json['weight'] ?? null,
        weeksAvailability: json['weeksAvailability'] ?? null,
        weekendAvailability: json['weekendAvailability'] ?? null,
        about: json['aboutMe'] ?? null,

        // geolocation: json['geolocation'] != null
        //     ? Geolocal.fromMap(json['geolocation'])
        //     : null,
        // targetOfDating: json['targetOfDating'] != null
        //     ? mapTargetOfDatingFromFirebase(json['targetOfDating'])
        //     : null,

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

enum Gender { man, woman }
