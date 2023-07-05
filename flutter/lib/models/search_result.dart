class SearchResult<T> extends Iterable<T> {
  int pageIndex = 0;
  int pageSize = 0;
  int totalCount = 0;
  int totalPages = 0;
  List<T> result = [];

  @override
  Iterator<T> get iterator => result.iterator;
}

/*class SearchResult<T>{
  int pageIndex = 0;
  int pageSize = 0;
  int totalCount = 0;
  int totalPages = 0;
  List<T> result = [];
}
*/
