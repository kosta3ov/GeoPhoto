import Foundation

struct GeoImage: Equatable {
    let id: String
    let url: URL
        
    static func == (lhs: Self, rhs: Self) -> Bool {
        return lhs.id == rhs.id
    }
}

actor ImageStore {
    private(set) var images: [GeoImage] = []
    
    func clean() {
        images.removeAll()
    }
    
    func addImage(image: GeoImage) {
        if !images.contains(image) {
            images.append(image)
        }
    }
}
