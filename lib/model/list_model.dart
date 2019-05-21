class ListModel {

  int code;
  String error;
  List<ListItem> listItems;

  ListModel.fromJson(Map<String,dynamic> json) {
    code = json['code'];
    error = json['error'];
    if (json != null && json['subjects'] != null) {
      listItems = [];
      json['subjects'].forEach((item){
        listItems.add(ListItem.fromJson(item['subject'] ?? item));
      });
    }
  }

}

class ListItem {

  // id
  String id;
  // 标题
  String title;
  // 大图
  String largeImage;
  // 导演名
  String directorsName;
  // 星级
  double ratingAverage;
  //所有主演
  String castNames;
  String year;

  ListItem.fromJson(Map<String,dynamic> json) {
    if (json != null) {
      id = json['id'];
      title = json['title'];
      largeImage = json['images']['large'];

      List<dynamic> directors = json['directors'];
      if (directors != null && directors.length != 0) {
        directorsName = json['directors'][0]['name'];
      } else {
        directorsName = "未知";
      }
      castNames = json['casts'].map((item) => item['name']).join(" ");
      ratingAverage = json['rating']['average'] + 0.0;
      year = json['year'];

    }
  }

}