import Foundation

struct OrderGetRequest: NetworkRequest {
    let orderId: String

    init(orderId: String = OrderAPIPath.gatewayOrderPathSegment) {
        self.orderId = orderId
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }
}
