import Foundation
import CoreLocation
import UIKit

protocol PhotoSearchServiceProtocol {
    
    func findPhoto(by location: CLLocation) async throws -> GeoImage?
    
}

final class PhotoSearchService: PhotoSearchServiceProtocol {
    
    private let urlSession = URLSession(configuration: URLSessionConfiguration.default)
    private let decoder = JSONDecoder()
    
    func findPhoto(by location: CLLocation) async throws -> GeoImage? {
        guard let url = FlickrAPI.buildURL(
            lat: location.coordinate.latitude,
            lon: location.coordinate.longitude
        ) else {
            return nil
        }
        
        let (data, _) = try await urlSession.data(from: url)
        let result = try decoder.decode(PhotoSearchResult.self, from: data)
        return GeoImage(id: result.id, url: result.url)
    }
    
}
