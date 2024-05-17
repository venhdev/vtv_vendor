//# shop-controller
// PUT
// /api/vendor/shop/update
const String kAPIVendorShopUpdateURL = '/vendor/shop/update';

// POST
// /api/vendor/register
const String kAPIVendorRegisterURL = '/vendor/register';

// PATCH
// /api/vendor/shop/update/status/{status}
const String kAPIVendorShopUpdateStatusURL = '/vendor/shop/update/status/:status'; // {status}

// GET
// /api/vendor/shop/profile
const String kAPIVendorShopProfileURL = '/vendor/shop/profile';

//# order-shop-controller
const String kAPIVendorOrderUpdateStatusURL = '/vendor/order/update/:orderId/status/:status';
const String kAPIVendorOrderListURL = '/vendor/order/list';
const String kAPIVendorOrderListStatusURL = '/vendor/order/list/status';
const String kAPIVendorOrderDetailURL = '/vendor/order/detail'; // {orderId}

//# product-shop-controller
// POST
// /api/vendor/product/update/{productId}
const String kAPIVendorProductUpdateURL = '/vendor/product/update/:productId';

// POST
// /api/vendor/product/add
const String kAPIVendorProductAddURL = '/vendor/product/add';

// PATCH
// /api/vendor/product/update/{productId}/status/{status}
const String kAPIVendorProductUpdateStatusURL = '/vendor/product/update/:productId/status/:status';

// PATCH
// /api/vendor/product/restore/{productId}
const String kAPIVendorProductRestoreURL = '/vendor/product/restore/:productId'; // {productId}

// GET
// /api/vendor/product/page/status/{status}
const String kAPIVendorProductPageStatusURL = '/vendor/product/page/status/:status'; // {status}

//# voucher-shop-controller
const String kAPIVoucherUpdateURL = '/vendor/shop/voucher/update';
const String kAPIVoucherAddURL = '/vendor/shop/voucher/add';
const String kAPIVoucherUpdateStatusURL = '/vendor/shop/voucher/update-status/:voucherId'; // {voucherId}
const String kAPIVoucherGetAllURL = '/vendor/shop/voucher/get-all-shop';
const String kAPIVoucherGetAllByTypeURL = '/vendor/shop/voucher/get-all-shop-type';
const String kAPIVoucherGetAllByStatusURL = '/vendor/shop/voucher/get-all-shop-status';
const String kAPIVoucherDetailURL = '/vendor/shop/voucher/detail/:voucherId'; // {voucherId}

//! same API with customer
//# wallet-controller
// GET
// /api/customer/wallet/get
const String kAPIWalletGetURL = '/customer/wallet/get'; //this use for both vendor and customer

//# notification-controller
const String kAPINotificationGetPageURL = '/customer/notification/get-page'; // GET
const String kAPINotificationReadURL = '/customer/notification/read'; // PUT /{notificationId}
const String kAPINotificationDeleteURL = '/customer/notification/delete'; // DELETE /{notificationId}