class NewsDataModel{
  String _author;
  int _category;
  int _country;
  String _description;
  int _id;
  String _publishedat;
  String _source;
  String _title;
  String _url;
  String _urltoimage;

  String get author => _author;

  set author(String value) {
    _author = value;
  }

  int get category => _category;

  String get urltoimage => _urltoimage;

  set urltoimage(String value) {
    _urltoimage = value;
  }

  String get url => _url;

  set url(String value) {
    _url = value;
  }

  String get title => _title;

  set title(String value) {
    _title = value;
  }

  String get source => _source;

  set source(String value) {
    _source = value;
  }

  String get publishedat => _publishedat;

  set publishedat(String value) {
    _publishedat = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get description => _description;

  set description(String value) {
    _description = value;
  }

  int get country => _country;

  set country(int value) {
    _country = value;
  }

  set category(int value) {
    _category = value;
  }

  NewsDataModel();

  NewsDataModel.fromJson(Map<String, dynamic> json){
    _author=json["author"]!=null
        && json["author"].toString().isNotEmpty
        && json["author"].toString().toLowerCase()!="null"
        ? json["author"]
        : "";
    _id=json["id"]!=null
        && json["id"].toString().isNotEmpty
        && json["id"].toString().toLowerCase()!="null"
        ? json["id"]
        : 0;
    _category=json["category"]!=null
        && json["category"].toString().isNotEmpty
        && json["category"].toString().toLowerCase()!="null"
        ? json["category"]
        : 0;
    _country=json["country"]!=null
        && json["country"].toString().isNotEmpty
        && json["country"].toString().toLowerCase()!="null"
        ? json["country"]
        : 0;
    _description=json["description"]!=null
        && json["description"].toString().isNotEmpty
        && json["description"].toString().toLowerCase()!="null"
        ? json["description"]
        : "";
    _source=json["source"]!=null
        && json["source"].toString().isNotEmpty
        && json["source"].toString().toLowerCase()!="null"
        ? json["source"]
        : "";
    _publishedat=json["publishedat"]!=null
        && json["publishedat"].toString().isNotEmpty
        && json["publishedat"].toString().toLowerCase()!="null"
        ? json["publishedat"]
        : "";
    _title=json["title"]!=null
        && json["title"].toString().isNotEmpty
        && json["title"].toString().toLowerCase()!="null"
        ? json["title"]
        : "";
    _url=json["url"]!=null
        && json["url"].toString().isNotEmpty
        && json["url"].toString().toLowerCase()!="null"
        ? json["url"]
        : "";
    _urltoimage=json["urltoimage"]!=null
        && json["urltoimage"].toString().isNotEmpty
        && json["urltoimage"].toString().toLowerCase()!="null"
        ? json["urltoimage"]
        : "";
  }
}