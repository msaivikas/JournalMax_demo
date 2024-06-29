import 'package:http/http.dart' as http;
import 'apikey.dart';
import '../database_helper.dart';
import '../authentication/auth_helper_local.dart';
import 'dart:convert';
import 'package:flutter/material.dart';

class CompletionsApi {
  // https://api.openai.com/v1/chat/completions
  static final Uri completionsEndpoint =
      Uri.parse('https://api.openai.com/v1/chat/completions');
  static final Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer ${Apikey.openAIApiKey}',
  };
  final String systemPrompt =
      "Based on the following Journal Entry, provide a list of 3 actionable items to improve one's life. YOU MUST NOT RESPOND WITH ANYTHING OTHER THAN THIS. SIMPLY, PROVIDE A LIST OF 3 ACTIONABLE ITEMS AND NO NEED TO EVEN SAY SOMETHING LIKE - Here's a list of 3 actionable items. YOUR ONLY PURPOSE IS TO RESPOND WITH A LIST OF 3 ACTIONABLE ITEMS AND NOTHING LESS AND NOTHING MORE.";
  final String model = 'gpt-3.5-turbo-0125';

  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Future<String> getTodaysJournalString(String dateString) async {
    String? userEmail = await AuthHelperLocal.getUserEmail();

    if (userEmail == null) {
      throw Exception('User email not found');
    }
    final entries =
        await _databaseHelper.getTodaysJournal(userEmail, dateString);
    String combinedText = '';
    for (var entry in entries) {
      combinedText += entry['textContent'] + '\n';
    }
    return combinedText.trim();
  }

  Future<String> getActionableItemsString(String dateString) async {
    final journalText = await getTodaysJournalString(dateString);
    if (journalText.trim().isEmpty) {
      return "Nothingness... a truly profound statement. But let’s try some words this time.\nDo not live on empty words. Say something.\n\n";
    }
    debugPrint(journalText);
    debugPrint(' ****************journalText*******\n');
    final http.Response response = await http.post(
      completionsEndpoint,
      headers: headers,
      body: json.encode({
        'model': model,
        'messages': [
          {
            'role': 'system',
            'content': systemPrompt,
          },
          {
            'role': 'user',
            'content': journalText,
          },
        ],
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final content = data['choices'][0]['message']['content'].trim();

      return content;
    } else {
      throw Exception('failed to load actionable items');
    }
  }
}
