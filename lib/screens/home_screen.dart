import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/book.dart';
import '../providers/book_providers.dart';
import '../widgets/book_card.dart';
import '../widgets/student_info_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final books = ref.watch(booksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Katalog Buku Pribadi'),
        centerTitle: false,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWideScreen = constraints.maxWidth >= 650;

          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1100),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const StudentInfoHeader(),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Daftar Koleksi Buku',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          isWideScreen
                              ? 'Layout: 2 Kolom (Layar Lebar)'
                              : 'Layout: 1 Kolom (Layar Kompak)',
                          style:
                              Theme.of(context).textTheme.labelMedium?.copyWith(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary,
                                  ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (isWideScreen)
                      _buildTwoColumnLayout(books)
                    else
                      _buildSingleColumnLayout(books),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSingleColumnLayout(List<Book> books) {
    return Column(
      children: [
        for (int i = 0; i < books.length; i++) ...[
          BookCard(book: books[i]),
          if (i < books.length - 1) const SizedBox(height: 12),
        ],
      ],
    );
  }

  Widget _buildTwoColumnLayout(List<Book> books) {
    final leftColumnBooks = <Book>[];
    final rightColumnBooks = <Book>[];

    for (int i = 0; i < books.length; i++) {
      if (i.isEven) {
        leftColumnBooks.add(books[i]);
      } else {
        rightColumnBooks.add(books[i]);
      }
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _buildSingleColumnLayout(leftColumnBooks)),
        const SizedBox(width: 16),
        Expanded(child: _buildSingleColumnLayout(rightColumnBooks)),
      ],
    );
  }
}