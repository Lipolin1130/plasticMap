//
//  HomePage.swift
//  map
//
//  Created by iOS Club on 2021/7/10.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
import CoreImage.CIFilterBuiltins

struct Home_U: View{
    
    @State var Email: String = Auth.auth().currentUser?.email ?? ""
    @State var person = [Person]()
    
    let context = CIContext()
    let filter = CIFilter.qrCodeGenerator()
    @State var point :Int = 0
    
    var body: some View{
        
        NavigationView{
            
            VStack(alignment: .center, spacing: 20){
                
                Spacer()
                
                Image(uiImage: generateQRCode(from: Email))
                    .interpolation(.none)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
                    .padding()
                
                Text(Email)
                    .font(.title)
                
                Text("Point: \(point)")
                    .font(.title)
                
                Spacer()
            }
            .navigationTitle("Home")
            .onAppear(){
                fetchData()
            }
        }
        .navigationBarHidden(true)
    }
    
    func generateQRCode(from string: String) ->UIImage{
        
        let data = Data(string.utf8)
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage{
            if let cgimg = context.createCGImage(outputImage,from: outputImage.extent){
                return UIImage(cgImage: cgimg)
            }
        }
        return UIImage(systemName: "xmark.circle") ?? UIImage()
    }
    
    func fetchData(){
        
        Firestore.firestore().collection("maps").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.person = documents.map {(QueryDocumentSnapshot) ->Person in

                let data = QueryDocumentSnapshot.data()
                let email = data["email"] as? String ?? ""
                let identity = data["identity"]as? String ?? ""
                let name = data["name"]as? String ?? ""
                let point = data["point"]as? Int ?? 0
                
                if(email.lowercased() == Email.lowercased()){
                    
                    self.point = point
                }

                return Person(email: email, identity: identity, name: name, point: point)
            }
        }
    }
}

//HomePage ->Home_U
struct Home_U_Previews: PreviewProvider {
    static var previews: some View {
        Home_U()
    }
}
