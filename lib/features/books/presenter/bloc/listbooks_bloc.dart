import 'package:bloc/bloc.dart';
import 'package:fluttergraphql/features/books/domain/book_model.dart';
import 'package:fluttergraphql/features/books/presenter/bloc/listbooks_states.dart';

import '../../data/graphql_service.dart';

class ListBooksCubit extends Cubit<IListBooksStates> {
  ListBooksCubit() : super(InitialListBooksState());
  final GraphQLService _graphQLService = GraphQLService();

  Future<void> getBooks() async {
    emit(LoadingListBooksState());
    List<BookModel> listBooks = await _graphQLService.getBooks(limit: 5);
    emit(LoadedListBookState(listBooks: listBooks));
  }

  Future<void> deleteBook(String id) async {
    emit(LoadingListBooksState());
    await _graphQLService.deleteBook(id: id);
    await getBooks();
  }

  Future<void> updateBook({
    required String id,
    required String title,
    required String author,
    required String year,
  }) async {
    emit(LoadingListBooksState());
    await _graphQLService.updateBook(
      author: author,
      id: id,
      title: title,
      year: year,
    );
    await getBooks();
  }

  Future<void> createBook({
    required String title,
    required String author,
    required String year,
  }) async {
    emit(LoadingListBooksState());
    await _graphQLService.createBook(
      title: title,
      author: author,
      year: year,
    );
    await getBooks();
  }
}
