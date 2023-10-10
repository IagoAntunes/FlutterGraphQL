import '../../domain/book_model.dart';

abstract class IListBooksStates {}

class InitialListBooksState extends IListBooksStates {}

class LoadingListBooksState extends IListBooksStates {}

class LoadedListBookState extends IListBooksStates {
  List<BookModel> listBooks;
  LoadedListBookState({
    required this.listBooks,
  });
}

class ErrorListBookState extends IListBooksStates {}
