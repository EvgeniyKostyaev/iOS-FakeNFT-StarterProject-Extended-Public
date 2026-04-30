import Foundation

struct OrderPutRequest: NetworkRequest {
    let orderId: String
    let payload: OrderUpdatePayload

    init(
        orderId: String = OrderAPIPath.gatewayOrderPathSegment,
        payload: OrderUpdatePayload
    ) {
        self.orderId = orderId
        self.payload = payload
    }

    var endpoint: URL? {
        URL(string: "\(RequestConstants.baseURL)/api/v1/orders/\(orderId)")
    }

    var httpMethod: HttpMethod { .put }

    var urlEncodedFormFields: [URLEncodedFormField] {
        [
            URLEncodedFormField(
                name: "nfts",
                value: Self.formEncodedIdList(payload.nfts)
            )
        ]
    }

    private static func formEncodedIdList(_ ids: [String]) -> String {
        ids.isEmpty ? "null" : ids.joined(separator: ",")
    }
}
