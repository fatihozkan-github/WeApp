class Post {
  String authorName;
  String authorImageUrl;
  String timeAgo;
  String imageUrl;
  String likeCount;
  String shareCount;

  Post({
    this.authorName,
    this.authorImageUrl,
    this.timeAgo,
    this.imageUrl,
    this.likeCount,
    this.shareCount,
  });
}

final List<Post> posts = [
  Post(
      authorName: 'Alihan Soykal',
      authorImageUrl: 'assets/Images/People/alihan.png',
      timeAgo: '5 min',
      imageUrl: 'assets/Images/Feeds/eventfeed.gif',
      likeCount: "482 ",
      shareCount: "76"),
  Post(
      authorName: 'Aysu Keçeci',
      authorImageUrl: 'assets/Images/People/aysu.png',
      timeAgo: '10 min',
      imageUrl: 'assets/Images/Feeds/celebrate.gif',
      likeCount: "522 ",
      shareCount: "44"),
  Post(
      authorName: 'Larry Page',
      authorImageUrl: 'assets/Images/People/larryPage.png',
      timeAgo: '1 day',
      imageUrl: 'assets/Images/Feeds/larryfeed.gif',
      likeCount: "602",
      shareCount: "271"),
  Post(
      authorName: 'Aysu Keçeci',
      authorImageUrl: 'assets/Images/People/aysu.png',
      timeAgo: '2 weeks',
      imageUrl: 'assets/Images/Feeds/competitionfeed.png',
      likeCount: "122",
      shareCount: "18"),
  Post(
      authorName: 'Sundar Pichai',
      authorImageUrl: 'assets/Images/People/sundarPichai.png',
      timeAgo: '2 years',
      imageUrl: 'assets/Images/Feeds/friendshipfeed.gif',
      likeCount: "573 ",
      shareCount: "300"),
];
