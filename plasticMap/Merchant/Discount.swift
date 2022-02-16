//
//  SwiftUIView.swift
//  map
//
//  Created by iOS Club on 2021/7/14.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseAuth

struct Discount: View {
    
    @State var trueEmail: String = Auth.auth().currentUser?.email ?? ""
    @State var person = [Person]()
    @State var address: String = ""
    @State var name: String = ""
    @State var discount: String = ""
    @State var alert: Bool = false
    @State var error: String = ""
    @State var point: Int = 0
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                VStack(alignment: .leading){
                    Spacer()

                    Text("地址 :")
                        .font(.title2)
                        .fontWeight(.semibold)

                    TextField("xx市xx區xx路xx號~~", text: $address)
                        .autocapitalization(.none)
                        .font(.title3)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 2))
                        .padding()

                    Text("優惠 :")
                        .font(.title2)
                        .fontWeight(.semibold)

                    TextField("大杯咖啡買一送一...", text: $discount)
                        .autocapitalization(.none)
                        .font(.title3)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 2))
                        .padding()
                    
                    Text("需要點數：")
                        .font(.title2)
                        .fontWeight(.semibold)

                    TextField("1, 2, 3...",value: $point, formatter: NumberFormatter())
                        .font(.title3)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(lineWidth: 2))
                        .padding()
                    
                    Spacer()
                    
                    Button(action:{
                        
                        self.upload()
                        
                    }){
                        Text("Send")
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .font(.title2)
                    }
                    .background(Color("Color"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                    
                    Spacer()
                        .navigationTitle("新增優惠")
                }
                .padding(.horizontal, 25)
                .onAppear(){
                    fetchData()
                }
                
                if self.alert{
                    ErrorView(alert: self.$alert, error: self.$error)
                }
            }
            
        }
        .navigationBarHidden(true)
    }
    
    func upload(){
            
        if address != ""{
            
            if discount != ""{
                
                if point != 0 {
                    
                    Firestore.firestore().collection("discount").addDocument(data: [
                        "address" : address,
                        "name" : name,
                        "discount" : discount,
                        "point" : point
                    ])
                    
                    UserDefaults.standard.set(true, forKey: "status")
                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                    
                    self.address = ""
                    self.discount = ""
                    self.name = ""
                    self.point = 0
                    self.error = "Successful"
                    self.alert.toggle()
                }else{
                    self.error = "fill the point"
                    self.alert.toggle()
                }
            }else{
                self.error = "fill the discount"
                self.alert.toggle()
            }
        }else{
            self.error = "fill the address"
            self.alert.toggle()
        }
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
                
                if(email.lowercased() == trueEmail.lowercased()){
                    self.name = name
                }
                return Person(email: email, identity: identity, name: name, point: point)
            }
        }
    }
}

struct Discount_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            Discount()
        }
    }
}
