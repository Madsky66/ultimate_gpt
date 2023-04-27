import 'dart:convert';
import 'package:http/http.dart' as http;

class GptController {
  final String apiKey = "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";
  final String apiUrl = "https://api.openai.com/v1/engines/davinci-codex/completions";

  GptController({apiKey, apiUrl = "https://api.openai.com/v1/engines/davinci-codex/completions"});

  Future<String> sendRequest(String prompt) async {
    final headers = {"Content-Type": "application/json", "Authorization": "Bearer $apiKey",};
    final body = jsonEncode({"prompt": prompt, "max_tokens": 100, "n": 1, "stop": null, "temperature": 0.5,});
    final response = await http.post(Uri.parse(apiUrl), headers: headers, body: body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return jsonResponse["choices"][0]["text"];
    }
    else {throw Exception("Failed to fetch data from GPT-3.5 Turbo");}
  }
}