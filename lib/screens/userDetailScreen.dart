import 'package:flutter/material.dart';
import 'package:flutter_pagination_api_demo/screens/usersListScreen.dart';

import '../models/SingleUserResponse.dart';
import '../models/UsersResponse.dart';
import '../utility/apiManager.dart';
import '../utility/appColors.dart';
import '../utility/appStrings.dart';
import '../utility/utiity.dart';
import '../widgets/fullScreenImageSlider.dart';
import '../widgets/userEmailView.dart';
import '../widgets/userImageView.dart';
import '../widgets/userNameView.dart';
import 'package:http/http.dart' as http;

class UserDetailScreen extends StatefulWidget {
  int selectedUserId;
  UserDetailScreen({
    required this.selectedUserId,
  });
  @override
  _UserDetailScreenState createState() => _UserDetailScreenState();
}

class _UserDetailScreenState extends State<UserDetailScreen> {
  bool isLoading = false;
  UserDetails userDetails = UserDetails();

  @override
  void initState() {
    super.initState();
    getUser(widget.selectedUserId);
  }


  //import 'dart:convert';
  // import 'package:connectivity/connectivity.dart';
  // import 'package:flutter/cupertino.dart';
  // import 'package:flutter/material.dart';
  //
  // class ApiManager {
  //   BuildContext context;
  //
  //   ApiManager(this.context);
  //
  //   static Future<bool> checkInternet() async {
  //     try {
  //       var connectivityResult = await (Connectivity().checkConnectivity());
  //       if (connectivityResult == ConnectivityResult.none) {
  //         return false;
  //       } else {
  //         return true;
  //       }
  //     } catch (e) {
  //       return false;
  //     }
  //   }
  //
  //   postCall({required String url, required Map request}) async {
  //     http.Response response = await http.post(Uri.parse(url), body: request);
  //     return await json.decode(response.body);
  //   }
  //
  //   deleteCall({required String url}) async {
  //     http.Response response = await http.delete(Uri.parse(url));
  //     return await jsonDecode(response.body);
  //   }
  //
  //   getCall(
  //       {required String url,  Map<String, dynamic>? request}) async {
  //     var uri = Uri.parse(url);
  //     uri = uri.replace(queryParameters: request);
  //     http.Response response = await http.get(uri);
  //     return await jsonDecode(response.body);
  //   }
  // }




  getUser(int selectedUserId) async {
    //first check for internet connectivity
    if (await ApiManager.checkInternet()) {
      //show progress
      if (mounted)
        setState(() {
          isLoading = true;
        });

      //convert json response to class
      SingleUserResponse response = SingleUserResponse.fromJson(
        await ApiManager(context).getCall(
          url: AppStrings.USERS + "/" + selectedUserId.toString(),
          request: null,
        ),
      );

      //hide progress
      if (mounted)
        setState(() {
          isLoading = false;
        });

      if (response?.data != null) {
        if (mounted) {
          setState(() {
            userDetails = response.data!;
          });
        }
      }
    } else {
      //if no internet connectivity available then show apecific message
      Utility.showToast("No Internet Connection");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body(),
    );
  }

  Widget body() {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        padding: EdgeInsets.only(top: kToolbarHeight),
                        height: kToolbarHeight * 2,
                        decoration: BoxDecoration(
                          color: AppColors.appColor,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              offset: Offset(0.0, 1.0), //(x,y)
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Container(
                          padding: EdgeInsets.only(left: 8),
                          alignment: Alignment.center,
                          child: Row(
                            children: [
                              BackButton(
                                color: AppColors.whiteColor,
                                onPressed: () {
                                  Navigator.of(context).pushAndRemoveUntil(
                                      new MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            UsersListScreen(),
                                      ),
                                      (Route<dynamic> route) => false);
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.center,
                        height: kToolbarHeight * 3,
                        child: Column(
                          children: [
                            SizedBox(
                              height: kToolbarHeight,
                            ),
                            UserImageView(
                              userDetails: userDetails,
                              onImageTap: () {
                                showDialog(
                                  builder: (context) {
                                    return AlertDialog(
                                      content: Container(
                                        height: 250,
                                        width: 250,
                                        child: FullScreenImageSlider(
                                          imagelist: [userDetails.avatar!],
                                          selectedimage: 0,
                                        ),
                                      ),
                                    );
                                  },
                                  context: context,
                                );
                              },
                              isDetailScreen: true,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  userNameView()
                ],
              ),
              isLoading ? Utility.progress(context) : Container()
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 8),
          alignment: Alignment.bottomCenter,
          child: Text("Made with ♥ in Flutter"),
        )
      ],
    );
  }

  Widget userNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        UserNameView(
          isDetailScreen: true,
          userDetails: userDetails,
        ),
        SizedBox(
          height: 16,
        ),
        UserEmailView(
          userDetails: userDetails,
          isDetailScreen: true,
        )
      ],
    );
  }
}
