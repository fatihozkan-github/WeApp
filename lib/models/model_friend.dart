// ignore_for_file: sort_constructors_first

class FriendModel {
  String userID;
  String name;
  String superHero;
  int recycled;
  int level;
  int coins;

  ///
  String avatar;

  /// TODO: We need avatar.
  FriendModel({
    this.userID,
    this.name,
    this.superHero,
    this.recycled,
    this.level,
    this.coins,
    this.avatar,
  });

  factory FriendModel.fromJSON(json) {
    return FriendModel(
      userID: json['uid'],
      name: json['name'],
      superHero: json['superhero'],
      recycled: json['recycled'],
      level: json['level'],
      coins: json['coins'],
      avatar: json['avatar'],
    );
  }
  factory FriendModel.fromJSONv2(json) {
    return FriendModel(
      userID: json['uid'],
      name: json['name'],
      superHero: json['supehero'],
      recycled: json['recycled'],
      level: json['level'],
      coins: json['coins'],
      avatar: json['avatar'],
    );
  }
}
