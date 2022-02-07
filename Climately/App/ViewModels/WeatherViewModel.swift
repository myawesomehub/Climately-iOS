//
//  WeatherViewModel.swift
//  Climately
//
//  Created by Mohammad Yasir on 05/02/22.
//

import SwiftUI
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var weather: APIResponse = .init()
    @Published var locationObj: LocationManager = .init()
    
    @Published var searchedCoordinates: CLLocationCoordinate2D = .init()
    @Published var searchedAddress: String = .init()
    @Published var serachedText: String = "Bengaluru"
    {
        didSet {
            doThis()
        }
    }
    
    init() {
        doThis()
    }
    
    func doThis() {
        locationObj.getCoordinate(addressString: serachedText) { coordinates, error in
            self.searchedCoordinates = coordinates
        }
        
        locationObj.getAddress(coordinates: searchedCoordinates) { address, error in
            if let address = address?.locality {
                self.searchedAddress = address
            }
        }
    }
    
    public func makeAPICall() -> Void {
        
        locationObj.getCoordinate(addressString: serachedText) { coordinates, error in
            self.searchedCoordinates = coordinates
        }
        
        ServiceManager.getCurrentWeatherData(
            key: "da6abe8ec13dffbea262e927ed379fb7",
            lat: searchedCoordinates.latitude,
            lon: searchedCoordinates.longitude
        ) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.weather = data
                }
            case .failure(let error):
                print("HERE IS THE ISSUEE", error.localizedDescription)
            }
        }
    }
}