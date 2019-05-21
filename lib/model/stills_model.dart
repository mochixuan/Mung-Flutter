class StillsModel {

  int code;
  String error;
  List<StillItem> stillItems;

  StillsModel.fromJson(Map<String,dynamic> json) {
    code = json['code'];
    error = json['error'];
    if (json != null && json['photos'] != null) {
      stillItems = [];
      json['photos'].forEach((model){
        stillItems.add(StillItem.fromJson(model));
      });
    }
  }

}

class StillItem {

  int photoCount = 0;
  String image;

  StillItem.fromJson(Map<String,dynamic> json) {
    photoCount = json['photos_count'];
    image = json['image'];
  }

}