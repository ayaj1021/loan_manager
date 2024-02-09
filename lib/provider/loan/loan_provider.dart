import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/model/loan_model.dart';
import 'package:loan_manager/shared/utils/app_logger.dart';

abstract class LoanProviderUseCase {
  Future<void> addLoan();
  Future<void> viewLoan();
  Future<void> searchLoan();
  Future<void> viewLoanById(String loanId);
  Future<void> deleteLoan(String loanId);
  Future<void> updateLoan(String loanId);
}

class LoanProviderImpl extends ChangeNotifier implements LoanProviderUseCase {
  TextEditingController loanNameController = TextEditingController();
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController incurredDateController = TextEditingController();
  TextEditingController dueDateController = TextEditingController();
  TextEditingController searchLoanQueryController = TextEditingController();
  TextEditingController creditorOrDebtorNameController =
      TextEditingController();
  TextEditingController creditorOrDebtorPhoneNumberController =
      TextEditingController();

  Currency? _selectedCurrency;
  Currency? get selectedCurrency => _selectedCurrency;

  set selectedCurrency(Currency? currency) {
    _selectedCurrency = currency;
    _updateState();
  }

  ViewState _viewState = ViewState.Idle;

  ViewState get viewState => _viewState;

  set viewState(ViewState value) {
    _viewState = value;
    _updateState();
  }

  String _message = '';

  String get message => _message;

  set message(String value) {
    _message = value;
    _updateState();
  }

  //for loan type
  LoanType? _selectedLoanType;
  LoanType? get selectedLoanType => _selectedLoanType;
  set selectedLoanType(LoanType? value) {
    _selectedLoanType = value;
    _updateState();
  }

  String? _uploadedDocument;

  String? get uploadedDocument => _uploadedDocument;

  set uploadedDocument(String? doc) {
    _uploadedDocument = doc;
    _updateState();
  }

  //Part of saving the loans to firebase
  final _loanRef = FirebaseFirestore.instance.collection('loans');
  final _user = FirebaseAuth.instance.currentUser;

  List<LoanModel> _loans = [];

  List<LoanModel> get loans => _loans;

  //pending loans

  List<LoanModel> _pendingLoans = [];

  List<LoanModel> get pendingLoans => _pendingLoans;

  //Completed loans

  List<LoanModel> _completedLoans = [];

  List<LoanModel> get completedLoans => _completedLoans;

  //Single loan
  LoanModel? _singleLoan;

  LoanModel? get singleLoan => _singleLoan;

  //Search loan
  List<LoanModel>? _searchedLoan;

  List<LoanModel>? get searchedLoan => _searchedLoan;

