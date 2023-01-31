import Foundation

struct PhotoSearchResult: Decodable {
    
    enum CodingKeys: CodingKey {
        case photos
    }
    
    enum PhotosCodingKeys: CodingKey {
        case photo
    }
    
    struct Photo: Decodable {
        enum PhotoCodingKeys: String, CodingKey {
            case id
            case urlL = "url_l"
            case urlC = "url_c"
            case urlZ = "url_z"
            case urlN = "url_n"
            case urlM = "url_m"
        }
        
        let id: String
        let url: URL
        
        init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: PhotoCodingKeys.self)
            self.id = try container.decode(String.self, forKey: .id)
            
            let urlL = try container.decodeIfPresent(URL.self, forKey: .urlL)
            let urlC = try container.decodeIfPresent(URL.self, forKey: .urlC)
            let urlZ = try container.decodeIfPresent(URL.self, forKey: .urlZ)
            let urlN = try container.decodeIfPresent(URL.self, forKey: .urlN)
            let urlM = try container.decodeIfPresent(URL.self, forKey: .urlM)
            
            guard let url = [urlL, urlC, urlZ, urlN, urlM].lazy.compactMap({ $0 }).first else {
                throw DecodingError.valueNotFound(
                    URL.self,
                    .init(codingPath: [
                        PhotoCodingKeys.urlL,
                        PhotoCodingKeys.urlC,
                        PhotoCodingKeys.urlZ,
                        PhotoCodingKeys.urlN,
                        PhotoCodingKeys.urlM
                    ], debugDescription: "No valid url")
                )
            }
            
            self.url = url
        }
    }
    
    let id: String
    let url: URL
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let photosContainer = try container.nestedContainer(keyedBy: PhotosCodingKeys.self, forKey: .photos)
        let photos = try photosContainer.decode([Photo].self, forKey: .photo)
        guard let firstPhoto = photos.first else {
            throw DecodingError.valueNotFound([Photo].self, .init(codingPath: [PhotosCodingKeys.photo], debugDescription: "No photos"))
        }
        self.id = firstPhoto.id
        self.url = firstPhoto.url
    }
}

struct FlickrAPI {
    
    static func buildURL(lat: Double, lon: Double) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.flickr.com"
        components.path = "/services/rest"
        components.queryItems = [
            URLQueryItem(name: "method", value: "flickr.photos.search"),
            URLQueryItem(name: "api_key", value: "458fe560d5adf640ca2fa4b292c3c570"),
            URLQueryItem(name: "sort", value: "relevance"),
            URLQueryItem(name: "privacy_filter", value: "1"),
            URLQueryItem(name: "accuracy", value: "16"),
            URLQueryItem(name: "geo_context", value: "2"),
            URLQueryItem(name: "lat", value: String(lat)),
            URLQueryItem(name: "lon", value: String(lon)),
            URLQueryItem(name: "radius", value: "0.5"),
            URLQueryItem(name: "radius_units", value: "km"),
            URLQueryItem(name: "extras", value: "url_l, url_c, url_z, url_n, url_m"),
            URLQueryItem(name: "per_page", value: "1"),
            URLQueryItem(name: "format", value: "json"),
            URLQueryItem(name: "nojsoncallback", value: "1")
        ]

        return components.url
    }
}
