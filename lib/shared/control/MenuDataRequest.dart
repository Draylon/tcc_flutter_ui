class MenuDataRequest {
  static final MenuDataRequest _instance = MenuDataRequest._internal();

  factory MenuDataRequest() {
    return _instance;
  }

  MenuDataRequest._internal();

  late List<String> menuData;
  
}