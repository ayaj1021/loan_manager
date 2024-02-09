import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/enums/enums.dart';

abstract class AuthenticationProviderUseCase {
  Future<void> logInUser();
  Future<void> registerUser();
  Future<void> logOutUser();
}

class AuthenticationProviderImpl extends ChangeNotifier
    implements AuthenticationProviderUseCase {
  final userNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final firebaseAuth = FirebaseAuth.instance;

  ViewState state = ViewState.Idle;
  String message = '';

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
  Future<void> registerUser() async {
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
}
