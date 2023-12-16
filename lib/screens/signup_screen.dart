import 'package:apptodo1/screens/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _formKey =GlobalKey<FormState>();

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  String? validateEmail(String? email){
    RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
    final isEmailValid = emailRegex.hasMatch(email ?? '');
    if(!isEmailValid){
      return 'Vui lòng nhập địa chỉ email hợp lệ';
    }
    return null;
  }

  void _signup(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();
    final FirebaseAuth _auth = FirebaseAuth.instance;

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        // Đăng ký tài khoản Firebase
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        // Lưu thông tin người dùng vào Firestore
        await FirebaseFirestore.instance.collection('users').doc(_auth.currentUser!.uid).set({
          'id': _auth.currentUser!.uid,
          'email': email,
        });
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Success'),
            content: Text('Đăng ký thành công'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Đăng ký thành công, điều hướng về trang đăng nhậP
                      Navigator.push(context,MaterialPageRoute(builder: (context) => Login(),));
                  },
                  child: Text('OK'))
            ],
          ),
        );
      } catch (e) {
        print('Đăng ký thất bại: $e');
        // showDialog(
        //   context: context,
        //   builder: (context) => AlertDialog(
        //     title: Text('Failed'),
        //     content: Text('Đăng ký thất bại! '),
        //     actions: [
        //       TextButton(
        //           onPressed: () {
        //             Navigator.of(context).pop();
        //           },
        //           child: Text('OK'))
        //     ],
        //   ),
        // );
      }
    }
    // else {
    //   // Hiển thị thông báo lỗi nếu có trường nào đó trống
    //   showDialog(
    //     context: context,
    //     builder: (context) => AlertDialog(
    //       title: Text('Notice'),
    //       content: Text('Vui lòng điền đầy đủ thông tin.'),
    //       actions: [
    //         TextButton(
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //             child: Text('OK'))
    //       ],
    //     ),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  border: OutlineInputBorder()
                ),
                keyboardType: TextInputType.emailAddress,
                validator: validateEmail,
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                obscuringCharacter: "*",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder()
                ),
                //keyboardType: TextInputType.visiblePassword,
                validator: (value) {
                  if(value == null || value.isEmpty){
                    return 'Vui lòng nhập mật khẩu';
                  }
                  else if(value.length < 8){
                    return "Mật khẩu không được ít hơn 8 ký tự";
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              ElevatedButton(
                onPressed: () {
                  _formKey.currentState!.validate();
                  _signup(context);
                }, //=> _signup(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.person_add),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("Sign Up")
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
