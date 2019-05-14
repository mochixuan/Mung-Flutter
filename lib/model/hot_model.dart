
class HotModel {

  int code;
  String error;
  int count;
  int start;
  int total;
  List<HotSubjectsModel> subjects;

  HotModel.fromJson(Map<String,dynamic> json){
    code = json['code'];
    error = json['error'];
    count = json['count'];
    start = json['start'];
    total = json['total'];

    dynamic subjectItems = json['subjects'];
    if (subjectItems != null && subjectItems is List) {
      subjects = []; // 有数据时才初始化
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
  // 星级
  int ratingAverage;
  int ratingMax;
  // 标题
  String title;
  //所有主演
  String castNames;


  HotSubjectsModel.fromJson(Map<String,dynamic> json) {
    if (json != null) {
      id = json['id'];
    }
  }


}