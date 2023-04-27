import 'package:flutter/material.dart';
import 'package:tinycolor/tinycolor.dart';
import 'package:ultimate_gpt/page_home.dart';
import 'controller_gpt.dart';

class BrainController {
  final HomePageState _homePageState;
  BrainController(this._homePageState);

  List<String> parseTasks(String aiResponse) {
    return aiResponse.split('\n');
  }

  Color getColorFromString(String colorString) {
    try {return TinyColor.fromString(colorString).color;}
    catch (e) {return Colors.black;}
  }


  void executeSubTask(String subTask, HomePageState homePageState) {
    RegExp modifyDesignPattern = RegExp(r'modifier le design du widget (\d+) en (.+)');
    RegExp addButtonWithActionPattern = RegExp(r'ajouter un bouton avec ce texte "([^"]+)" et cette action "([^"]+)"');
    RegExp modifyWidgetTextPattern = RegExp(r'modifier le texte du widget (\d+) en "([^"]+)"');

    if (subTask.startsWith('ajouter un bouton')) {
      homePageState.addNewButton();
    } else if (modifyDesignPattern.hasMatch(subTask)) {
      Match match = modifyDesignPattern.firstMatch(subTask)!;
      int widgetIndex = int.parse(match.group(1)!);
      Color newColor = getColorFromString(match.group(2)!);
      homePageState.modifyWidgetDesign(widgetIndex, newColor);
    } else if (addButtonWithActionPattern.hasMatch(subTask)) {
      Match match = addButtonWithActionPattern.firstMatch(subTask)!;
      String buttonText = match.group(1)!;
      String buttonAction = match.group(2)!;
      homePageState.addNewButtonWithAction(buttonText, buttonAction);
    } else if (modifyWidgetTextPattern.hasMatch(subTask)) {
      Match match = modifyWidgetTextPattern.firstMatch(subTask)!;
      int widgetIndex = int.parse(match.group(1)!);
      String newText = match.group(2)!;
      homePageState.modifyWidgetText(widgetIndex, newText);
    }
  }

  Future<void> submitRequest(String request) async {
    GptController gptController = GptController();
    String aiResponse = await gptController.sendRequest(request);
    List<String> tasks = parseTasks(aiResponse);
    for (String task in tasks) {
      executeSubTask(task, _homePageState);
    }
    _homePageState.updateResponse(aiResponse);
  }
}