  @override
  Future<void> addLoan() async {
    _viewState = ViewState.Busy;
    message = "Securing and saving your loan details...";
    _updateState();

    try {
      final payLoad = LoanModel(
          loanId: '',
          loanName: loanNameController.text,
          loanType: _selectedLoanType!.name,
          loanDoc: _uploadedDocument,
          loanAmount: loanAmountController.text,
          loanCurrency: LoanCurrency.fromJson(selectedCurrency!.toJson()),
          loanDateIncurred: DateTime.parse(incurredDateController.text),
          loanStatus: LoanStatus.Pending.name,
          loanDateDue: DateTime.parse(dueDateController.text),
          fullName: creditorOrDebtorNameController.text,
          phoneNumber: creditorOrDebtorPhoneNumberController.text);

      appLogger(payLoad);
      _loanRef.doc(_user!.uid).collection("loan_details").add(payLoad.toJson());

      _viewState = ViewState.Success;
      message = "Saved successfully";
      _updateState();

      _clearFields();
    } on SocketException catch (_) {
      _viewState = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseException catch (e) {
      _viewState = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      _viewState = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  @override
  Future<void> deleteLoan(String loanId) async {
    _viewState = ViewState.Busy;
    message = "Deleting your loan...";
    _updateState();

    try {
      final result = await _loanRef
          .doc(_user!.uid)
          .collection("loan_details")
          .doc(loanId)
          .get();

      if (result.exists) {
        await _loanRef
            .doc(_user.uid)
            .collection("loan_details")
            .doc(loanId)
            .delete();
        _viewState = ViewState.Success;
        message = "Loans Deleted Successfully";
      } else {
        message = "Loan with ID : $loanId does not exist";
        _viewState = ViewState.Error;
      }

      _updateState();
    } on SocketException catch (_) {
      _viewState = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseException catch (e) {
      _viewState = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      _viewState = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  @override
  Future<void> searchLoan() async {
    _viewState = ViewState.Busy;
    message = "Searching for loan...";
    _updateState();

    await Future.delayed(const Duration(seconds: 1));

    try {
      final result = _loans.where((element) => element.loanName
          .toLowerCase()
          .contains(searchLoanQueryController.text.toLowerCase()));

      _searchedLoan = result.toList();

      _viewState = ViewState.Success;
      _updateState();
    } on SocketException catch (_) {
      _viewState = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseException catch (e) {
      _viewState = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      _viewState = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  @override
  Future<void> updateLoan(String loanId) async {
    _viewState = ViewState.Busy;
    message = "Updating your loans...";
    _updateState();

    try {
      final result = await _loanRef
          .doc(_user!.uid)
          .collection("loan_details")
          .doc(loanId)
          .get();

      if (result.exists) {
        final loanData = LoanModel.fromJson(result.data()!);

        loanData.loanStatus = LoanStatus.Completed.name;
        appLogger(loanData.toJson());

        await _loanRef
            .doc(_user.uid)
            .collection("loan_details")
            .doc(loanId)
            .update(loanData.toJson());
        _viewState = ViewState.Success;
        message = "Loans Updated Successfully";
      } else {
        message = "Loan with ID : $loanId does not exist";
        _viewState = ViewState.Error;
      }

      _updateState();
    } on SocketException catch (_) {
      _viewState = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseException catch (e) {
      _viewState = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      _viewState = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  @override
  Future<void> viewLoan() async {
    _viewState = ViewState.Busy;
    message = "Preparing your loans...";
    _updateState();
    List<LoanModel> tempData = [];

    try {
      final result =
          await _loanRef.doc(_user!.uid).collection("loan_details").get();

      if (result.docs.isNotEmpty) {
        final loanData = result.docs;

        for (var i in loanData) {
          appLogger(loanData);

          final loanDataModel = LoanModel.fromJson(i.data());

          //add id
          loanDataModel.loanId = i.id;
          tempData.add(loanDataModel);
        }

        _loans = tempData;

        _pendingLoans = (loans.where(
                (element) => element.loanStatus == LoanStatus.Pending.name))
            .toList();
        _completedLoans = (loans.where(
                (element) => element.loanStatus == LoanStatus.Completed.name))
            .toList();
      } else {
        _loans = [];
        _pendingLoans = [];
        _completedLoans = [];
      }

      _viewState = ViewState.Success;
      message = "Loans fetched";
      _updateState();
    } on SocketException catch (_) {
      _viewState = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseException catch (e) {
      _viewState = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      _viewState = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  @override
  Future<void> viewLoanById(String loanId) async {
    _viewState = ViewState.Busy;
    message = "Fetching loan details...";
    _updateState();

    try {
      final result = await _loanRef
          .doc(_user!.uid)
          .collection("loan_details")
          .doc(loanId)
          .get();
      if (result.exists) {
        final loanData = LoanModel.fromJson(result.data()!);

        _singleLoan = loanData;
        appLogger(loanData.toJson());
        _viewState = ViewState.Success;
        message = "Loan Details fetched";
      } else {
        message = "Loan with id: $loanId does not exist";
        _viewState = ViewState.Error;
      }

      _updateState();
    } on SocketException catch (_) {
      _viewState = ViewState.Error;
      message = 'Network error. Please try again later';
      _updateState();
    } on FirebaseException catch (e) {
      _viewState = ViewState.Error;
      message = e.code;
      _updateState();
    } catch (e) {
      _viewState = ViewState.Error;
      message = 'Error creating account. Please try again later';
      _updateState();
    }
  }

  _updateState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void _clearFields() {
    loanAmountController.clear();
    _selectedLoanType = null;
    _uploadedDocument = null;
    loanAmountController.clear();
    selectedCurrency = null;
    incurredDateController.clear();
    dueDateController.clear();
    creditorOrDebtorNameController.clear();
    creditorOrDebtorPhoneNumberController.clear();
  }
}
