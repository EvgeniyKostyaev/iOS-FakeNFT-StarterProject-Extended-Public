import UIKit

@MainActor
public final class NftDetailAssembly {

    private let servicesAssembler: ServicesAssembly

    init(servicesAssembler: ServicesAssembly) {
        self.servicesAssembler = servicesAssembler
    }

    func build(with input: NftDetailInput) -> NftDetailViewController {
        let presenter = NftDetailPresenterImpl(
            input: input,
            service: servicesAssembler.nftService
        )
        let viewController = NftDetailViewController(presenter: presenter)
        presenter.view = viewController
        return viewController
    }
}
