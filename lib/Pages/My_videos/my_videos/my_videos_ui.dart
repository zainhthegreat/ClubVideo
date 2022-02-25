// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:video_aws/Media/Videos/videos_cubit.dart';
// import 'my_videos_bloc.dart';
// import 'my_videos_event.dart';
// import 'my_videos_state.dart';
//
// class MyVideosUI extends StatefulWidget {
//   const MyVideosUI({Key? key}) : super(key: key);
//
//   @override
//   _MyVideosUIState createState() => _MyVideosUIState();
// }
//
// class _MyVideosUIState extends State<MyVideosUI> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<MyVideosBloc>().add(GetMyVideosEvent());
//     context.read<MyVideosBloc>().add(GetMyVideosEventGRADO());
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: const BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/bgdibujos.jpg'), fit: BoxFit.cover)),
//       child: Scaffold(
//         backgroundColor: Colors.transparent,
//         appBar: AppBar(
//           backgroundColor: Colors.orangeAccent,
//           iconTheme: const IconThemeData(color: Colors.white),
//           leading: IconButton(
//             icon: const Icon(
//               Icons.arrow_back_ios_rounded,
//               size: 31,
//             ),
//             onPressed: () {
//               context.read<VideosCubit>().showMyVideosMenu();
//             },
//           ),
//           title: const Text(
//             'My videos',
//             style: TextStyle(
//                 fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
//           ),
//           centerTitle: true,
//           elevation: 5,
//           toolbarHeight: 70,
//           shape: const RoundedRectangleBorder(
//               borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(0),
//             bottomRight: Radius.circular(50),
//           )),
//           actions: [
//             IconButton(
//               icon: const Icon(Icons.search),
//               onPressed: () {},
//             )
//           ],
//         ),
//         body: BlocBuilder<MyVideosBloc, MyVideosState>(
//           builder: (BuildContext context, state) {
//             return ListView.builder(
//               shrinkWrap: true,
//               padding: const EdgeInsets.only(top: 20),
//               itemCount: state.totalVideos, // TODO -- total categories in state
//               itemBuilder: (context, index) {
//                 return Center(
//                   child: Padding(
//                     padding: const EdgeInsets.symmetric(vertical: 5.0),
//                     child: Column(
//                       children: [
//                         InkWell(
//                           onTap: () {},
//                           splashColor: Colors.orange,
//                           child: Card(
//                             elevation: 10,
//                             color: Colors.orange.shade50,
//                             margin: const EdgeInsets.symmetric(
//                                 vertical: 5, horizontal: 20),
//                             shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.circular(20), // if you need this
//                               side: const BorderSide(
//                                 color: Colors.orange,
//                                 width: 2,
//                               ),
//                             ),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 Image.network(context.watch<MyVideosBloc>().state.images[index],
//                                   width: 75,
//                                   height: 75,),
//                                 Column(
//                                   children: [
//                                     Text(
//                                       context
//                                           .read<MyVideosBloc>()
//                                           .state
//                                           .videos[index],
//                                       style: const TextStyle(fontSize: 24),
//                                     ),
//                                     Text(
//                                       context
//                                           .read<MyVideosBloc>()
//                                           .state
//                                           .grados[index],
//                                       style: const TextStyle(fontSize: 24),
//                                     ),
//                                     Container(
//                                       color: Colors.blue,
//                                       height: 15,
//                                       width: 15,
//                                     ),
//                                   ],
//                                 ),
//                                 const Expanded(
//                                   child: SizedBox(),
//                                 ),
//                                 Container(
//                                   padding: const EdgeInsets.only(right: 15),
//                                   child: ElevatedButton(
//                                     child: const Icon(Icons.delete),
//                                     onPressed: () {
//                                       context.read<MyVideosBloc>().add(
//                                           DeleteVideoButtonClickedEvent(
//                                               index: index));
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_aws/Media/Videos/videos_cubit.dart';

import 'my_videos_bloc.dart';
import 'my_videos_event.dart';
import 'my_videos_state.dart';


Color getColorFromGrade(int grade) {
  Color col = Colors.white;

  grade == 0
      ? col = Colors.white
      : grade == 1
      ? col = Colors.red
      : grade == 2
      ? col = Colors.redAccent
      : grade == 3
      ? col = Colors.blue
      : grade == 4
      ? col = Colors.blueAccent
      : grade == 5
      ? col = Colors.green
      : grade == 6
      ? col = Colors.greenAccent
      : grade == 7
      ? col = Colors.orange
      : grade == 8
      ? col = Colors.orangeAccent
      : grade == 9
      ? col = Colors.purple
      : grade == 10
      ? col = Colors.purpleAccent
      : grade == 11
      ? col = Colors.yellow
      : grade == 12
      ? col =
      Colors.yellowAccent
      : col = Colors.black;

  return col;
}

String getTextFromGrade(int grade) {
  String grado = '4';

  grade == 0
      ? grado = '4'
      : grade == 1
      ? grado = '5'
      : grade == 2
      ? grado = '5+'
      : grade == 3
      ? grado = '6a'
      : grade == 4
      ? grado = '6a+'
      : grade == 5
      ? grado = '6b'
      : grade == 6
      ? grado = '6b+'
      : grade == 7
      ? grado = '6c'
      : grade == 8
      ? grado = '6c+'
      : grade == 9
      ? grado = '7a'
      : grade == 10
      ? grado = '7a+'
      : grade == 11
      ? grado = '7b'
      : grade == 12
      ? grado = '7b+'
      : grado = '';

  return grado;
}

class MyVideosUI extends StatefulWidget {
  const MyVideosUI({Key? key}) : super(key: key);

  @override
  _MyVideosUIState createState() => _MyVideosUIState();
}

class _MyVideosUIState extends State<MyVideosUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
          backgroundColor: Colors.orangeAccent,
          iconTheme: const IconThemeData(color: Colors.white),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 31,
            ),
            onPressed: () {
              context.read<VideosCubit>().showMyVideosMenu();
            },
          ),
          title: const Text(
            'My videos',
            style: TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 5,
          toolbarHeight: 70,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(50),
          )),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {},
            )
          ],
        ),
      body: BlocBuilder<MyVideosBloc, MyVideosState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 20),
             itemCount: 4,
              //itemCount: state.totalVideos, // TODO -- total categories in state
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {},
                          splashColor: Colors.orange,
                          child: Card(
                            elevation: 10,
                            color: Colors.orange.shade50,
                            margin: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(20), // if you need this
                              side: const BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                               // Image.network(context.watch<MyVideosBloc>().state.images[index],
                               //   width: 75,
                               //   height: 75,),
                                Column(
                                  children: [
                                    Text(
                                      "TEST",
                                      // context
                                      //     .read<MyVideosBloc>()
                                      //     .state
                                      //     .videos[index],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      "TEST",
                                      // context
                                      //     .read<MyVideosBloc>()
                                      //     .state
                                      //     .grados[index],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Container(
                                      color: Colors.blue,
                                      height: 15,
                                      width: 15,
                                    ),
                                  ],
                                ),
                                const Expanded(
                                  child: SizedBox(),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(right: 15),
                                  child: ElevatedButton(
                                    child: const Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<MyVideosBloc>().add(
                                          DeleteVideoButtonClickedEvent(
                                              index: index));
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),



      //ZZZ
    );
  }
}
