//# shop-controller
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
const String kAPIVendorProductRestoreURL = '/vendor/product/restore/'; // {productId}

// GET
// /api/vendor/product/page/status/{status}
const String kAPIVendorProductPageStatusURL = '/vendor/product/page/status/'; // {status}