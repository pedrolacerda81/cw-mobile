import 'package:flutter_dotenv/flutter_dotenv.dart';

class UrlHelper {
  static String apiUrl = DotEnv().isEveryDefined(['API_URL']) ? DotEnv().env['API_URL'] : '127.0.0.1:9000';
  static String authUrl = DotEnv().isEveryDefined(['AUTH_URL']) ? DotEnv().env['AUTH_URL'] : '127.0.0.1:3000';
}
