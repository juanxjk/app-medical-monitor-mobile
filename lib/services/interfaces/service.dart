abstract class Service<T> {
  Future<List<T>> findAll({int page = 1, int size = 10});
  Future<T> findByID(String id);
  Future<void> save(T data);
  Future<void> update(T data);
  Future<void> remove(String id);
}
