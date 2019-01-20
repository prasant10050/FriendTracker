import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:friend_tracker/Model/User.dart';
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
  List<User> users=List();
  User user;
  DatabaseReference userRef;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user=new User(name: null,phone: "",location: null);
    userRef=FirebaseDatabase.instance.reference().child("users");
    userRef.onChildAdded.listen(_onEntryAdded);
    userRef.onChildChanged.listen(_onEntryChanged);
  }

  void _onEntryAdded(Event event) {
    setState(() {
      users.add(User.fromSnapshot(event.snapshot));
    });
  }

  void _onEntryChanged(Event event) {
    var old=users.singleWhere((entry){
      return entry.key==event.snapshot.key;
    });
    setState(() {
      users[users.indexOf(old)]=User.fromSnapshot(event.snapshot);
    });
  }

  @override
  Widget build(BuildContext context) {

    Widget _userStream(){
      return FirebaseAnimatedList(
        query: userRef,
        itemBuilder:(BuildContext context,DataSnapshot snapshot,Animation<double> animation,int index){
          return new Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ExpansionTile(
                  title: Text("${users[index].name.firstName} ${users[index].name.lastName}"),
                  children: <Widget>[
                    ListTile(
                      leading: CircleAvatar(
                        child: Text("${users[index].name.firstName[0]}"),
                      ),
                      title: Text("Contact - ${users[index].phone}"),
                      subtitle: Text("Location - latitude ${users[index].location.latitude}, longitude ${users[index].location.longitude}"),
                    ),
                  ],
                ),
              ],
            ),
          );
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
                      title: Text("Friend Tracker",
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
