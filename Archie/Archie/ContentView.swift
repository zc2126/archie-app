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
var out = ""
//var m = DeviceLocationService()
let apikey = "80aSnHnyHk_OeP8nV1soG9yi6vkMnprpZLNQ75M-wpAKqYgiwgpEXmSToC7MV7d9Wo_PD8pbYMHQ_tLR5lG0qejq8MTZwenFxGWQso6gaHOg3d4xE4gZaKJaCTZXY3Yx"
let domainURLString = "https://api.yelp.com/v3/businesses/search?location=Greenwich_Village&categories=restaurants&open_now=true"

var restaurants = [Restaurant]()

struct Restaurant: Decodable {
    enum Category: String, Decodable {
        case swift, combine, debugging, xcode
    }
    var name: String
    let url = URL(string: domainURLString)
    fileprivate func getRest() -> Void{
        var request = URLRequest(url: url!)
        request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"

        URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let error = error {
                let _ = print("DataTask error: " + error.localizedDescription + "\n")
            }
            /*
            else if
                let data = data,
                let response = response as? HTTPURLResponse,
                response.statusCode == 200 {
                let _ = print(response)
                let _ = print("it worked")
             */
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: []) as! [String: Any]
                //[String: Any]
                let _ = print(">>>>", json, #line,"<<<<")
                
                if let names = json["businesses"] as? [NSDictionary] {
                    let _ = print("interlude")
                    for r in names {
                        let ro = Restaurant(name: r["name"] as! String)
                            restaurants.append(ro)
                    }
                    //let _ = print(names[0]["name"] as Any)
                    //let _ = print("indeed")
                    //let _ = print(restaurants)
                }
                
                //let jsonData = json.data(using: .utf8)!
                //let jsonString = String(data: json, encoding: .utf8)
                /*
                if let rest: [Restaurant] = try! JSONDecoder().decode([Restaurant].self, from: json)
                 */
                 
            } catch {
                let _ = print("caught")
            }
        }.resume()
        
        /*
        func setView() {
            self.view.window?.setFrame(NSRect(x:0,y:0,width:200,height:600),display:true)
        }
         */
    }
}
/*
struct Restaurants: Codable {
    let names: [Restaurant]
}
*/
/*
extension ViewController {
    func retrieveRestaurants(name: String, completionHandler: @escaping ([Restaurant]?, Error?) -> Void) {}
}
*/

let defaultSession = URLSession(configuration: .default)
var dataTask: URLSessionDataTask?


/*
func getRest() {
    var request = URLRequest(url: url!)
    request.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
    request.httpMethod = "GET"
    dataTask = defaultSession.dataTask(with: url!) { data, response, error in
        if let error = error {
            print("DataTask error: " + error.localizedDescription + "\n")
        }
        else if
            let data = data,
            let response = response as? HTTPURLResponse,
            response.statusCode == 200 {
            print(response)
            print("it worked")
        }
    }
    /*
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if let error = error {
            completionHandler(nil, error)
        }
        do {
            let json = try JSONSerialization.jsonObject(with: data!, options = [])
            
            guard let resp = json as? NSDictionary else { return }
            
            guard let restaurants = resp.value(forKey: "restaurants") as? [NSDictionary] else {return}
            
            var restaurantList: [Restaurant] = []
            
            completionHandler(venuesList, nil)
        } catch {
            print("Caught error")
        }
    }.resume()
*/
}
*/
let r = Restaurant(name: "")


struct ContentView: View {
    //var loc = m.retLoc()
    let m = r.getRest()
    @State private var go = false
    var body: some View {
        VStack(alignment: .leading) {
            Text("Let Archie Decide")
                .padding().frame(width: 200, height: 100, alignment: .top)
                //.frame(width: geometry.size.height/2, height: geometry.size.height/3, alignment: .center)
                Button("Go") {
                    go.toggle()
                    //out = options.randomElement()!
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
