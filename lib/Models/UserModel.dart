import 'package:firebase_auth/firebase_auth.dart';

class CrudMetadata {
  static Map<String, dynamic> getCrudMetadata(DateTime date, String creator) {
    return {
      "_createdAt": date.toString(),
      "_createdBy": {"id": creator},
      "_updatedAt": null,
      "_updatedBy": {"id": null},
      "_deletedAt": null,
      "_deletedBy": {"id": null},
      "_isDeleted": false,
      "_isDownload": false
    };
  }
}

class UserModel with CrudMetadata {
  static Map<String, dynamic> getUserMap(DateTime date){

    Map<String, dynamic> result = {};
    result.addAll(CrudMetadata.getCrudMetadata(date, FirebaseAuth.instance.currentUser!.uid));
    result.addAll({
      "displayName": FirebaseAuth.instance.currentUser!.displayName,
      "email": FirebaseAuth.instance.currentUser!.email,
      "firstName":FirebaseAuth.instance.currentUser!.displayName,
      "lastName":null,
      "id": FirebaseAuth.instance.currentUser!.uid,
      "phoneNumber":null,
      "photoURL":FirebaseAuth.instance.currentUser?.photoURL,
      "roles": {"admin":false, "member":true},
    });

    return result;
  }

}