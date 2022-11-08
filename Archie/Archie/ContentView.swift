//
//  ContentView.swift
//  Archie
//
//  Created by Will Rojas on 10/24/22.
//

import SwiftUI
import CoreLocation
import Foundation
import Combine

var options = ["McDonalds","Wendys","fresh&co","Chipotle","Dig","Shake Shack","Pelicana Chicken"]
var out = ""
var m = DeviceLocationService()

struct Restaurant: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    var name: String
}

var restaurants = [Restaurant]()

struct YelpAPI {
    let apikey = "80aSnHnyHk_OeP8nV1soG9yi6vkMnprpZLNQ75M-wpAKqYgiwgpEXmSToC7MV7d9Wo_PD8pbYMHQ_tLR5lG0qejq8MTZwenFxGWQso6gaHOg3d4xE4gZaKJaCTZXY3Yx"
    var domainURLString = "https://api.yelp.com/v3/businesses/search?location=Greenwich_Village&categories=restaurants&open_now=true"
    let defaultSession = URLSession(configuration: .default)
    var dataTask: URLSessionDataTask?
    
    mutating func setTerm(t: String) -> Void {
        if t != "" {
            let underscored_str = t.replacingOccurrences(of: " ", with: "_")
            domainURLString = "https://api.yelp.com/v3/businesses/search?location=Greenwich_Village&categories=restaurants&open_now=true&term=\(underscored_str)"
        } else {
            domainURLString = "https://api.yelp.com/v3/businesses/search?location=Greenwich_Village&categories=restaurants&open_now=true"
        }
        self.getRest() // get new set of restaurants based on term
    }
    
    fileprivate func getRest() -> Void {
        let url = URL(string: domainURLString)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let _ = print("DataTask error: " + error.localizedDescription + "\n")
            }
            restaurants.removeAll() // clear restaurants from previous query
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]

                let _ = print(">>>>", json, #line,"<<<<")

                if let names = json["businesses"] as? [NSDictionary] {
                    for r in names {
                        let ro = Restaurant(name: r["name"] as! String)
                            restaurants.append(ro)
                    }
                }
            } catch {
                let _ = print("caught")
            }
        }.resume()
    }
}

var api = YelpAPI()

/*
var loc = m.retLoc()
let lo = loc.location
let lon = lo?.coordinate.longitude
let lat = lo?.coordinate.latitude
 */

struct ContentView: View {
    @StateObject var deviceLocationService = DeviceLocationService.shared

    @State var tokens: Set<AnyCancellable> = []
    @State var coordinates: (lat: Double, lon: Double) = (0, 0)
    
    @State private var t = ""
    @State private var go = false
    let m = api.getRest()
    var body: some View {
        /*
        let _ = print("here")
        let _ = print(lon)
        let _ = print(lat)
         */
        ZStack(alignment: .top) {
            Text("Let Archie Decide")
                .padding().frame(width: 200, height: 100, alignment: .top)
        }
        ZStack(alignment: .center) {
            TextField("Any criteria?", text: $t)
                //.frame(width: geometry.size.height/2, height: geometry.size.height/3, alignment: .center)
        }
        ZStack(alignment: .center) {
                Button("Go") {
                    go.toggle()
                    api.setTerm(t: t);
                    if restaurants.count == 0 {
                        out = "No results"
                    } else {
                        out = restaurants.randomElement()!.name
                    }
                }.frame(width: 200, height: 100, alignment: .center)
        }
        ZStack(alignment: .bottom) {
                if go {
                    Text(out).frame(width: 200, height: 300, alignment: .topLeading)
                    Text("Latitude: \(coordinates.lat)")
                        .font(.largeTitle).frame(width: 200, height: 200, alignment: .topLeading)
                    Text("Longitude: \(coordinates.lon)")
                        .font(.largeTitle).frame(width: 200, height: 100, alignment: .topLeading)
                }
                }.onAppear {
                    observeCoordinateUpdates()
                    observeDeniedLocationAccess()
                    deviceLocationService.requestLocationUpdates()
                
        }.frame(width: 400, height: 400, alignment: .center)
    }
    
    func observeCoordinateUpdates() {
        deviceLocationService.coordinatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { completion in
                print("Handle \(completion) for error and finished subscription.")
            } receiveValue: { coordinates in
                self.coordinates = (coordinates.latitude, coordinates.longitude)
            }
            .store(in: &tokens)
    }

    func observeDeniedLocationAccess() {
        deviceLocationService.deniedLocationAccessPublisher
            .receive(on: DispatchQueue.main)
            .sink {
                print("Handle access denied event, possibly with an alert.")
            }
            .store(in: &tokens)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


