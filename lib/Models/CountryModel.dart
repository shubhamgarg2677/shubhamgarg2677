class CountryModel{
  String _fullName;
  int _id;
  String _shortName;


  String get fullName => _fullName;

  set fullName(String value) {
    _fullName = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  String get shortName => _shortName;

  set shortName(String value) {
    _shortName = value;
  }

  CountryModel();

  CountryModel.fromJson(Map<String, dynamic> json){
    fullName=json["fullName"];
    id=json["id"];
    shortName=json["shortName"];
  }

  CountryModel.initializeModel(){
    fullName="India";
    id=40;
    shortName="in";
  }

}