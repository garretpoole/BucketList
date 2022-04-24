//
//  ContentView-ViewModel.swift
//  BucketList
//
//  Created by Garret Poole on 4/22/22.
//

import Foundation
import LocalAuthentication
import MapKit

//MVVM (model view view-model) design pattern implemented
//separate logic form layout; makes testing easier
extension ContentView {
    //mainactor responsible for running all Ui updates
    //every part of the class should be run on mainactor; use for every class confroms to ObservableObj
    @MainActor class ViewModel: ObservableObject {
        @Published var mapRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 50, longitude: 0), span: MKCoordinateSpan(latitudeDelta: 25, longitudeDelta: 25))
        @Published private(set) var locations: [Location]
        //for editing an already marked location
        @Published var selectedPlace: Location?
        //check for if phone is unlocked
        @Published var isUnlocked = false
        //alert for biometric auth
        @Published var showingNoBioAlert = false
        
        //used for reading and writing files with the same file in both places
        //data is saved on disc (takes up phone storage) and much more flexible than UserDefaults
        let savePath = FileManager.documentsDirectory.appendingPathComponent("SavedPlaces")
        
        //loads data from disc
        init() {
            do {
                let data = try Data(contentsOf: savePath)
                locations = try JSONDecoder().decode([Location].self, from: data)
            } catch {
                locations = []
            }
        }
        
        //file can only be read when device is requested to be unlocked
        func save() {
            do {
                let data = try JSONEncoder().encode(locations)
                //.completeFileProtection ensures files are stored with strong encryption
                try data.write(to: savePath, options: [.atomicWrite, .completeFileProtection])
            } catch {
                print("Unable to save data.")
            }
        }
        
        func addLocation () {
            let newLocation = Location(id: UUID(), name: "New Location", description: "", latitude: mapRegion.center.latitude, longitude: mapRegion.center.longitude)
            locations.append(newLocation)
            save()
        }
        
        func update(location: Location) {
            guard let selectedPlace = selectedPlace else { return }

            if let index = locations.firstIndex(of: selectedPlace) {
                locations[index] = location
                save()
            }
        }
        
        func authenticate() {
            let context = LAContext()
            var error: NSError?
            
            if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
                //used for touchID
                let reason = "Please authenticate yourself to view your places"
                
                context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                    if success {
                        //start new task to run in main actor to queue up work to make isUnlocked true
                        Task { @MainActor in
                            self.isUnlocked = true
                        }
                    }
                    else {
                        //error for face not recognized
                        //auto handled by the faceID api
                    }
                }
            } else {
                //biometric authentication not available
                self.showingNoBioAlert = true
            }
        }
        
    }
}
