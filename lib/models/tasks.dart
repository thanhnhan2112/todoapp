
// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Task extends Equatable{
  late final String title;
  late final String description;
  late final String id;
  late final String iduser;
  late final String date;
  late final String status;
  bool? isDone;
  bool? isDeleted;
  bool? isFavorite;

  Task({
    required this.title,
    required this.description,
    required this.id,
    required this.iduser,
    required this.date,
    this.isDone,
    this.isDeleted,
    this.isFavorite,
    required this.status,
  }){
    isDone= isDone ?? false;
    isDeleted= isDeleted ?? false;
    isFavorite= isFavorite ?? false;
  }



  Task copyWith({
    String? title,
    String? description,
    String? id,
    String? iduser,
    String? status,
    String? date,
    bool? isDone,
    bool? isDeleted,
    bool? isFavorite,
  }) {
    return Task(
      title: title ?? this.title,
      description: description ?? this.description,
      id: id ?? this.id,
      iduser: iduser ?? this.iduser,
      status: status ?? this.status,
      date: date ?? this.date,
      isDone: isDone ?? this.isDone,
      isDeleted: isDeleted ?? this.isDeleted,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  Map<String, dynamic> toMap() {
    return{
      'title': title,
      'status': status,
      'description': description,
      'id': id,
      'iduser': iduser,
      'date': date,
      'isDone': isDone,
      'isDeleted': isDeleted,
      'isFavorite': isFavorite,
    };
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title:  map['title'] ?? '',
      description:  map['description'] ?? '',
      id:  map['id'] ?? '',
      iduser:  map['iduser'] ?? '',
      status:  map['status'] ?? '',
      date:  map['date'] ?? '',
      isDone: map['isDone'],
      isDeleted: map['isDeleted'],
      isFavorite: map['isFavorite'],
    );
  }

  @override
  List<Object?> get props => [
    title,
    description,
    id,
    iduser,
    status,
    date,
    isDone,
    isDeleted,
    isFavorite,
  ];
}
