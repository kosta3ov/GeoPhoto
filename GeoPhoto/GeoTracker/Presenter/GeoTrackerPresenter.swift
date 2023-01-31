import UIKit

protocol GeoTrackerPresenterProtocol {
    func present(_ data: GeoTrackerDataFlow.Data)
}

final class GeoTrackerPresenter: GeoTrackerPresenterProtocol {
    
    weak var viewModel: GeoTrackerViewModelProtocol?
        
    func present(_ data: GeoTrackerDataFlow.Data) {
        switch data {
        case .images(let geoImages):
            let geoTrackViewModels = geoImages.reversed().map { geoImage in
                GeoTrackViewModel(
                    id: geoImage.id,
                    imageURL: geoImage.url
                )
            }
            viewModel?.apply(.success(.geoTracks(geoTrackViewModels)))
        case .notAuthorized:
            viewModel?.apply(.failure(.notAuthorized("Please allow location services in settings to start tracking")))
        }
    }

}
