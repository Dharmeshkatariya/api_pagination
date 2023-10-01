import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_pagination_api_demo/screens/userDetailScreen.dart';
import 'package:visibility_detector/visibility_detector.dart';

import '../models/UsersResponse.dart';
import '../utility/apiManager.dart';
import '../utility/appStrings.dart';
import '../utility/utiity.dart';
import '../widgets/fullScreenImageSlider.dart';
import '../widgets/userItemView.dart';
import 'package:http/http.dart'as http;
class UsersListScreen extends StatefulWidget {
  @override
  _UsersListScreenState createState() => _UsersListScreenState();
}

class _UsersListScreenState extends State<UsersListScreen> {
  List<UserDetails> userDetails = [];
  int page = 0;
  int valueKey = 0;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
       GlobalKey<RefreshIndicatorState>();
  bool isLoading = false;
  bool stop = false;

  getUsers() async {
    if (await ApiManager.checkInternet()) {
      if (mounted) {
        setState(() {
          isLoading = true;
        });
      }

      page = page + 1;
      print(page);
      var request = Map<String, dynamic>();
      request["page"] = page.toString();
      var uri = Uri.parse(AppStrings.USERS);
      uri = uri.replace(queryParameters: request);
      http.Response res = await http.get(uri);
      // return await jsonDecode(response.body);
      //convert json response to class
      var data  =  await jsonDecode(res.body ) ;
      UsersResponse response = UsersResponse.fromJson(
          data
      );
      print(response) ;

      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }

      if (response != null) {
        if (response.data!.length > 0) {
          if (mounted) {
            setState(() {
              //add paginated list data in list

              userDetails.addAll(response.data as Iterable<UserDetails>);

            print(userDetails)
;            });
          }
        } else {
          noDataLogic(page);
        }
      } else {
        noDataLogic(page);
      }
    } else {
      //if no internet connectivity available then show apecific message
      Utility.showToast("No Internet Connection");
    }
  }

  noDataLogic(int pagenum) {
    //show empty view
    if (mounted) {
      setState(() {
        page = pagenum - 1;
        stop = true;
      });
    }
  }

  refresh() {
    //to refresh page
    if (mounted) {
      setState(() {
        valueKey = valueKey + 1;
        page = 0;
        userDetails.clear();
        stop = false;
      });
    }
    getUsers();
  }

  @override
  void initState() {
    super.initState();
    getUsers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Users",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
        actions: [Utility.githubAction(), Utility.websiteAction()],
      ),
      body: body(),
    );
  }

  Widget body() {
    return Stack(
      children: <Widget>[
        RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: () async {
            refresh();
          },
          child: !isLoading && userDetails.length == 0
              ? ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height -
                          ((AppBar().preferredSize.height * 2) + 30),
                      child: Utility.emptyView("No Users"),
                    ),
                  ],
                )


              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const  EdgeInsets.only(
                    bottom: 12,
                  ),
                  itemCount: userDetails.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children:[
                        (userDetails.length - 1) == index
                            ? VisibilityDetector(
                                key: Key(index.toString()),
                                child: itemView(index),
                                onVisibilityChanged: (visibilityInfo) {
                                  if (!stop) {
                                    getUsers();
                                  }
                                },
                              )
                            : itemView(index)
                      ],
                    );
                  },
                ),
        ),
        //show progress
        isLoading ? Utility.progress(context) : Container()
      ],
    );
  }

  Widget itemView(int index) {
    //users item view
    return UserItemView(
      userDetails: userDetails[index],
      onTap: () {
        Navigator.of(context).push(
           MaterialPageRoute(
            builder: (BuildContext context) => UserDetailScreen(
              selectedUserId: userDetails[index].id!,
            ),
          ),
        );
      },
      onImageTap: () {
        showDialog(
          builder: (context) {
            return AlertDialog(
              content:  SizedBox(
                height: 250,
                width: 250,
                child: FullScreenImageSlider(
                  imagelist: [userDetails[index].avatar!],
                  selectedimage: 0,
                ),
              ),
            );
          },
          context: context,
        );
      },
    );
  }
}
