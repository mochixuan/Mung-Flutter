
class HotModel {

  int count;
  int code;
  String error;
  int start;
  int total;
  List<HotSubjectsModel> subjects;

  HotModel();

  HotModel.fromJson(Map<String,dynamic> json){
    code = json['code'];
    error = json['error'];
    start = json['start'];
    total = json['total'];
    count = json['count'];

    dynamic subjectItems = json['subjects'];
    if (subjectItems != null && subjectItems is List) {
      subjects = [];
      subjectItems.forEach((subjectModel){
        subjects.add(HotSubjectsModel.fromJson(subjectModel));
      });
    }

  }


}

// 全部集中一起，简单点
class HotSubjectsModel {

  // id
  String id;
  // 标题
  String title;
  // 导演的头像
  String avatarsSmall;
  // 导演名
  String directorsName;
  // 星级
  double ratingAverage;
  //所有主演
  String castNames;
  // 大图
  String largeImage;
  // 多少人看过
  int collectCount;

  HotSubjectsModel.fromJson(Map<String,dynamic> json) {
    if (json != null) {
      id = json['id'];
      largeImage = json['images']['large'];
      title = json['title'];

      List<dynamic> directors = json['directors'];
      if (directors != null && directors.length != 0) {
        avatarsSmall = json['directors'][0]['avatars']['small'];
        directorsName = json['directors'][0]['name'];
      } else {
        avatarsSmall = "";
        directorsName = "暂无";
      }

      castNames = json['casts'].map((item) => item['name']).join(" ");
      collectCount = json['collect_count'];
      ratingAverage = json['rating']['average'] + 0.0;
    }
  }


}