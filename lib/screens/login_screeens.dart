// import 'package:flutter/material.dart';
// import 'package:session3/api/api_service.dart';
// import 'package:session3/widgets/BottomNavBar.dart';

// class LoginScreeens extends StatefulWidget {
//   const LoginScreeens({super.key});

//   @override
//   State<LoginScreeens> createState() => _LoginScreeensState();
// }

// class _LoginScreeensState extends State<LoginScreeens> {
//   final TextEditingController ttextEditingController = TextEditingController(
//     text: "benjamin_frost",
//   );
//   bool isloading = false;

//   void handleLogin() async {
//     if (ttextEditingController.text.trim().isEmpty) return;

//     setState(() {
//       isloading = true;
//     });

//     bool success = await ApiService.login(ttextEditingController.text.trim());
//     setState(() {
//       isloading = false;
//     });

//     if (success && mounted) {
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(builder: (context) => Bottomnavbar()),
//       );
//     } else if (mounted) {
//       ScaffoldMessenger.of(
//         context,
//       ).showSnackBar(SnackBar(content: Text("ERROR")));
//     }
//   }

//   @override
//   void dispose() {
//     // TODO: implement dispose
//     super.dispose();
//     ttextEditingController.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.red,
//         title: Text("WS GERMANY SESSION-3"),
//       ),
//       body: SafeArea(
//         child: Padding(
//           padding: EdgeInsets.all(30),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Form(
//                 child: TextFormField(
//                   controller: ttextEditingController,
//                   decoration: InputDecoration(
//                     border: OutlineInputBorder(),
//                     labelText: "UserName",
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),

//               isloading
//                   ? CircularProgressIndicator()
//                   : ElevatedButton(
//                       onPressed: handleLogin,
//                       child: Text("Click on "),
//                     ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:session3/api/api_service.dart';
import 'package:session3/widgets/BottomNavBar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreeens extends StatefulWidget {
  const LoginScreeens({super.key});

  @override
  State<LoginScreeens> createState() => _LoginScreeensState();
}

class _LoginScreeensState extends State<LoginScreeens> {
  final nameController = TextEditingController();
  bool isloading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    chech();
  }

  void chech() async {
    final prefs = await SharedPreferences.getInstance();
    final savedname = prefs.getString("username");

    if (savedname != null && savedname.isNotEmpty && mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Bottomnavbar()),
      );
    }
  }

  void login() async {
    final username = nameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Fill the form")));
      return;
    }
    ;

    setState(() {
      isloading = true;
    });

    bool isSuccess = await ApiService.login(username);

    setState(() {
      isloading = false;
    });

    if (isSuccess && mounted) {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.setString("username", username);

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Bottomnavbar()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No user found")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyanAccent,
        title: Text("Login Page", style: TextStyle(color: Colors.pink)),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 30,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.pink),
                  ),
                ),
              ),
              isloading
                  ? CircularProgressIndicator(color: Colors.pink)
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        backgroundColor: Colors.cyanAccent,
                      ),

                      onPressed: login,
                      child: Text(
                        "Next Page",
                        style: TextStyle(color: Colors.pink),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
