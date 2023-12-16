import 'package:apptodo1/screens/signup_screen.dart';
import 'package:apptodo1/screens/tabs_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final _keyForm = GlobalKey<FormState>();

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  static String id = 'login_screen';

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  //final _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    if (email.isNotEmpty && password.isNotEmpty) {
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: email, password: password);
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text("Đăng nhập thành công"),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TabsScreen()));
                        },
                        child: const Text("OK")),
                  ],
                ));
      } catch (e) {
        // showDialog(
        //     context: context,
        //     builder: (context) => AlertDialog(
        //           title: const Text("Đăng nhập thất bại!"),
        //           actions: [
        //             TextButton(
        //                 onPressed: () {
        //                   Navigator.of(context).pop();
        //                 },
        //                 child: Text("OK"))
        //           ],
        //         ));
      }
    }
    // else {
    //   showDialog(
    //       context: context,
    //       builder: (context) => AlertDialog(
    //             title: const Text("Vui lòng nhập đầy đủ thông tin!"),
    //             actions: [
    //               TextButton(
    //                   onPressed: () {
    //                     Navigator.of(context).pop();
    //                   },
    //                   child: Text("OK")),
    //             ],
    //           ));
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        //backgroundColor: Colors.brown.shade600,
      ),
      //backgroundColor: Colors.brown.shade600,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _keyForm,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextFormField(
                showCursor: true,
                controller: _emailController,
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                ),
                validator: (value) {
                  if(value!.isEmpty){
                    return 'Vui lòng nhập địa chỉ email';
                  }
                  RegExp emailRegex = RegExp(r'^[\w\.-]+@[\w-]+\.\w{2,3}(\.\w{2,3})?$');
                  final isEmailValid = emailRegex.hasMatch(value ?? '');
                  if(!isEmailValid){
                    return 'Vui lòng nhập địa chỉ email hợp lệ';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 16,
              ),
              TextFormField(
                showCursor: true,
                controller: _passwordController,
                obscureText: true,
                obscuringCharacter: "*",
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black,
                ),
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  labelText: "Password",
                  prefixIcon: Icon(Icons.lock),
                ),
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
                  _keyForm.currentState!.validate();
                  _login(context);
                }, //=> _login(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.login),
                    SizedBox(
                      width: 8.0,
                    ),
                    Text("Login")
                  ],
                ),
              ),
              const SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Bạn không có tài khoản?",
                    style: TextStyle(color: Colors.black54),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignUp(),
                          ));
                    },
                    child: const Text(" Sign Up", style: TextStyle(fontWeight: FontWeight.bold),),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
