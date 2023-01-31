import Foundation

protocol GeoTrackerContainerProtocol {
    var locationManager: LocationManagerProtocol { get }
    var photoService: PhotoSearchServiceProtocol { get }
}

final class GeoTrackerContainer: GeoTrackerContainerProtocol {
    
    let locationManager: LocationManagerProtocol = LocationManager()
    
    var photoService: PhotoSearchServiceProtocol {
        PhotoSearchService()
    }

}
