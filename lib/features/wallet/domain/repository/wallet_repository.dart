import 'package:vtv_common/core.dart';
import 'package:vtv_common/wallet.dart';

abstract class VendorRepository {
  FRespData<WalletEntity> getWallet();
}
