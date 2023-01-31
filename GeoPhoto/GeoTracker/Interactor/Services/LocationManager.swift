import CoreLocation
import Combine

protocol LocationManagerProtocol {
    
    var locationSubject: AnyPublisher<CLLocation, Never> { get }
    var notAuthorizedSubject: AnyPublisher<Void, Never> { get }
    
    func startUpdatingLocation()
    func stopUpdatingLocation()
}

final class LocationManager: NSObject, LocationManagerProtocol {
    
    var locationSubject: AnyPublisher<CLLocation, Never> {
        locationPassthroughSubject.eraseToAnyPublisher()
    }
    
    var notAuthorizedSubject: AnyPublisher<Void, Never> {
        notAuthorizedPassthroughSubject.eraseToAnyPublisher()
    }
    
    private let locationPassthroughSubject = PassthroughSubject<CLLocation, Never>()
    private let notAuthorizedPassthroughSubject = PassthroughSubject<Void, Never>()
    
    private let locationManager = CLLocationManager()
    private var currentLocationCoordinate: CLLocationCoordinate2D?
    
    override init() {
        super.init()
        
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = true
        locationManager.activityType = .fitness
        locationManager.delegate = self
        locationManager.distanceFilter = 100
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
    }

    func startUpdatingLocation() {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestAlwaysAuthorization()
        } else if locationManager.authorizationStatus != .authorizedAlways && locationManager.authorizationStatus != .authorizedWhenInUse {
            notAuthorizedPassthroughSubject.send()
        }
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
}

extension LocationManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let firstLocation = locations.first,
           currentLocationCoordinate != firstLocation.coordinate {
            currentLocationCoordinate = firstLocation.coordinate
            locationPassthroughSubject.send(firstLocation)
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if locationManager.authorizationStatus != .authorizedAlways && locationManager.authorizationStatus != .authorizedWhenInUse {
            notAuthorizedPassthroughSubject.send()
        }
    }
}

extension CLLocationCoordinate2D: Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        return lhs.longitude == rhs.longitude && lhs.latitude == rhs.latitude
    }
}
