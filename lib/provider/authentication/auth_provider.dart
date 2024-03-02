import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_picker/country_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/enums/enums.dart';

abstract class AuthenticationProviderUseCase {
  Future<void> logInUser();
  Future<void> registerUserEmailAndPassword();
  Future<void> registerUserWithPhoneNumber(
      BuildContext context, String phoneNumber);
  Future<void> logOutUser();
  Future<void> checkExistingUser();
  Future<void> verifyOtp(
    BuildContext context,
    String verificationId,
    String userOtp,
    Function onSuccess,
  );
}

class AuthenticationProviderImpl extends ChangeNotifier
    implements AuthenticationProviderUseCase {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();

  final firebaseAuth = FirebaseAuth.instance;
  final firebaseFirestore = FirebaseFirestore.instance;

  Country selectedCountry = Country(
      phoneCode: "234",
      countryCode: "NG",
      e164Sc: 0,
      geographic: true,
      level: 1,
      name: "Nigeria",
      example: "Nigeria",
      displayName: "Nigeria",
      displayNameNoCountryCode: "NG",
      e164Key: "");

  ViewState state = ViewState.Idle;

  String? _uid;
  String get uid => _uid!;
  String message = '';

  String? verificationId = '';

  bool _isCodeSent = false;

  bool get isCodeSent => _isCodeSent;

  set isCodeSent(bool isCodeSent) => _isCodeSent = isCodeSent;

  @override
  Future<void> logInUser() async {
    state = ViewState.Busy;
    message = 'Preparing your account...';
    _updateState();
    try {
      final result = await firebaseAuth.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      //get username of user
      result.user!.updateDisplayName(userNameController.text.trim());
      state = ViewState.Success;
      message = 'Welcome back, ${userNameController.text}';
      emailController.clear();
      passwordController.clear();
      _updateState();
    } on SocketException catch (_) {
      state = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseException catch (e) {
      state = ViewState.Error;
      message = e.toString();
      _updateState();
    } catch (e) {
      state = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  @override
  Future<void> logOutUser() async {
    return await firebaseAuth.signOut();
  }

  @override
  Future<void> registerUserWithPhoneNumber(context, phoneNumber) async {
    state = ViewState.Busy;
    message = 'Verifying your phone number...';

    _updateState();
    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) async {
          await firebaseAuth.signInWithCredential(phoneAuthCredential);
        },
        codeSent: (verificationId, resendToken) {
          this.verificationId = verificationId;
          _isCodeSent = true;
          // if (_isCodeSent == true) {
          //   _isCodeSent = isCodeSent;
          // }
          // return;
        },
        codeAutoRetrievalTimeout: (verficationId) {
          verificationId = verificationId;
        },
        verificationFailed: (e) {
          message = e.message!;
          // if (e.code == 'invalid-phone-number') {
          //   message = 'The provider phone number is not valid';
          // } else {
          //   message = 'Something went wrong please try again';
          // }
        },
      );
      // result.updateDisplayName(userNameController.text.trim());
      state = ViewState.Success;
      message = 'Welcome ${userNameController.text}';
      _updateState();
    } on SocketException catch (_) {
      state = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseAuthException catch (e) {
      state = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      state = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  @override
  Future<void> verifyOtp(context, verificationId, userOtp, onSuccess) async {
    state = ViewState.Busy;
    message = 'Verifying Otp code...';

    _updateState();

    try {
      PhoneAuthCredential creds = PhoneAuthProvider.credential(
          verificationId: verificationId, smsCode: userOtp);
      User? user = (await firebaseAuth.signInWithCredential(creds)).user;

      if (user != null) {
        _uid = user.uid;
        onSuccess();
      }

      state = ViewState.Success;
      message = 'Welcome ${userNameController.text}';
      _updateState();
    } on SocketException catch (_) {
      state = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseAuthException catch (e) {
      state = ViewState.Error;
      message = e.message.toString();
      _updateState();
    } catch (e) {
      state = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }

    // var credentials = await firebaseAuth.signInWithCredential(
    //   PhoneAuthProvider.credential(
    //     verificationId: verificationId,
    //     smsCode: otp,
    //   ),
    // );
    // return credentials.user != null ? true : false;
  }

  @override
  Future<void> registerUserEmailAndPassword() async {
    state = ViewState.Busy;
    message = 'Creating your account...';
    _updateState();
    try {
      final result = await firebaseAuth.createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      //get username of user
      result.user!.updateDisplayName(userNameController.text.trim());
      state = ViewState.Success;
      message = 'Welcome ${userNameController.text}';
      userNameController.clear();
      emailController.clear();
      passwordController.clear();
      _updateState();
    } on SocketException catch (_) {
      state = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseAuthException catch (e) {
      state = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      state = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  @override
  Future<bool> checkExistingUser() async {
    DocumentSnapshot snapshot =
        await firebaseFirestore.collection("users").doc(_uid).get();

    if (snapshot.exists) {
      //  print('USER EXIST');
      return true;
    } else {
      //  print('NEW USER');
      return false;
    }
  }
}
