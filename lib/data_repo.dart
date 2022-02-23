
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:file_picker/file_picker.dart';

import 'package:path_provider/path_provider.dart';
import 'Dart:io';
import 'auth/auth_repo.dart';

import 'models/File.dart' as my_datastore;
import 'models/FileType.dart' as my_datastore_type;

class DataRepo {
  late List<String> Folders;
  late List<String> Files;
  late List<StorageItem> items;

  Future<void> listItems() async {
    try {
      final ListResult result = await Amplify.Storage.list();
      items = result.items;
      for (int i = 0; i < items.length; i++) {
        print('Got items: ${items.elementAt(i).key}');
      }
    } on StorageException catch (e) {
      print('Error listing items: $e');
    }
  }
  //
  // Future<List<String>> getCategories() async {
  //   print('**********************************          getCategories (VIDEO)         DATA REPO     ****************************');    await listItems();
  //   List<String> res = [];
  //   for (int i = 0; i < items.length; i++) {
  //     String str = items.elementAt(i).key;
  //     if (str.contains("Videos/")) {
  //       List<String> list = str.split("/");
  //
  //       if (!res.contains(list.elementAt(1)) && str != "Videos/") {
  //         res.add(list.elementAt(1));
  //       }
  //     }
  //   }
  //   return res;
  // }

  //ALL videos
  // List<String> getVideoForUI(String category) {
  //
  //   print('**********************************         getVideoForUI          DATA REPO     ****************************');
  //
  //   List<String> res = [];
  //   int start = 0;
  //   for (int i = 0; i < items.length; i++) {
  //     String str = items.elementAt(i).key;
  //
  //     if (str.contains("Videos/$category")) {
  //       start++;
  //
  //       if (start > 1) {
  //         String tmp = str.split("/").elementAt(2);
  //         res.add(tmp.split("@").first);
  //       }
  //     }
  //   }
  //
  //   return res;
  // }
  //
  // List<String> getVideoNames(String category) {
  //
  //   print('**********************************        getVideoNames           DATA REPO     ****************************');
  //
  //   List<String> res = [];
  //   int start = 0;
  //   for (int i = 0; i < items.length; i++) {
  //     String str = items.elementAt(i).key;
  //
  //     if (str.contains("Videos/$category")) {
  //       start++;
  //
  //       if (start > 1) {
  //         res.add(str.split("/").elementAt(2));
  //       }
  //     }
  //   }
  //
  //   return res;
  // }

