import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLConfig {
  static HttpLink httplink =
      HttpLink('https://books-demo-apollo-server.herokuapp.com/');

  GraphQLClient clientToQuery() =>
      GraphQLClient(link: httplink, cache: GraphQLCache());
}
