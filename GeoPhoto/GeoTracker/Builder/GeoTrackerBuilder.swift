import SwiftUI

final class GeoTrackerBuilder {
    
    private let container: GeoTrackerContainerProtocol
    
    init(container: GeoTrackerContainerProtocol) {
        self.container = container
    }
    
    func build() -> some View {
        let locationManager = container.locationManager
        
        let presenter = GeoTrackerPresenter()
        let interactor = GeoTrackerInteractor(
            presenter: presenter,
            locationManager: locationManager,
            photoSearchService: container.photoService
        )
        
        let viewModel = GeoTrackerView.ViewModel()
        let trackerView = GeoTrackerView(
            viewModel: viewModel,
            interactor: interactor
        )
        presenter.viewModel = viewModel
        
        return trackerView
    }
}
