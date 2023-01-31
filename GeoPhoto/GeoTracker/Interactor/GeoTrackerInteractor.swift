import Foundation
import CoreLocation
import UIKit
import Combine

protocol GeoTrackerInteractorProtocol {
    func execute(_ event: GeoTrackerDataFlow.Event)
}

final class GeoTrackerInteractor: GeoTrackerInteractorProtocol {
    
    private let presenter: GeoTrackerPresenterProtocol
    private let locationManager: LocationManagerProtocol
    private let photoSearchService: PhotoSearchServiceProtocol
    private let imageStore = ImageStore()
    
    private var disposeBag = Set<AnyCancellable>()
    
    init(presenter: GeoTrackerPresenterProtocol,
         locationManager: LocationManagerProtocol,
         photoSearchService: PhotoSearchServiceProtocol) {
        self.presenter = presenter
        self.locationManager = locationManager
        self.photoSearchService = photoSearchService
        setupSubscriptions()
    }
    
    func execute(_ event: GeoTrackerDataFlow.Event) {
        switch event {
        case .startTracking:
            locationManager.startUpdatingLocation()
        case .stopTracking:
            locationManager.stopUpdatingLocation()
            Task {
                await imageStore.clean()
                await MainActor.run {
                    presenter.present(.images([]))
                }
            }
        }
    }
    
    private func setupSubscriptions() {
        locationManager.locationSubject.sink { location in
            Task { [weak self] in
                if let geoImage = try? await self?.photoSearchService.findPhoto(by: location) {
                    await self?.imageStore.addImage(image: geoImage)
                    let images = await self?.imageStore.images ?? []
                    
                    await MainActor.run { [weak self] in
                        self?.presenter.present(.images(images))
                    }
                }
            }
        }.store(in: &disposeBag)
        
        locationManager.notAuthorizedSubject.sink { [weak self] in
            self?.presenter.present(.notAuthorized)
        }.store(in: &disposeBag)
    }
}
