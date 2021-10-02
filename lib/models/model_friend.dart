// ignore_for_file: sort_constructors_first

class FriendModel {
  String userID;
  String name;
  String superHero;
  int recycled;
  int level;
  int coins;

  FriendModel({
    this.userID,
    this.name,
    this.superHero,
    this.recycled,
    this.level,
    this.coins,
  });

  factory FriendModel.fromJSON(json) {
    return FriendModel(
      userID: json['uid'],
      name: json['name'],
      superHero: json['supehero'],
      recycled: json['recycled'],
      level: json['level'],
      coins: json['coins'],
    );
  }
}
