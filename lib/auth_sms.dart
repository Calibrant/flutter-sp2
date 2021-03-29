import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_sp2/chat/screens/welcome_screen.dart';
import 'package:flutter_app_sp2/provider_page.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'const.dart';
import 'googlemap_screen.dart';

class AuthSms extends StatefulWidget {
  /* AuthSms({Key key, this.title}) : super(key: key);
  final String title; */
  static const String id = 'auth_sms';

  @override
  _AuthSmsState createState() => _AuthSmsState();
}

class _AuthSmsState extends State<AuthSms> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _smsController = TextEditingController();
  String _verificationId;
  final SmsAutoFill _autoFill = SmsAutoFill();
  // bool checkboxValueA = true;
  bool checkboxProvider = false;
  List list = [
    GoogleMapPage.id,
    ProviderPage.id,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(child: Text(AUTH_SMS_APPBAR_TITLE)),
      ),
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                keyboardType: TextInputType.phone,
                controller: _phoneNumberController,
                decoration:
                    const InputDecoration(labelText: LABEL_TEXT_PHONE_NUMBER),
              ),
              Container(
                // color: Theme.of(context).primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text(
                    BUTTON_TITLE_GET_CURRENT_NUMBER,
                  ),
                  onPressed: () async =>
                      {_phoneNumberController.text = await _autoFill.hint},
                  /* color: Colors.greenAccent[700] */
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).primaryColor),
                  ),
                  child: Text(BUTTON_TITLE_VERIFY_NUMBER),
                  onPressed: () async {
                    verifyPhoneNumber();
                  },
                ),
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: _smsController,
                decoration: const InputDecoration(
                    labelText: LABEL_TEXT_VERIFICATION_CODE),
              ),
              Container(
                padding: const EdgeInsets.only(top: 8.0),
                alignment: Alignment.center,
                child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          Theme.of(context).primaryColor),
                    ),
                    onPressed: () async {
                      signInWithPhoneNumber();
                    },
                    child: Text(BUTTON_TITLE_SIGN_IN)),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Checkbox(
                      activeColor: Theme.of(context).primaryColor,
                      value: checkboxProvider,
                      onChanged: (value) {
                        setState(() {
                          checkboxProvider = value;
                        });
                      }),
                  Text(CHECKBOX_LABEL),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  verifyPhoneNumber() async {
    PhoneVerificationCompleted verificationCompleted =
        (PhoneAuthCredential phoneAuthCredential) async {
      await _auth.signInWithCredential(phoneAuthCredential);
      showSnackbar("$AUTH_CURRENTUSER ${_auth.currentUser.uid}");
    };

    PhoneVerificationFailed verificationFailed =
        (FirebaseAuthException authException) {
      showSnackbar(
          '$PHONE_NUMBER_VERIFICATION_FAILED_CODE ${authException.code}. $MESSAGE ${authException.message}');
    };

    PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      showSnackbar(PLEASE_CHECK_YOUR_PHONE_FOR_THE_VERIFICATION_CODE);
      _verificationId = verificationId;
    };

    PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      showSnackbar("$VERIFICATION_CODE " + verificationId);
      _verificationId = verificationId;
    };

    try {
      await _auth.verifyPhoneNumber(
          phoneNumber: _phoneNumberController.text,
          timeout: const Duration(seconds: 5),
          verificationCompleted: verificationCompleted,
          verificationFailed: verificationFailed,
          codeSent: codeSent,
          codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
    } catch (e) {
      showSnackbar("$FAILED_TO_VERIFY_PHONE_NUMBER $e");
    }
  }

  void showSnackbar(String message) {
    // ignore: deprecated_member_use
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void signInWithPhoneNumber() async {
    try {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId,
        smsCode: _smsController.text,
      );

      final User user = (await _auth.signInWithCredential(credential)).user;

      showSnackbar("$SUCCESSFULLY_SIGNED_IN_UID ${user.uid}");
      if (user.uid != null) {
        if (checkboxProvider == true) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => ProviderPage()));
        } else {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => GoogleMapPage()));
        }
      }
    } catch (e) {
      showSnackbar("$FAILED_TO_SIGN_IN " + e.toString());
    }
  }
}
