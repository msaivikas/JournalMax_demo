import 'dart:convert';
import 'package:http/http.dart';

// RESPONSE STRUCTURE OF OPENAI API
// {
//   "id": "chatcmpl-123",
//   "object": "chat.completion",
//   "created": 1677652288,
//   "model": "gpt-3.5-turbo-0125",
//   "system_fingerprint": "fp_44709d6fcb",
//   "choices": [{
//     "index": 0,
//     "message": {
//       "role": "assistant",
//       "content": "\n\nHello there, how may I assist you today?",
//     },
//     "logprobs": null,
//     "finish_reason": "stop"
//   }],
//   "usage": {
//     "prompt_tokens": 9,
//     "completion_tokens": 12,
//     "total_tokens": 21
//   }
// }

class CompletionsResponse {
  final String? id;
  final String object;
  final int created;
  final String model;
  final String? systemFingerprint;
  final List<dynamic>? choices;
  final Map<String, dynamic>?
      usage; //hoping that there's no need for creating special vars for usage-inner-items unlike mentioned in the tutorial
  final String? aiTextResponse;
  const CompletionsResponse({
    required this.id,
    required this.object,
    required this.created,
    required this.model,
    required this.systemFingerprint,
    required this.choices,
    required this.usage,
    required this.aiTextResponse,
  });

  factory CompletionsResponse.fromResponse(Response response) {
    Map<String, dynamic> responseBody = json.decode(response.body);
    Map<String, dynamic> usage = responseBody['usage'];
    List<dynamic> choices = responseBody['choices'];

    String aiTextResponse = choices[0]['text'];

    return CompletionsResponse(
      id: responseBody['id'],
      object: responseBody['object'],
      created: responseBody['created'],
      model: responseBody['model'],
      systemFingerprint: responseBody['system_fingerprint'],
      choices: choices,
      usage: usage,
      aiTextResponse: aiTextResponse,
    );
  }
}
