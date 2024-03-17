import 'package:habit_app/utils/disposable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:rxdart/rxdart.dart';

class SubscriptionBloc extends Disposable {
  final BehaviorSubject<int> _selectedIndex = BehaviorSubject.seeded(1);
  Stream<int> get selectedIndex => _selectedIndex.stream;
  Function(int) get setSelectedIndex => _selectedIndex.add;

  final BehaviorSubject<ProductDetails> _selectedProduct = BehaviorSubject();
  Stream<ProductDetails> get selectedProduct => _selectedProduct.stream;
  Function(ProductDetails) get setSelectedProduct => _selectedProduct.add;

  SubscriptionBloc();

  @override
  void dispose() {
    _selectedIndex.close();
    _selectedProduct.close();
  }
}
