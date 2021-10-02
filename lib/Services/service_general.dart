import 'package:WE/API/API_general_services.dart';
import 'package:flutter/material.dart';

class GeneralServices extends ChangeNotifier {
  final APIGeneralServices _apiGeneralServices = APIGeneralServices();

  Future getLeaderBoard() async {
    List leaderBoardList = await _apiGeneralServices.getLeaderBoard();
    return leaderBoardList;
  }
}
