class GetStorage {
  static final Map<String, dynamic> _storage = {};

  T? read<T>(String key) {
    return _storage[key] as T?;
  }

  void write(String key, dynamic value) {
    _storage[key] = value;
  }

  void remove(String key) {
    _storage.remove(key);
  }

  void clear() {
    _storage.clear();
  }
}