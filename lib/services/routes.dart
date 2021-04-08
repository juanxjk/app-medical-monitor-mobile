final baseUrl = Uri.http("10.0.2.2:3000", "/");

Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

Map<String, String> headerWithAuth(String token) => {
      ...headers,
      'Authorization': 'Bearer $token',
    };
