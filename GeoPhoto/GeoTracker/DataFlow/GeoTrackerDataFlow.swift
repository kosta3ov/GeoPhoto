import CoreLocation
import UIKit

enum GeoTrackerDataFlow {
    
    enum Event {
        case startTracking
        case stopTracking
    }
        
    enum Data {
        case images([GeoImage])
        case notAuthorized
    }
    
    typealias State = Result<Success, Errors>
   
    enum Success {
        case geoTracks([GeoTrackViewModel])
    }
   
    enum Errors: Error {
        case notAuthorized(String)
    }
    
}
