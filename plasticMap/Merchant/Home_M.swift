//
//  MerchantHome.swift
//  plasticMap
//
//  Created by iOS Club on 2021/7/18.
//

import SwiftUI
import CodeScanner
import FirebaseAuth
import FirebaseFirestore
import Firebase

struct Home_M: View {
    
    @State private var isShowingScanner = false
    @State var scanString: String = ""//使用者的
    @State var choose: String = "donate"//donate or use
    @State var count: Int = 0// 數量
    
    @State var alert: Bool = false
    @State var error: String = ""
    
    @State var storeBag: Int = 0//店家的原始袋子
    @State var UserPoint: Int = 0//使用者的點數
    
    @State var person = [Person]()
    @State var MerchantEmail = Auth.auth().currentUser?.email ?? ""//店家的
    
    var body: some View {
        
        NavigationView{
            
            ZStack{
                
                VStack{
                    
                    Button(action:{
                        
                        self.isShowingScanner = true
                    }){
                        VStack{
                            Image(systemName: "qrcode.viewfinder")
                                .resizable()
                                .frame(width: 180, height: 180, alignment: .center)
                                .foregroundColor(Color("Color"))
                            
                            Text("Press")
                                .font(.title)
                                .foregroundColor(Color("Color"))
                        }
                            
                    }
                    .sheet(isPresented: $isShowingScanner){
                        CodeScannerView(codeTypes: [.qr], simulatedData: "Some simulated data", completion: self.handleScan)
                    }
                    
                    Spacer()
                    
                    HStack{
                        
                        Text("使用者: ")
                            .font(.title)
                        TextField("", text: $scanString)
                            .autocapitalization(.none)
                            .font(.title2)
                            .padding()
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color("Color"), lineWidth: 3)
                            )
                            .padding()
                    }
                    .padding()
                    .onAppear(){
                        
                        fetchData_Store()
                    }
                    
                    HStack{
                        
                        Picker(selection: $choose, label:
                                Text("Use")

                               ,content:{

                                    Text("捐贈塑膠袋").tag("donate")
                                
                                    Text("領取塑膠袋").tag("receive")
                                
                                    Text("使用點數").tag("use")
                                
                                })
                            .frame(width: 200, height: 80)
                            .clipped()
                        
                        Picker("age", selection: $count){
                            ForEach(0 ..< 251){(count) in
                                Text("\(count)")
                            }
                        }
                        .frame(width: 100, height: 75)
                        .clipped()
                        
//                        Text("Bag/point")
                    }
                    
                    Spacer()

                    Button(action: {
                        
                        self.upData()
                    }){
                        
                        Text("OK")
                            .foregroundColor(.white)
                            .bold()
                            .font(.system(size: 24))
                    }
                    .frame(width: 200, height: 50)
                    .background(Color("Color"))
                    .cornerRadius(8)
                    .padding()

                    Spacer()
                }
            
                if self.alert{
                    ErrorView(alert: self.$alert, error: self.$error)
                }
            }
            
        }.navigationBarHidden(true)
    }
    
    private func handleScan(result: Result<String, CodeScannerView.ScanError>){
        
        self.isShowingScanner = false
        switch result{
            case .success(let Qrcode):
                self.scanString = Qrcode
                print("Success with \(Qrcode)")
                
                //獲得使用者目前的點數
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
                
                        if(email.lowercased() == Qrcode.lowercased()){
                            
                            self.UserPoint = point
                        }
                        return Person(email: email, identity: identity, name: name, point: point)
                    }
                }
            case .failure(let error):
                    print("Scanning filed \(error)")
        }
    }
    
    func upData(){
        
        if self.scanString != ""{
            
            if self.choose == "donate"{//增加店家的塑膠袋數量
                
                Firestore.firestore().collection("maps").document(MerchantEmail).updateData([
                    "point" : storeBag + count
                ]){err in
                    if let err = err{
                        print("Error updating document: \(err)")
                    }else{
                        print("Document successfully updated")
                    }
                }
                
                Firestore.firestore().collection("store").document(MerchantEmail).updateData([
                    "bag" : storeBag + count
                ]){err in
                    if let err = err{
                        print("Error updating document: \(err)")
                    }else{
                        print("Document successfully updated")
                    }
                }
                //增加使用者的點數
                Firestore.firestore().collection("maps").document(scanString).updateData([
                    "point": UserPoint + count
                ]){err in
                    if let err = err{
                        print("Error updating document: \(err)")
                    }else{
                        print("Document successfully updated")
                    }
                }
            }else if self.choose == "use"{//減少使用者的點數
                Firestore.firestore().collection("maps").document(scanString).updateData([
                    "point": UserPoint - count
                ]){err in
                    if let err = err{
                        print("Error updating document: \(err)")
                    }else{
                        print("Document successfully updated")
                    }
                }
            }else{//減少店家塑膠袋
                Firestore.firestore().collection("maps").document(MerchantEmail).updateData([
                    "point" : storeBag - count
                ]){err in
                    if let err = err{
                        print("Error updating document: \(err)")
                    }else{
                        print("Document successfullly updated")
                    }
                }
                
                Firestore.firestore().collection("store").document(MerchantEmail).updateData([
                    "bag" : storeBag - count
                ]){err in
                    if let err = err{
                        print("Error updating document: \(err)")
                    }else{
                        print("Document successfullly updated")
                    }
                }
            }
            
            UserDefaults.standard.set(true, forKey: "status")
            NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            
            self.error = "\(scanString) \(choose) \(count) \(choose == "donate" ? "bag" : "point")"
            self.scanString = ""
            self.choose = "donate"
            self.count = 0
            self.alert.toggle()
            self.UserPoint = 0
            
        }else{
            self.alert.toggle()
            self.error = "Please fill all the contents properly"
        }
        
    }
    
    func fetchData_Store(){
        
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
                
                if(email.lowercased() == MerchantEmail.lowercased()){
                    
                    self.storeBag = point
                }

                return Person(email: email, identity: identity, name: name, point: point)
            }
        }
    }
    
}

struct Home_M_Previews: PreviewProvider {
    static var previews: some View {
        Home_M()
    }
}
