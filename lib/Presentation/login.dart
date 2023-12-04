import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:foodconnect/Model/loginModel.dart';
import 'package:foodconnect/Network/SessionManager.dart';
import 'package:foodconnect/Network/apiHelper.dart';
import 'package:foodconnect/Presentation/homepage.dart';
import 'package:foodconnect/Utilities/colors.dart';

class LoginPageWidget extends StatefulWidget {
  const LoginPageWidget({Key? key}) : super(key: key);

  @override
  _LoginPageWidgetState createState() => _LoginPageWidgetState();
}

class _LoginPageWidgetState extends State<LoginPageWidget> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
  bool passwordVisibility = false;
  String? email, password;

  @override
  void initState() {
    super.initState();

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: () => _model.unfocusNode.canRequestFocus
      //     ? FocusScope.of(context).requestFocus(_model.unfocusNode)
      //     : FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: white,
        body: SafeArea(
          top: true,
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 50, 0, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          'assets/launch.gif',
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const Text('SIGN IN WITH FLICKERP',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          color: primary,
                        )),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 100, 10, 10),
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            // color: FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: emailController,
                            focusNode: emailFocusNode,

                            textCapitalization: TextCapitalization.none,
                            obscureText: false,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              // labelStyle: FlutterFlowTheme.of(context).labelMedium,
                              // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  color: primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            // style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: (email) {
                              if (email!.isEmpty) {
                                return "Email can't be empty";
                              }
                              if (!isEmailValid(email)) {
                                return "Enter a valid email";
                              }
                              return null;
                            },
                            onSaved: (value) => email = value!.trim(),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 30, 10, 10),
                      child: Container(
                        decoration: const BoxDecoration(
                            // color: FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                        child: Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(8, 0, 8, 0),
                          child: TextFormField(
                            controller: passwordController,
                            focusNode: passwordFocusNode,

                            obscureText: !passwordVisibility,
                            decoration: InputDecoration(
                              labelText: 'Password',
                              // labelStyle: FlutterFlowTheme.of(context).labelMedium,
                              // hintStyle: FlutterFlowTheme.of(context).labelMedium,
                              enabledBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).alternate,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  color: primary,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              errorBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              focusedErrorBorder: UnderlineInputBorder(
                                borderSide: const BorderSide(
                                  // color: FlutterFlowTheme.of(context).error,
                                  width: 2,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              suffixIcon: InkWell(
                                onTap: () => setState(
                                  () =>
                                      passwordVisibility = !passwordVisibility,
                                ),
                                focusNode: FocusNode(skipTraversal: true),
                                child: Icon(
                                  passwordVisibility
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 22,
                                ),
                              ),
                            ),
                            // style: FlutterFlowTheme.of(context).bodyMedium,
                            validator: (value) => value!.isEmpty
                                ? 'Password can\'t be empty'
                                : null,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(0, 40, 0, 0),
                      child: Container(
                        width: 300,
                        height: 50,
                        decoration: const BoxDecoration(
                            // color: FlutterFlowTheme.of(context).secondaryBackground,
                            ),
                        child: ElevatedButton(
                          onPressed: () async {
                            loginWithEmailAPI();
                          },
                          child: const Text("LOGIN"),

                          // options: FFButtonOptions(
                          //   padding: EdgeInsetsDirectional.fromSTEB(24, 0, 24, 0),
                          //   iconPadding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 0),
                          //   color: FlutterFlowTheme.of(context).primary,
                          //   textStyle:
                          //       FlutterFlowTheme.of(context).titleSmall.override(
                          //             fontFamily: 'Readex Pro',
                          //             color: Colors.white,
                          //           ),
                          //   elevation: 3,
                          //   borderSide: BorderSide(
                          //     color: Colors.transparent,
                          //     width: 1,
                          //   ),
                          //   borderRadius: BorderRadius.circular(8),
                          // ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool isEmailValid(String email) {
    final RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
    return emailRegex.hasMatch(email);
  }

  void loginWithEmailAPI() async {
    email = emailController.text;
    password = passwordController.text;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      try {
        var responseJson = await new ApiHelper().postApi(
            context,
            "https://www.flickerp.com/api/v1/login/",
            await loginWithEmailBody(email!, password!));
        if (responseJson.body != null) {
          if (responseJson.statusCode == 201) {
            LoginModel model =
                LoginModel.fromJson(json.decode(responseJson.body.toString()));
            await SharedPref().saveToken(model.token);
            await SharedPref().saveEmployeeId(model.employeeId);
            await SharedPref().saveOrgId(model.orgId);
            await SharedPref().saveEmail(model.email);

            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomePageWidget()),
            );
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Login Successful"),
            ));
          } else if (responseJson.statusCode == 400) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Invalid Credentials"),
            ));
          }
        } else {}
      } catch (e) {}
    }
  }

  dynamic loginWithEmailBody(String username, String password) {
    var json = jsonEncode(<String, dynamic>{
      "email": username.toLowerCase(),
      "password": password
    });

    return json;
  }
}
