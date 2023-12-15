// import 'package:equatable/equatable.dart';
//
// class User extends Equatable{
//   late final String email;
//   late final String password;
//
//
//   User({
//     required this.email,
//     required this.password,
//   });
//   User copyWith({
//     String? email,
//     String? password,
//   }) {
//     return User(
//       email: email ?? this.email,
//       password: password ?? this.password,
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return{
//       'email': email,
//       'password': password,
//     };
//   }
//
//   factory User.fromMap(Map<String, dynamic> map) {
//     return User(
//       email:  map['email'] ?? '',
//       password:  map['password'] ?? '',
//     );
//   }
//
//   @override
//   List<Object?> get props => [
//     email,
//     password,
//   ];
// }