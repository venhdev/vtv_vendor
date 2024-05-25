import 'package:vtv_common/core.dart';
import 'package:vtv_common/order.dart';

import '../../data/datasources/voucher_data_source.dart';

abstract class VoucherRepository {
  //# voucher-shop-controller
  // const String kAPIVoucherUpdateURL = '/vendor/shop/voucher/update';
  FRespData<VoucherEntity> updateVoucher(VoucherEntity voucher);
  // const String kAPIVoucherAddURL = '/vendor/shop/voucher/add';
  FRespData<VoucherEntity> addVoucher(VoucherEntity voucher);
  // const String kAPIVoucherUpdateStatusURL = '/vendor/shop/voucher/update-status/:voucherId'; // {voucherId}
  FRespData<VoucherEntity> updateVoucherStatus(String voucherId, Status status);
  // const String kAPIVoucherGetAllURL = '/vendor/shop/voucher/get-all-shop';
  FRespData<List<VoucherEntity>> getAllVoucher();
  // const String kAPIVoucherGetAllByTypeURL = '/vendor/shop/voucher/get-all-shop-type';
  FRespData<List<VoucherEntity>> getAllVoucherByType(VoucherTypes type);
  // const String kAPIVoucherGetAllByStatusURL = '/vendor/shop/voucher/get-all-shop-status';
  FRespData<List<VoucherEntity>> getAllVoucherByStatus(Status status);
  // const String kAPIVoucherDetailURL = '/vendor/shop/voucher/detail/:voucherId'; // {voucherId}
  FRespData<VoucherEntity> getVoucherDetail(int voucherId);
}

class VoucherRepositoryImpl implements VoucherRepository {
  VoucherRepositoryImpl(this._voucherDataSource);

  final VoucherDataSource _voucherDataSource;

  @override
  FRespData<VoucherEntity> addVoucher(VoucherEntity voucher) async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.addVoucher(voucher));
  }

  @override
  FRespData<List<VoucherEntity>> getAllVoucher() async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.getAllVoucher());
  }

  @override
  FRespData<List<VoucherEntity>> getAllVoucherByStatus(Status status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.getAllVoucherByStatus(status));
  }

  @override
  FRespData<List<VoucherEntity>> getAllVoucherByType(VoucherTypes type) async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.getAllVoucherByType(type));
  }

  @override
  FRespData<VoucherEntity> getVoucherDetail(int voucherId) async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.getVoucherDetail(voucherId));
  }

  @override
  FRespData<VoucherEntity> updateVoucher(VoucherEntity voucher) async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.updateVoucher(voucher));
  }

  @override
  FRespData<VoucherEntity> updateVoucherStatus(String voucherId, Status status) async {
    return handleDataResponseFromDataSource(dataCallback: () => _voucherDataSource.updateVoucherStatus(voucherId, status));
  }
}
