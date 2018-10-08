class Student{

  String id;
  String name;
  int score;

  Student({this.id, this.name, this.score});


  factory Student.fromJson(Map<String, dynamic> parsedJson){
    return Student(
      id : parsedJson['id'],
      name: parsedJson['name'],
      score: parsedJson['score'],
    );
  }
}