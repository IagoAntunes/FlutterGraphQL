import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttergraphql/features/books/presenter/bloc/listbooks_states.dart';

import '../../domain/book_model.dart';
import '../bloc/listbooks_bloc.dart';

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key});

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final ValueNotifier _isEditMode = ValueNotifier(false);

  void _clear() {
    _titleController.clear();
    _authorController.clear();
    _yearController.clear();
  }

  BookModel? _selectedBook;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Books GRAPHQL'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: BlocBuilder<ListBooksCubit, IListBooksStates>(
          builder: (context, state) {
            return switch (state) {
              InitialListBooksState() => Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "BEM VINDO",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 32,
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () async {
                          await context.read<ListBooksCubit>().getBooks();
                        },
                        child: const Text("COMECE"),
                      ),
                    ],
                  ),
                ),
              LoadingListBooksState() => const Center(
                  child: CircularProgressIndicator(),
                ),
              LoadedListBookState() => Column(
                  children: [
                    state.listBooks.isEmpty
                        ? const Center(
                            child: Text("Lista vazia!"),
                          )
                        : Expanded(
                            child: ListView.builder(
                              itemCount: state.listBooks.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  onTap: () {
                                    _selectedBook = state.listBooks[index];
                                    _titleController.text =
                                        state.listBooks[index].title;
                                    _authorController.text =
                                        state.listBooks[index].author;
                                    _yearController.text =
                                        state.listBooks[index].year;
                                  },
                                  trailing: IconButton(
                                    icon: const Icon(
                                      Icons.delete_outline,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      context.read<ListBooksCubit>().deleteBook(
                                          state.listBooks[index].id!);
                                    },
                                  ),
                                  leading: const Icon(Icons.book),
                                  title: Text(
                                    "${state.listBooks[index].title} by ${state.listBooks[index].author}",
                                  ),
                                  subtitle: Text(
                                      "Year: ${state.listBooks[index].year}}"),
                                );
                              },
                            ),
                          ),
                    Row(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _isEditMode,
                          builder: (context, value, child) {
                            return IconButton(
                              onPressed: () {
                                _isEditMode.value = !_isEditMode.value;
                              },
                              icon: Icon(
                                  _isEditMode.value ? Icons.edit : Icons.add),
                            );
                          },
                        ),
                        Expanded(
                          child: Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: TextFormField(
                                    controller: _titleController,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Required field';
                                      } else if (value.isEmpty) {
                                        return 'Required field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'title',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: TextFormField(
                                    controller: _authorController,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Required field';
                                      } else if (value.isEmpty) {
                                        return 'Required field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'author',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 4,
                                  ),
                                  child: TextFormField(
                                    controller: _yearController,
                                    validator: (value) {
                                      if (value == null) {
                                        return 'Required field';
                                      } else if (value.isEmpty) {
                                        return 'Required field';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      hintText: 'year',
                                      errorText: null,
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.grey,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(16),
                                        borderSide: const BorderSide(
                                          color: Colors.red,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              if (_isEditMode.value) {
                                await context.read<ListBooksCubit>().updateBook(
                                      id: _selectedBook!.id!,
                                      title: _titleController.text,
                                      author: _authorController.text,
                                      year: _yearController.text,
                                    );
                              } else {
                                await context.read<ListBooksCubit>().createBook(
                                      title: _titleController.text,
                                      author: _authorController.text,
                                      year: _yearController.text,
                                    );
                              }
                              _clear();
                            }
                          },
                          icon: const Icon(Icons.send),
                        ),
                      ],
                    ),
                  ],
                ),
              _ => Container(),
            };
          },
        ),
      ),
    );
  }
}
