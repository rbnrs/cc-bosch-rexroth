class RoutingData {
  final String route;
  final Map<String, String> queryParameters;

  RoutingData({
    required this.route,
    required this.queryParameters,
  });

  operator [](String key) => queryParameters[key];
}
