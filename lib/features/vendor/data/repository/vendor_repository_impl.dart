import 'package:vtv_common/core.dart';
import 'package:vtv_common/wallet.dart';

import '../../domain/repository/vendor_repository.dart';
import '../data_sources/vendor_data_source.dart';

class VendorRepositoryImpl implements VendorRepository {
  VendorRepositoryImpl(this._dataSource);
  final VendorDataSource _dataSource;
  @override
  FRespData<WalletEntity> getWallet() async {
    return handleDataResponseFromDataSource(dataCallback: () => _dataSource.getWallet());
  }
}
