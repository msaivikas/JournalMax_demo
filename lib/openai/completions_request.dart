import 'dart:convert';

class CompletionsRequest {
  final String model;
  final String prompt;
  final String maxTokens;

  CompletionsRequest({
    required this.model,
    required this.prompt,
    required this.maxTokens,
  });

  String toJson() {
    Map<String, dynamic> jsonBody = {
      'model': model,
      'prompt': prompt,
      'maxTokens': maxTokens,
    };
    return json.encode(jsonBody);
  }
}
