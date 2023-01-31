import SwiftUI

@main
struct GeoPhotoApp: App {
    
    private let container = GeoTrackerContainer()
    
    var body: some Scene {
        WindowGroup {
            GeoTrackerBuilder(container: container).build()
        }
    }
}
