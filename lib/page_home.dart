import 'package:flutter/material.dart';
import 'controller_brain.dart';

class HomePage extends StatefulWidget {
  final String title;
  const HomePage({Key? key, required this.title}) : super(key: key);
  @override HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  late BrainController brainController;
  final TextEditingController _inputController = TextEditingController();
  String response = '';
  final GlobalKey _dynamicWidgetsKey = GlobalKey();
  final List<Widget> _dynamicWidgets = [];
  final Map<int, VoidCallback> _buttonActions = {};
  @override void initState() {super.initState(); brainController = BrainController(this);}
  @override Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        TextField(controller: _inputController, decoration: const InputDecoration(hintText: 'Entrez votre demande', border: OutlineInputBorder(),), minLines: 1, maxLines: 5,),
        const SizedBox(height: 20),
        ElevatedButton(onPressed: () => submitRequest(_inputController.text), child: const Text('Soumettre'),),
        const SizedBox(height: 20),
        Text(response.isNotEmpty ? 'Réponse de l\'IA:\n$response' : '', style: const TextStyle(fontSize: 18),),
        const SizedBox(height: 20),
        const Text('Widgets dynamiques :'),
        Container(key: _dynamicWidgetsKey, child: Column(children: _dynamicWidgets,),),
      ],),
    );
  }
  void addNewButton() {
    setState(() {_dynamicWidgets.add(ElevatedButton(
      onPressed: () {ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Bouton ajouté dynamiquement')),);},
      child: const Text('Bouton dynamique'),),);});
  }
  void addNewButtonWithAction(String buttonText, String buttonAction) {setState(() {
    int newIndex = _dynamicWidgets.length;
    _dynamicWidgets.add(ElevatedButton(onPressed: () {ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(buttonAction)),);}, child: Text(buttonText),));
    _buttonActions[newIndex] = () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(buttonAction)));
  });}
  void modifyWidgetDesign(int widgetIndex, Color newColor) {
    if (widgetIndex >= 0 && widgetIndex < _dynamicWidgets.length) {setState(() {_dynamicWidgets[widgetIndex] = Container(
      color: newColor,
      child: _dynamicWidgets[widgetIndex],
    );});}
  }
  void modifyWidgetText(int widgetIndex, String newText) {
    if (widgetIndex >= 0 && widgetIndex < _dynamicWidgets.length) {
      Widget currentWidget = _dynamicWidgets[widgetIndex];
      if (currentWidget is Text) {setState(() {_dynamicWidgets[widgetIndex] = Text(newText);});}
      else if (currentWidget is ElevatedButton) {setState(() {_dynamicWidgets[widgetIndex] = ElevatedButton(
        onPressed: () {_buttonActions[widgetIndex]?.call();},
        child: Text(newText),);
      });
      }
      // Ajoutez d'autres conditions pour gérer différents types de widgets
    }
  }
  Future<void> submitRequest(String request) async {await brainController.submitRequest(request);}
  void updateResponse(String newResponse) {setState(() {response = newResponse;});}
}