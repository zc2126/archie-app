//
//  ContentView.swift
//  Archie
//
//  Created by Will Rojas on 10/24/22.
//

import SwiftUI
import CoreLocation
import Foundation

var options = ["McDonalds","Wendys","fresh&co","Chipotle","Dig","Shake Shack","Pelicana Chicken"]
var term = ""
var out = ""
var m = DeviceLocationService()
let apikey = "80aSnHnyHk_OeP8nV1soG9yi6vkMnprpZLNQ75M-wpAKqYgiwgpEXmSToC7MV7d9Wo_PD8pbYMHQ_tLR5lG0qejq8MTZwenFxGWQso6gaHOg3d4xE4gZaKJaCTZXY3Yx"
//var domainURLString = ""
let domainURLString = "https://api.yelp.com/v3/businesses/search?location=Greenwich_Village&categories=restaurants&open_now=true"

var restaurants = [Restaurant]()

struct Restaurant: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    var name: String
    //let _ = print(domainURLString)
    //let url = URL(string: domainURLString)
    fileprivate func getRest() -> Void{
        print("url:")
        print(domainURLString)
        let url = URL(string: domainURLString)
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let _ = print("DataTask error: " + error.localizedDescription + "\n")
            }
            print("pls")
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]

                let _ = print(">>>>", json, #line,"<<<<")
                
                if let names = json["businesses"] as? [NSDictionary] {
                    let _ = print("interlude")
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


let defaultSession = URLSession(configuration: .default)
var dataTask: URLSessionDataTask?


let r = Restaurant(name: "")
/*
var loc = m.retLoc()
let lo = loc.location
let lon = lo?.coordinate.longitude
let lat = lo?.coordinate.latitude
 */

struct ContentView: View {
    @State private var t = ""
    @State private var go = false
    let m = r.getRest()
    var body: some View {
        /*
        let _ = print("here")
        let _ = print(lon)
        let _ = print(lat)
         */
        VStack(alignment: .leading) {
            Text("Let Archie Decide")
                .padding().frame(width: 200, height: 100, alignment: .top)
            
            TextField("Any criteria?", text: $t)
                //.frame(width: geometry.size.height/2, height: geometry.size.height/3, alignment: .center)
             
                Button("Go") {
                    go.toggle()
                    //out = restaurants.randomElement()!.name

                    //out = options.randomElement()!
                    
                    term = t
                    print(term)
                    /*
                    domainURLString = "https://api.yelp.com/v3/businesses/search?location=Greenwich_Village&categories=restaurants&open_now=true&term=\(term)"
                    print(domainURLString)
                     */
                    
                    //let r = Restaurant(name: "")
                    //`r.getRest()
                     
                   out = restaurants.randomElement()!.name
                }.frame(width: 200, height: 100, alignment: .center)
                if go {
                    Text(out).frame(width: 200, height: 100, alignment: .bottom)
                }
        }.frame(width: 400, height: 600, alignment: .center)
    }
}

    

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
