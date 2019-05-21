class DiscussModel {
  int code;
  String error;
  int start;
  List<DiscussItem> discussItems;

  DiscussModel.fromJson(Map<String,dynamic> json) {
    code = json['code'];
    error = json['error'];
    start = json['start'];

    if (json != null && json['comments'] != null) {
      discussItems = [];
      json['comments'].forEach((item){
        discussItems.add(DiscussItem.fromJson(item));
      });
    }

  }


}

class DiscussItem {

  String authorAvatar = "";
  String name = "--";
  double ratingValue = 0;
  int usefulCount;
  String content;
  String createdAt;


  DiscussItem.fromJson(Map<String,dynamic> json) {
    if (json['author'] != null) {
      if (json['author']['avatar'] != null) authorAvatar = json['author']['avatar'];
      if (json['author']['name'] != null) name = (json['author']['name'] as String);
      if (name.length > 13) {
        name = name.substring(0,10)+"...";
      }
    }
    if (json['rating'] != null && json['rating']['value'] != null) {
      ratingValue = json['rating']['value'] + 0.0;
    }
    usefulCount = json['useful_count'] ?? 0;
    content = json['content'] ?? "";
    createdAt = json['created_at'] ?? "";
  }

}