  //User Specific Videos
  Future<List<String>> getMyVideos(String category) async {
    AuthRepo authRepo = AuthRepo();

    String userID = await authRepo.getUserIDFromAttributes();

    List<String> res = [];
    int start = 0;
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/$category")) {
        start++;

        if (start > 1) {
          String temp = str.split("/").elementAt(2);
          if (temp.contains(userID)) {
            res.add(temp);
          }
        }
      }
    }
    return res;
  }

  Future<List<String>> getMyVideosForUI(String category) async {
    AuthRepo authRepo = AuthRepo();
    String userID = await authRepo.getUserIDFromAttributes();
    List<String> res = [];
    int start = 0;
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/$category")) {
        start++;

        if (start > 1) {
          String temp = str.split("/").elementAt(2);
          if (temp.contains(userID)) {
            res.add(temp.split("@").first);
          }
        }
      }
    }
    return res;
  }

  Future<String> getVideoURL(String category, String name) async {

    AuthRepo authRepo = AuthRepo();
    String userID = await authRepo.getUserIDFromAttributes();
    String res = "";

    S3GetUrlOptions options = S3GetUrlOptions(
        accessLevel: StorageAccessLevel.guest, expires: 604799,targetIdentityId:userID );

    print("****Video Name*****************"+name);

    try {
      final GetUrlResult result =
          await Amplify.Storage.getUrl(key: 'Videos/$category/$name',options: options);

      res = result.url;
    } on StorageException catch (e) {
      print('********************Error getting download URL******************: $e');
    }

    return res;
  }

  Future<void> downloadVideo(String category, String name) async {
    String str=DateTime.now().toString();
    final documentsDir = await getApplicationDocumentsDirectory();
    final filepath = documentsDir.path + '/Example_$str';
    final file = File(filepath);
    await Amplify.Storage.downloadFile(
        key: 'Videos/$category/$name',
        local: file,
        onProgress: (progress) {
          print("Fraction completed: " + progress.getFractionCompleted().toString());
        }
    );
  }

  Future<void> deleteVideo(String category, String name) async {
    try {
      final RemoveResult result =
          await Amplify.Storage.remove(key: 'Videos/$category/$name');
          await Amplify.Storage.remove(key: 'Fotos/$category/$name');
      print('Deleted file: ${result.key}');
    } on StorageException catch (e) {
      print('Error deleting file: $e');
    }
  }

  Future<String> uploadVideo(
      FilePickerResult? _result, String category, String name,String? desc, String grado) async {
    if (_result == null) {
      return 'No file selected';
    }
    else{
      var auth = AuthRepo();
      var str = await auth.getUserIDFromAttributes();

      final options = S3UploadFileOptions(
        accessLevel: StorageAccessLevel.guest,

        metadata: <String, String>{
          'project': desc!,
        },
      );

      String fileName = name + "@" + str + "GRADO" + grado + "FECHA" + DateTime.now().toString();
      final platformFile = _result.files.elementAt(0);
      final path = platformFile.path!;
      final key = "Videos/$category/$fileName.mp4";
      final file = File(path);

      print("File Upload name: " + fileName);
      await Amplify.Storage.uploadFile(
          local: file, key: key, options: options, onProgress: (progress) {});

      return 'Uploaded Successfully';
    }
  }


  Future<String> uploadImage(
      FilePickerResult? _imageresult, String categoryimagen, String name,String? desc, String grado)

    async {
    if (_imageresult == null) {
      return 'No file selected';
    }
    else{
      var auth = AuthRepo();
      var str = await auth.getUserIDFromAttributes();
      final options = S3UploadFileOptions(
        accessLevel: StorageAccessLevel.guest,

        metadata: <String, String>{
          'project': desc!,
        },
      );

      String fileName = name + "@" + str + "GRADO" + grado + "FECHA" + DateTime.now().toString();
      final platformFile = _imageresult.files.elementAt(0);
      final path = platformFile.path!;
      final key = "Fotos/$categoryimagen/$fileName.jpg";
      final file = File(path);

      print("File Upload name: " + fileName);
      await Amplify.Storage.uploadFile(
          local: file, key: key, options: options, onProgress: (progress) {});

      return 'Uploaded Successfully';
    }
  }



  Future<void> listItemsSectoresMenu() async {
    print('**********************************          listItemsSectores         DATA REPO     ****************************');
    try {
      final ListResult result = await Amplify.Storage.list();
      items = result.items;
      for (int i = 0; i < items.length; i++) {
        print('**********************************************Got items: ${items.elementAt(i).key}');
      }
    } on StorageException catch (e) {


      print('Error listing items: $e');
    }
  }

  Future<List<String>> getCategoriesSectoresMenu() async {
    print('**********************************          getCategories SECTORES (VIDEO)         DATA REPO     ****************************');
    await listItems();
    List<String> res = [];
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/")) {
        List<String> list = str.split("/");

        if (!res.contains(list.elementAt(1)) && str != "Videos/") {
          res.add(list.elementAt(1));
        }
      }
    }
    return res;
  }

  List<String> getVideoForUISectoresMenu(String category) {
    print('**********************************         getVideoForUI SECTORES          DATA REPO     ****************************');

    List<String> res = [];
    int start = 0;
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/$category")) {
        start++;

        if (start > 1) {
          String tmp = str.split("/").elementAt(2);
          res.add(tmp.split("@").first);
        }
      }
    }
    return res;
  }

  List<String> getVideoNamesSectoresMenu(String category) {
    print('**********************************        getVideoNames SECTORES          DATA REPO     ****************************');
    List<String> res = [];
    int start = 0;
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/$category")) {
        start++;

        if (start > 1) {
          res.add(str.split("/").elementAt(2));
        }
      }
    }
    return res;
  }


  Future<void> listItemsSectoresVideos() async {
    print('**********************************          listItemsSectorVideos         DATA REPO     ****************************');
    try {
      final ListResult result = await Amplify.Storage.list();
      items = result.items;
      for (int i = 0; i < items.length; i++) {
        print('Got items: ${items.elementAt(i).key}');
      }
    } on StorageException catch (e) {

      print('Error listing items: $e');
    }
  }

  //Zone Specific Videos
  Future<List<String>> getSectorVideos(String category) async {
    print('**********************************           getSectorVideos        DATA REPO     ****************************');
    List<String> res = [];
    int start = 0;
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/$category")) {
        start++;

        if (start > 1) {
          res.add(str.split("/").elementAt(2));
        }
      }
    }

    return res;

    // AuthRepo authRepo = AuthRepo();

    // String userID = await authRepo.getUserIDFromAttributes();
    //
    // List<String> res = [];
    // int start = 0;
    // for (int i = 0; i < items.length; i++) {
    //   String str = items.elementAt(i).key;
    //
    //   if (str.contains("Videos/$category")) {
    //     start++;

        // if (start > 1) {
        //   String temp = str.split("/").elementAt(2);


                                                  ///creo   que lo siguiente hay que quitarlo
          // if (temp.contains(userID)) {
          //   res.add(temp);
          // }
        // }
    //   }
    // }
    //
    // return res;
  }

  Future<List<String>> getSectorVideosForUI(String category) async {
    // AuthRepo authRepo = AuthRepo();
    print('**********************************         getSectorVideosForUI          DATA REPO     ****************************');
    // String userID = await authRepo.getUserIDFromAttributes();
    List<String> res = [];
    int start = 0;
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/$category")) {
        start++;

        if (start > 1) {
          String tmp = str.split("/").elementAt(2);
          res.add(tmp.split("@").first);
        }
      }
    }

    return res;
    // List<String> res = [];
    // int start = 0;
    // for (int i = 0; i < items.length; i++) {
    //   String str = items.elementAt(i).key;
    //
    //   if (str.contains("Videos/$category")) {
    //     start++;
        //
        // if (start > 1) {
        //   String temp = str.split("/").elementAt(2);
        //
        //
        //   // if (temp.contains(userID)) {
        //   //   res.add(temp.split("@").first);
        //   // }
        // }
    //   }
    // }
    //
    // return res;
  }

  Future<List<String>> getVideosGrado(String category) async {
    // AuthRepo authRepo = AuthRepo();

    print('**********************************         getSectorVideosForUI          DATA REPO     ****************************');

    // String userID = await authRepo.getUserIDFromAttributes();
    List<String> res = [];
    int start = 0;
    for (int i = 0; i < items.length; i++) {
      String str = items.elementAt(i).key;

      if (str.contains("Videos/$category")) {
        start++;

        if (start > 1) {
          String tmp = str.split("GRADO").elementAt(1);
          res.add(tmp.split("FECHA").first);
        }
      }
    }

    return res;
    // List<String> res = [];
    // int start = 0;
    // for (int i = 0; i < items.length; i++) {
    //   String str = items.elementAt(i).key;
    //
    //   if (str.contains("Videos/$category")) {
    //     start++;
    //
    // if (start > 1) {
    //   String temp = str.split("/").elementAt(2);
    //
    //
    //   // if (temp.contains(userID)) {
    //   //   res.add(temp.split("@").first);
    //   // }
    // }
    //   }
    // }
    //
    // return res;
  }



  //NEW STARTED


