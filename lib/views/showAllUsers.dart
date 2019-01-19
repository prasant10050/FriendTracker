import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:friend_tracker/services/bloc/LocationBlocProvider.dart';
import 'package:friend_tracker/services/bloc/userBloc.dart';
import 'package:friend_tracker/services/bloc/userBlocProvider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class ShowAllUsers extends StatefulWidget {
  @override
  _ShowAllUsersState createState() => _ShowAllUsersState();
}

class _ShowAllUsersState extends State<ShowAllUsers> {
  GoogleMapController mapController;
  Marker marker;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
  /*var locationBloc;
  var userBloc;
  @override void didChangeDependencies() {
    super.didChangeDependencies();
    locationBloc = LocationBlocProvider.of(context);
    userBloc=UserBlocProvider.of(context);
  }
  @override
  void initState() {
    super.initState();

  }*/
  @override
  Widget build(BuildContext context) {

    /*Widget _backgroundMapView(){
      return StreamBuilder(
          stream: locationBloc.outLocation,
          builder: (context, snapshot) {
            if(!snapshot.hasData){
              return Center(
                child: CircularProgressIndicator(),
              );
            }else if(snapshot.hasError){
              return Center(child: Text("Error"),);
            }else{
              return Container(
                //height: MediaQuery.of(context).size.height,
                //width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    options: GoogleMapOptions(
                      cameraPosition: CameraPosition(
                          target: LatLng(snapshot.data[0]['latitude'], snapshot.data[0]['longitude'],),
                          zoom: 20.0),
                      mapType: MapType.normal,
                    ),
                  ),
                ),
              );
            }
          }
      );
    }*/
    Widget _listViewBuilder(Map<String,Map> document) {
      return Text(document.values.toString());

      /*return ListView.builder(
        itemCount: document.length,
        itemBuilder: (context, index) {
          return new Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ExpansionTile(
                  title: Text("UserName"),
                  children: <Widget>[
                    ListTile(
                      title: Text(document.values.toString()),
                      //subtitle: Text(document.data.snapshot.value[index].toString()),
                      *//*leading: CircleAvatar(
                        child: Text(document.values.toString()),
                      ),*//*
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      );*/
    }

    Widget _userStream(){
      return StreamBuilder<Event>(
        stream: FirebaseDatabase.instance.reference().child('users').onValue,
        builder: (context,AsyncSnapshot<Event>snapshot){
          if (snapshot.hasError) return new Text('${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Center(child: new CircularProgressIndicator());
            default:
              return _listViewBuilder(snapshot.data.snapshot.value);
          }
        },
      );
    }
    return Scaffold(
        /*appBar: AppBar(
          title: Text("All Users"),
        ),*/
        body: DefaultTabController(
          length: 2,
          child: NestedScrollView(
            headerSliverBuilder: (BuildContext context,
                bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                      centerTitle: true,
                      title: Text("Collapsing Toolbar",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                          )),
                      background: Image.asset('assets/location.png'),
                  ),
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: Colors.black87,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(icon: Icon(FontAwesomeIcons.user), text: "Users"),
                        Tab(icon: Icon(FontAwesomeIcons.map), text: "Map"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: TabBarView(
              children: <Widget>[
                _userStream(),
                //_backgroundMapView(),
              ],
            ),
          ),
        ),
    );
  }
}


class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset,
      bool overlapsContent) {
    return new Container(
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
