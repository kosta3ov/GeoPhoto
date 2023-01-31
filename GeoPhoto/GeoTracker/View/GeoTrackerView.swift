import SwiftUI

struct GeoTrackViewModel: Identifiable {
    let id: String
    let imageURL: URL
}

struct GeoTrackerView: View {
    
    @ObservedObject private var viewModel: ViewModel
    private let interactor: GeoTrackerInteractorProtocol
    
    @State private var navigationBarTrailingButtonTitle: String = "Start"
    @State private var isStarted = false
    
    @ViewBuilder
    private var stateView: some View {
        switch viewModel.state {
        case .success(.geoTracks(let geoTracks)):
            List(geoTracks) { geoTrack in
                AsyncImage(url: geoTrack.imageURL) { (image: Image) in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: UIScreen.main.bounds.width)
                } placeholder: {
                    ProgressView()
                }.listRowSeparator(.hidden)
            }
            
        case .failure(.notAuthorized(let text)):
            Text(text)
        }
    }
    
    init(viewModel: ViewModel, interactor: GeoTrackerInteractorProtocol) {
        self.viewModel = viewModel
        self.interactor = interactor
    }
    
    var body: some View {
        NavigationStack {
            stateView.toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(navigationBarTrailingButtonTitle) {
                        if self.isStarted {
                            self.navigationBarTrailingButtonTitle = "Start"
                            self.interactor.execute(.stopTracking)
                        } else {
                            self.navigationBarTrailingButtonTitle = "Stop"
                            self.interactor.execute(.startTracking)
                        }
                        self.isStarted.toggle()
                    }
                }
            }
        }
    }
}
