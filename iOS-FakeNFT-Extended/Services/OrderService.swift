import Foundation

protocol OrderService {
    func loadOrder(id: String) async throws -> OrderDTO
    func updateOrder(id: String, payload: OrderUpdatePayload) async throws -> OrderDTO
}

@MainActor
final class OrderServiceImpl: OrderService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient) {
        self.networkClient = networkClient
    }

    func loadOrder(id: String) async throws -> OrderDTO {
        let request = OrderGetRequest(orderId: id)
        let dto: OrderDTO = try await networkClient.send(request: request)
        return dto
    }

    func updateOrder(id: String, payload: OrderUpdatePayload) async throws -> OrderDTO {
        let request = OrderPutRequest(orderId: id, payload: payload)
        let dto: OrderDTO = try await networkClient.send(request: request)
        return dto
    }
}