Future<bool> datastoreUploadFile(String name, String category, String description, int grade, FilePickerResult? video, FilePickerResult? photo)
async{

  AuthRepo authRepo = AuthRepo();
  String userID= await authRepo.getUserIDFromAttributes();
  final item = my_datastore.File(
      name:name,
      type: my_datastore_type.FileType.VIDEO,
      category: category,
      description: description,
      ownerID: userID,
      grade: grade,
      s3key: "Videos/$category/" + name +"@" + userID,
      picsS3key: "Fotos/$category/" + name +"@" + userID,
  );
  await Amplify.DataStore.save(item);





  //Uploading video
  try {
    final file = File(video!.files.first.path!);
    final UploadFileResult result = await Amplify.Storage.uploadFile(
      local: file,
      key: item.s3key,
      options: S3UploadFileOptions(
        accessLevel: StorageAccessLevel.guest,
      ),
    );
    print('Successfully uploaded Video: ${result.key}');
  } on StorageException catch (e) {
    print('Error uploading file: $e');
  }


  if(photo!=null) {
    //Upploading Photo
    try {
      final file = File(photo.files.first.path!);
      final UploadFileResult result = await Amplify.Storage.uploadFile(
        local: file,
        key: item.picsS3key!,
        options: S3UploadFileOptions(
          accessLevel: StorageAccessLevel.guest,
        ),
      );
      print('Successfully uploaded Video: ${result.key}');
    } on StorageException catch (e) {
      print('Error uploading file: $e');
    }
  }


  print("UPLOADED");
  return true;
}

Future<List<my_datastore.File>> listFilesByCategory(String category)
  async{
    List<my_datastore.File> items =[];

    try {
      items = await Amplify.DataStore.query(my_datastore.File.classType, where: my_datastore.File.CATEGORY.eq(category));

    } catch (e) {
      print("Could not query DataStore: " + e.toString());
    }

    return items;
  }

  Future<String> getVideoLink(my_datastore.File item)
  async{
    String str="";
    try {
      final GetUrlResult result =
      await Amplify.Storage.getUrl(key: item.s3key);
      // NOTE: This code is only for demonstration
      // Your debug console may truncate the printed url string
      print('Got URL: ${result.url}');

      return result.url;
    } on StorageException catch (e) {
      print('Error getting download URL: $e');
    }

    return str;
  }

  Future<String> getPhotoLink(my_datastore.File item)
  async{
    String str="";
    if(item.picsS3key!=null) {
      try {
        final GetUrlResult result =
        await Amplify.Storage.getUrl(key: item.picsS3key!);
        // NOTE: This code is only for demonstration
        // Your debug console may truncate the printed url string
        print('Got URL: ${result.url}');

        return result.url;
      } on StorageException catch (e) {
        print('Error getting download URL: $e');
      }
    }
    return str;
  }



}







