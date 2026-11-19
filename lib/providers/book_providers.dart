import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../models/book.dart';

/// Provider untuk menyimpan nama mahasiswa
final nameProvider = Provider<String>((ref) {
  return 'Chikal Rizky Sekarwangi';
});

/// Provider untuk menyimpan NPM mahasiswa
final npmProvider = Provider<String>((ref) {
  return '085024013';
});

/// Provider daftar buku (minimal 3 buku, minimal 1 tanpa deskripsi)
final booksProvider = Provider<List<Book>>((ref) {
  return const [
    Book(
      id: '1',
      title: 'Clean Code: A Handbook of Agile Software Craftsmanship',
      author: 'Robert C. Martin',
      year: 2008,
      description:
          'Panduan praktis menulis kode yang bersih, mudah dibaca, terstruktur, dan mudah dipelihara dalam pengembangan perangkat lunak.',
      assetPath: 'assets/images/clean_code.png',
      imageUrl: 'https://covers.openlibrary.org/b/id/5547794-L.jpg',
    ),
    Book(
      id: '2',
      title: 'Filosofi Teras',
      author: 'Henry Manampiring',
      year: 2018,
      description:
          'Pengantar filsafat Stoisisme Yunani-Romawi kuno yang relevan untuk mengelola emosi negatif di kehidupan modern.',
      assetPath: 'assets/images/filosofi_teras.jpg',
      imageUrl: 'https://cdn.gramedia.com/uploads/items/filosofi_teras_hc.png',
    ),
    Book(
      id: '3',
      title: 'Flutter Apprentice',
      author: 'Mike Katz, Kevin David Moore, Vincent Ngo',
      year: 2023,
      description: null, // Buku tanpa deskripsi untuk menguji null safety
      assetPath: 'assets/images/flutter_apprentice.png',
      imageUrl:
          'https://assets.alexandria.raywenderlich.com/books/flta/images/ed7ebaed484421fec41577da27dd368defb47a2831221adee5c1b13500bb56d1/original.png',
    ),
    Book(
      id: '4',
      title: 'Atomic Habits',
      author: 'James Clear',
      year: 2018,
      description:
          'Strategi membangun kebiasaan baik dan menghilangkan kebiasaan buruk melalui perubahan kecil yang konsisten.',
      assetPath: 'assets/images/atomic_habits.jpg',
      imageUrl: 'https://covers.openlibrary.org/b/id/12843460-L.jpg',
    ),
  ];
});

/// Provider informasi ringkas yang menggabungkan nama, NPM, dan jumlah buku
final infoProvider = Provider<String>((ref) {
  final nama = ref.watch(nameProvider);
  final npm = ref.watch(npmProvider);
  final totalBuku = ref.watch(booksProvider).length;

  return '$nama ($npm) • Total Koleksi: $totalBuku Buku';
});

/// StateProvider untuk menyimpan ID buku yang deskripsinya disembunyikan
final hiddenDescriptionIdsProvider = StateProvider<Set<String>>((ref) {
  return <String>{};
});