import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_aws/Media/Videos/videos_cubit.dart';

import 'zone_videos_bloc.dart';
import 'zone_videos_event.dart';
import 'zone_videos_state.dart';

class ZoneVideo extends StatefulWidget {
  const ZoneVideo({Key? key}) : super(key: key);

  @override
  _ZoneVideoState createState() => _ZoneVideoState();
}

class _ZoneVideoState extends State<ZoneVideo> {
  TextEditingController searchController = TextEditingController();

  String searchByValue = 'Name';
  String gradoValue = '4';

  @override
  void initState() {
    super.initState();
    context.read<ZoneVideosBloc>().add(GetZoneVideosEventGRADO());
    context.read<ZoneVideosBloc>().add(GetZoneVideosEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage('assets/bgdibujos.jpg'), fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.orangeAccent,
          iconTheme: const IconThemeData(color: Colors.white),

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_rounded,
              size: 31,
            ),
            onPressed: () {
              context.read<VideosCubit>().showZoneMenu();
            },
          ),

          actions: <Widget>[
            !context.watch<ZoneVideosBloc>().state.isSearching
                ? IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      context.read<ZoneVideosBloc>().add(ToggleSearching());
                    },
                  )
                : Expanded(
                    child: Row(
                      children: [
                        if (context.watch<ZoneVideosBloc>().state.searchBy ==
                            SearchBy.name)
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 100, bottom: 10, right: 20),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: TextFormField(
                                decoration: InputDecoration(
                                  contentPadding:
                                      const EdgeInsets.only(top: 20, left: 5),
                                  hintText: 'Search',
                                  suffixIcon: IconButton(
                                    icon: const Padding(
                                      padding: EdgeInsets.only(top: 10.0),
                                      child: Icon(Icons.search),
                                    ),
                                    onPressed: () {
                                      context
                                          .read<ZoneVideosBloc>()
                                          .add(Search());
                                    },
                                  ),
                                ),
                                onChanged: (value) {
                                  context
                                      .read<ZoneVideosBloc>()
                                      .add(SearchKeywordChanged(value: value));
                                },
                              ),
                            ),
                          )
                        else
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                DropdownButton<String>(
                                  elevation: 16,
                                  value: gradoValue,
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      gradoValue = newValue!;
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
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  icon: const Padding(
                                    padding: EdgeInsets.only(top: 10.0),
                                    child: Icon(Icons.search),
                                  ),
                                  onPressed: () {
                                    context
                                        .read<ZoneVideosBloc>()
                                        .add(Search(grado: gradoValue));
                                  },
                                ),
                              ],
                            ),
                          ),
                        DropdownButton<String>(
                          elevation: 16,
                          value: searchByValue,
                          onChanged: (String? newValue) {
                            setState(() {
                              searchByValue = newValue!;
                            });
                            if (newValue == 'Name') {
                              context
                                  .read<ZoneVideosBloc>()
                                  .add(SearchByEvent(searchBy: SearchBy.name));
                            } else if (newValue == 'Grado') {
                              context
                                  .read<ZoneVideosBloc>()
                                  .add(SearchByEvent(searchBy: SearchBy.grado));
                            }
                          },
                          items: <String>['Name', 'Grado']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.cancel),
                          onPressed: () {
                            context
                                .read<ZoneVideosBloc>()
                                .add(ToggleSearching());
                          },
                        ),
                      ],
                    ),
                  ),
          ],

          title: Text(
            context.read<ZoneVideosBloc>().category,
            style: const TextStyle(
                fontSize: 25, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 5,
          toolbarHeight: 70, //Tamaño de la toolbar
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(50),
          )),
        ),
        body: BlocBuilder<ZoneVideosBloc, ZoneVideosState>(
          builder: (BuildContext context, state) {
            return ListView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.only(top: 20),
              itemCount: !context.watch<ZoneVideosBloc>().state.isSearching
                  ? state.totalVideos
                  : state.searchedVideos
                      .length, // TODO -- total categories in state
              itemBuilder: (context, index) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5.0),
                    child: Column(
                      children: [
                        InkWell(
                          splashColor: Colors.orange,
                          onTap: () {},
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
                              children: [
                                Container(
                                  height: 75,
                                  width: 75,
                                  margin: const EdgeInsets.only(
                                      right: 10, left: 5, bottom: 10, top: 10),
                                  color: Colors.orangeAccent,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      !context
                                              .watch<ZoneVideosBloc>()
                                              .state
                                              .isSearching
                                          ? context
                                              .read<ZoneVideosBloc>()
                                              .state
                                              .videos[index]
                                          : context
                                              .read<ZoneVideosBloc>()
                                              .state
                                              .searchedVideos[index],
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),

                                    Text(
                                      !context
                                              .watch<ZoneVideosBloc>()
                                              .state
                                              .isSearching
                                          ? context
                                              .read<ZoneVideosBloc>()
                                              .state
                                              .grados[index]
                                          : context
                                              .read<ZoneVideosBloc>()
                                              .state
                                              .searchedVideosGrados[index],
                                      style: const TextStyle(
                                        fontSize: 15,
                                      ),
                                    ),
//  TODO -- change this color according to grade (grade color mapping?)
                                    Container(
                                      color: Colors.blue,
                                      height: 15,
                                      width: 15,
                                    ),
                                  ],
                                ),
                                Expanded(child: const SizedBox()),
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
