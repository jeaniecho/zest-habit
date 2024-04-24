enum Flavor {
  prod,
  dev,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  static String get title {
    switch (appFlavor) {
      case Flavor.prod:
        return 'Zest';
      case Flavor.dev:
        return 'Zest (Dev)';
      default:
        return 'Zest';
    }
  }
}
