import 'package:films/models/models.dart';
import 'package:films/providers/movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovieSearchDelegate extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Container();
  }

  Widget _emptyContainer() {
    return const Center(
      child: Icon(
        Icons.movie_creation_outlined,
        color: Colors.black38,
        size: 100,
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return _emptyContainer();
    }
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);
    return FutureBuilder(
      future: moviesProvider.searchMovies(query),
      builder: (_, AsyncSnapshot<List<Movie>> snapshot) {
        if (!snapshot.hasData) return _emptyContainer();
        final movies = snapshot.data!;
        return ListView.builder(
            itemBuilder: (_, int index) => _MovieItem(movie: movies[index]),
            itemCount: movies.length);
      },
    );
  }
}

class _MovieItem extends StatelessWidget {
  const _MovieItem({Key? key, required this.movie}) : super(key: key);
  final Movie movie;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FadeInImage(
        image: NetworkImage(movie.getFullPosterImg),
        placeholder: const AssetImage('assets/no-image.jpg'),
        width: 50,
        fit: BoxFit.contain,
      ),
      title: Text(movie.title),
      subtitle: Text(movie.originalTitle),
      onTap: () {
        Navigator.pushNamed(context, 'details', arguments: movie);
      },
    );
  }
}
