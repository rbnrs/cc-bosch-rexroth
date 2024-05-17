import 'package:poll_app/utils/routing_handler.dart';

extension StringExtension on String {
  RoutingData get getRoutingData {
    Uri uriData = Uri.parse(this);
    return RoutingData(
      queryParameters: uriData.queryParameters,
      route: uriData.path,
    );
  }
}
