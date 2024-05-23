import 'package:flutter/material.dart';
import 'package:vendor/features/wallet/domain/repository/wallet_repository.dart';
import 'package:vtv_common/wallet.dart';

import '../../../../../service_locator.dart';

class VendorWalletHistoryPage extends StatelessWidget {
  const VendorWalletHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return TransactionHistory(
      dataCallback: sl<VendorRepository>().getWallet(),
    );
  }
}
