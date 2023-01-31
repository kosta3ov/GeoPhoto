import SwiftUI

protocol GeoTrackerViewModelProtocol: AnyObject {
    func apply(_ state: GeoTrackerDataFlow.State)
}

extension GeoTrackerView {
    
    class ViewModel: ObservableObject {
        @Published var state: GeoTrackerDataFlow.State = .success(.geoTracks([]))
    }
    
}

extension GeoTrackerView.ViewModel: GeoTrackerViewModelProtocol {
    func apply(_ state: GeoTrackerDataFlow.State) {
        DispatchQueue.main.async { [weak self] in
            self?.applyState(state)
        }
    }
    
    private func applyState(_ state: GeoTrackerDataFlow.State) {
        self.state = state
    }
}
