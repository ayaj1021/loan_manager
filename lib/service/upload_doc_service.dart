import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:loan_manager/enums/enums.dart';
import 'package:loan_manager/model/upload_doc_model.dart';
import 'package:loan_manager/shared/utils/app_logger.dart';

Future<UploadDocResultModel> uploadDocumentToServer(String docPath) async {
  UploadTask uploadTask;
  final docName = docPath.split('/').last;

  appLogger('Uploading document to server');

  try {
    Reference ref =
        FirebaseStorage.instance.ref().child('loan_doc').child('/$docName.pdf');

    uploadTask = ref.putFile(File(docPath));

    TaskSnapshot snapshot =
        await uploadTask.whenComplete(() => appLogger('Task Completed'));

    final downloadUrl = await snapshot.ref.getDownloadURL();

    return Future.value(
        UploadDocResultModel(state: ViewState.Success, fileUrl: downloadUrl));
  } on FirebaseException catch (error) {
    appLogger("F-error uploading file : $error");
    return Future.value(UploadDocResultModel(
        state: ViewState.Error, fileUrl: "F-error uploading file"));
  } catch (error) {
    appLogger("F-error uploading file : $error");
    return Future.value(UploadDocResultModel(
        state: ViewState.Error, fileUrl: "F-error uploading file"));
  }
}
