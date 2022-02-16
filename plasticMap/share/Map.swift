//
//  Map.swift
//  map
//
//  Created by iOS Club on 2021/7/10.
//

import SwiftUI
import MapKit
import CoreLocation
import FirebaseFirestore

struct Map: View{
    
    var body: some View{
        
        NavigationView{
            
            ZStack{
                themap()
            }
            .navigationBarHidden(true)
        }
        .navigationBarHidden(true)
    }
}

struct themap:  UIViewRepresentable{
        
    @State var locations = [Location]()
    
    var mypos = CLLocationManager()
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        
    }
    
    func setUpMap(){
        mypos.desiredAccuracy = kCLLocationAccuracyBest
        mypos.requestWhenInUseAuthorization()
        mypos.requestAlwaysAuthorization()
        mypos.startUpdatingLocation()
        //mypos 是我們看到的藍點
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        setUpMap()
        //設定初始
    
        let mapView = MKMapView(frame: UIScreen.main.bounds)
        
        mapView.showsUserLocation = true
        // 顯示user位置
        mapView.userTrackingMode = .follow
        // 跟隨user 位置
        mapView.pointOfInterestFilter = MKPointOfInterestFilter(including: [.school, .store,.university, .restaurant, .cafe, .library, .foodMarket])
        // 新增mapView 中的興趣點
            
        Firestore.firestore().collection("store").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.locations = documents.map {(QueryDocumentSnapshot) ->Location in

                let data = QueryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let latitude = data["latitude"] as? Double ?? 0.0
                let longtitude = data["longtitude"] as? Double ?? 0.0
                let bag = data["bag"] as? Int ?? 0
                
                // locations.count 目前為二 程式會跑  0 , 1 (不會執行2)
                let note = MKPointAnnotation()
                // 設定 新的 instance note
                note.title = name
                // 設定 note 的名字
                note.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                //設定 note 的 座標
                note.subtitle = "\(bag) plastic bags"
                // 設定 note 的 subtitle

                mapView.addAnnotation(note)
                // 將note 加到 mapview 中
                                
                return Location(name: name, latitude: latitude, longtitude: longtitude, bag: bag)
            }
        }
        return mapView
    }
        //回傳整個地圖
}

struct Map_Previews: PreviewProvider {
    static var previews: some View {
        Map()
    }
}
