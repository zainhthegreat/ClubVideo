import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_aws/Media/Videos/videos_cubit.dart';
import 'package:video_aws/Pages/Upload/upload_video/upload_videos_bloc.dart';
import 'package:video_aws/Pages/Upload/upload_video/upload_videos_event.dart';
import 'package:video_aws/Pages/Upload/upload_video/upload_videos_state.dart';

class UploadVideo extends StatefulWidget {
  const UploadVideo({Key? key}) : super(key: key);

  @override
  _UploadVideoState createState() => _UploadVideoState();
}

class _UploadVideoState extends State<UploadVideo> {
  late TextEditingController _nameController;
  late TextEditingController _gradoController;
  String dropdownValue = '4';
  late TextEditingController _descController;
  bool uploadValidVideo = false;
  bool uploadValidImage = false;

  @override
  void initState() {
    super.initState();
    context.read<UploadVideoBloc>().category =
        context.read<VideosCubit>().category;
    _nameController = TextEditingController();
    _gradoController = TextEditingController();

    _descController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _gradoController.dispose();

    _descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScrollController _controller = new ScrollController();

    return BlocListener<UploadVideoBloc, UploadVideoState>(
      listener: (BuildContext context, state) {
        if (state.uploaded == true) {
          const snackBar = SnackBar(
            content: Text('ÉXIT: Video upload'),
            backgroundColor: Colors.orange,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/bgdibujos.jpg'), fit: BoxFit.cover)),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.orangeAccent,
            iconTheme: IconThemeData(color: Colors.white),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_ios_rounded,
                size: 31,
              ),
              onPressed: () {
                context.read<VideosCubit>().showMenuUploadVideos();
              },
            ),
            title: const Text(
              "Upload Video",
              style: TextStyle(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            elevation: 5,
            toolbarHeight: 70,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(50),
            )),
          ),
          body: ListView(
            controller: _controller,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 25, left: 25, right: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Stack(
                          children: <Widget>[
                            // Stroked text as border.
                            Text(
                              'Zone :',
                              style: TextStyle(
                                fontSize: 25,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.white,
                              ),
                            ),
                            // Solid text as fill.
                            Text(
                              'Zone :',
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.orangeAccent,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Stack(
                          children: <Widget>[
                            // Stroked text as border.
                            Text(
                              context.read<UploadVideoBloc>().category,
                              style: TextStyle(
                                fontSize: 25,
                                foreground: Paint()
                                  ..style = PaintingStyle.stroke
                                  ..strokeWidth = 2
                                  ..color = Colors.white,
                              ),
                            ),
                            // Solid text as fill.
                            Text(
                              context.read<UploadVideoBloc>().category,
                              style: TextStyle(
                                fontSize: 25,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    ///FotoView
                    Container(
                      margin: EdgeInsets.only(top: 30),
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(20)),
                    ),

                    SizedBox(
                      height: 30,
                    ),

                    Container(
                      child: TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Name video',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.read<UploadVideoBloc>().add(
                                      FilePickerUploadVideoButtonClickedEvent(),
                                    );
                                setState(() {
                                  uploadValidVideo = true;
                                });
                              },
                              child: const Text('Select Video'),
                            ),

                            ///select video

                            const SizedBox(
                              width: 10,
                            ),

                            ElevatedButton(
                              onPressed: () {
                                context.read<UploadVideoBloc>().add(
                                      ImageFilePickerUploadVideoButtonClickedEvent(),
                                    );
                                setState(() {
                                  uploadValidImage = true;
                                });
                              },
                              child: const Text('Select Image'),
                            ),

                            ///Select Image
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Column(
                          children: [
                            SizedBox(
                              width: 60,
                              height: 38,
                              child: DropdownButton<String>(
                                elevation: 16,
                                value: dropdownValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    dropdownValue = newValue!;
                                  });
                                },
                                items: <String>[
                                  '4',
                                  '5',
                                  '5+',
                                  '6a',
                                  '6a+',
                                  '6b',
                                  '6b+',
                                  '6c',
                                  '6c+',
                                  '7a',
                                  '7a+',
                                  '7b',
                                  '7b+'
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                              // child: TextField(
                              //
                              //   controller: _gradoController,
                              //   decoration: const InputDecoration(
                              //     border: OutlineInputBorder(),
                              //     labelText: 'Grado',
                              //     floatingLabelBehavior: FloatingLabelBehavior.always
                              //   ),
                              // ),
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            ElevatedButton(
                              onPressed: () {
                                if (_nameController.text.isNotEmpty &&
                                    uploadValidVideo == true &&
                                    _gradoController.text.isNotEmpty &&
                                    uploadValidImage == true) {
                                  context.read<UploadVideoBloc>().add(
                                        UploadVideoButtonClickedEvent(
                                            fileName: _nameController.text,
                                            grado: _gradoController.text,
                                            desc: _descController.text,
                                            category: ''),
                                      );

                                  const snackBar = SnackBar(
                                    content:
                                        Text('Uploading video, please wait...'),
                                    backgroundColor: Colors.orange,
                                  );
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);

                                  setState(() {
                                    uploadValidVideo = false;
                                    uploadValidImage = false;

                                    _nameController.clear();
                                    _gradoController.clear();

                                    _descController.clear();

                                    ///BO
                                  });
                                }
                              },
                              child: const Text('Upload Video'),
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    uploadValidVideo == true &&
                                            uploadValidImage == true
                                        ? Colors.orange
                                        : Colors.grey),
                              ),
                            ),

                            ///Upload video
                          ],
                        ),
                      ],
                    ),

                    ///Botons
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
