import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:share_zone/commons/ip4url.dart';
import 'package:share_zone/constants/color.dart';
import 'package:share_zone/controller/user_controller.dart';
import 'package:http/http.dart' as http;
import 'package:share_zone/screens/exploration_screen/exploration_people_screen/exploration_screen.dart';

class SearchBox extends StatefulWidget {
  final bool isSearching;

  const SearchBox({super.key, required this.isSearching});

  @override
  State<SearchBox> createState() => _SearchBoxState();
}

class _SearchBoxState extends State<SearchBox> {
  List<dynamic> userNames = [];
  final UserController userController = Get.find();
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserNames();
  }

  Future<void> fetchUserNames() async {
    int? userId = int.tryParse(userController.getLoginUserIdController().value);
    try {
      final response = await http.get(Uri.parse("${Ip4Url.baseUrl}/api/get_user_names"));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          userNames = data['names'].where((user) => user['id'] != userId).toList();
          userController.setFilteredUserName(userNames);
        });
      } else {
        print("Failed to load names: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: widget.isSearching
            ? TextField(
          controller: searchController,
          onChanged: (value) => runFilter(value),
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.all(0),
            prefixIcon: Icon(Icons.search, color: Colors.black, size: 20),
            prefixIconConstraints: BoxConstraints(maxHeight: 20, minWidth: 25),
            hintStyle: TextStyle(color: TdGrey),
            hintText: 'Search',
          ),
        )
            : GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Get.to(() => const ExplorationScreen()),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: const [
                Icon(Icons.search, color: Colors.black, size: 20),
                SizedBox(width: 8),
                Text("Search", style: TextStyle(color: TdGrey)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void runFilter(String enteredKeyword) {
    List<dynamic> results = enteredKeyword.isEmpty
        ? userNames
        : userNames.where((user) {
      return user['name'].toLowerCase().contains(enteredKeyword.toLowerCase()) ||
          user['surname'].toLowerCase().contains(enteredKeyword.toLowerCase());
    }).toList();

    userController.setFilteredUserName(results);
  }
}
