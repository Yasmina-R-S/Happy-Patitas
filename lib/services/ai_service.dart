import 'dart:convert';
import 'package:http/http.dart' as http;

class AIService {

  static const apiKey = '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';

  static Future<String> sendMessage(String message) async {

    final response = await http.post(

      Uri.parse('https://openrouter.ai/api/v1/chat/completions'),

      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
      },

      body: jsonEncode({

        "model": "meta-llama/llama-3-8b-instruct",

        "messages": [
          {
            "role": "user",
            "content": message
          }
        ]
      }),
    );

    final data = jsonDecode(response.body);

    return data['choices'][0]['message']['content'];
  }
}