class DetailBaseModel {

  int code;
  String error;
  String title;
  String imagesLarge;
  String year;
  String genres;
  String originalTitle;
  String directorsName;
  String castsName;
  List<DetailBaseFilmmakerModel> castFilmmakerItems = [];
  double ratingAverage;
  int ratingsCount;
  String summary;

  DetailBaseModel.fromJson(Map<String,dynamic> json) {
    code = json['code'];
    error = json['error'];
    title = json['title'];
    imagesLarge = json['images']['large'];
    year = json['year'];
    genres = (json['genres'] as List<dynamic>).join("/");
    originalTitle = json['original_title'];
    List<dynamic> directors = json['directors'];
    if (directors != null && directors.length != 0) {
      directorsName = json['directors'][0]['name'];
    } else {
      directorsName = "未知";
    }
    // 两步合一起
    castsName = json['casts'].map((item){
      if (castFilmmakerItems.length < 4) {
        castFilmmakerItems.add(DetailBaseFilmmakerModel(
            name: item['name'],
            large: item['avatars']['large']
        ));
      }
      return item['name'];
    }).join(" ");
    ratingAverage = json['rating']['average'] + 0.0;
    ratingsCount = json['ratings_count'];
    summary = json['summary'];
  }

}

class DetailBaseFilmmakerModel {
  String name;
  String large;

  DetailBaseFilmmakerModel({this.name, this.large});

}