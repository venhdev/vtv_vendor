import 'package:flutter_test/flutter_test.dart';
import 'package:vtv_common/core.dart';

void main() {
  test('Vendor', () {
    final OrderStatus x = OrderStatus.PENDING;

    print('url/${x.name}');
  });
}