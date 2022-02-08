import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_aws/Media/Videos/videos_cubit.dart';
import 'my_videos_bloc.dart';
import 'my_videos_event.dart';
import 'my_videos_state.dart';


class MyVideosUI extends StatefulWidget {
  const MyVideosUI({Key? key}) : super(key: key);

  @override
  _MyVideosUIState createState() => _MyVideosUIState();
}

class _MyVideosUIState extends State<MyVideosUI> {

  @override
  void initState() {
    super.initState();
    context.read<MyVideosBloc>().add(GetMyVideosEvent());
    context.read<MyVideosBloc>().add(GetMyVideosEventGRADO());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgdibujos.jpg'),

              fit: BoxFit.cover
          )
      ),

      child: Scaffold(
        backgroundColor: Colors.transparent,

        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          iconTheme: IconThemeData(color: Colors.white),

          leading: IconButton(
            icon: Icon (Icons.arrow_back_ios_rounded,
              size: 31,),
            onPressed: () {
              context.read<VideosCubit>().showMyVideosMenu();
            },
          ),


          title: Text ('My videos',
            style: TextStyle (
                fontSize: 25 ,
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
              )
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              onPressed: (){

              },
            )
          ],
        ),


        body: BlocBuilder<MyVideosBloc, MyVideosState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 20),
              itemCount: state.totalVideos, // TODO -- total categories in state
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        InkWell(
                          onTap: (){

                          },
                          splashColor: Colors.orange,
                          child: Card(
                            elevation: 10,
                            color: Colors.orange.shade50,
                            margin: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20), // if you need this
                              side: BorderSide(
                                color: Colors.orange,
                                width: 2,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  height: 75,
                                  width: 75,
                                  margin: EdgeInsets.only(right: 10, left: 5, bottom: 10, top: 10),
                                  color: Colors.orangeAccent,
                                ),

                                Column(
                                  children: [
                                    Text(
                                      context.read<MyVideosBloc>().state.videos[index],
                                      style: const TextStyle(fontSize: 24),
                                    ),
                                    Text(
                                      context.read<MyVideosBloc>().state.grados[index],
                                      style: const TextStyle(fontSize: 24),
                                    ),

                                    Container(
                                      color: Colors.blue,
                                      height: 15,
                                      width: 15,
                                    ),
                                  ],
                                ),

                                Expanded(
                                  child: const SizedBox(
                                  ),
                                ),

                                Container(
                                  padding: EdgeInsets.only(right: 15),
                                  child: ElevatedButton(
                                    child: const Icon(Icons.delete),
                                    onPressed: () {
                                      context.read<MyVideosBloc>().add(DeleteVideoButtonClickedEvent(index: index));
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
      ),
    );
  }
}
