
import SwiftUI
import Firebase

struct SideMenu: View {
    
    @Binding var selectedTab: String
    @Namespace var animation
    @State var person = [Person]()
    @State var trueEmail = Auth.auth().currentUser?.email ?? ""

    @State var Email: String = ""
    @State var Name: String = ""
    @State var Identity: Bool = false // Merchant = true, User == false
    @State var Point: Int = 0
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 15, content: {
            
            // Profile Pic...
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: /*@START_MENU_TOKEN@*/.fill/*@END_MENU_TOKEN@*/)
                .frame(width: 70, height: 70)
                .cornerRadius(10)
                
            // Padding top for Top Cloase Button
                .padding(.top, 50)
            
            VStack(alignment: .leading, spacing: 6, content: {
                Text(self.Name)
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.white)
                
                Text(self.Email)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.7)
                
                Text("\(Identity ? "Bag" : "Point"): \(self.Point)")
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.7)
                    
            })
            
            // tab Buttons...
            
            VStack(alignment: .leading, spacing: 10){
                
                if self.Identity{
                    //MerchantHome ->Home_M
                    TabButton(image:"house", title: "Home_M", selectedTab: $selectedTab, animation: animation)//店家主頁
                    TabButton(image: "cart.badge.plus", title: "Discount", selectedTab: $selectedTab, animation: animation)//增加優惠
                    
                }else{
                    //HomePage ->Home_U
                    TabButton(image:"house", title: "Home_U", selectedTab: $selectedTab, animation: animation)//使用者主頁
                    TabButton(image: "cart", title: "store", selectedTab: $selectedTab, animation: animation)//店家資訊
                    
                }
                                
                TabButton(image: "map", title: "Map", selectedTab: $selectedTab, animation: animation)//Ｍap
                
            }
            .padding(.leading, -15)
            .padding(.top, 10)
            
            Spacer()
            
            //Sign Out Button...
            VStack(alignment: .leading, spacing: 6, content:{
              
                TabButton(image: "rectangle.righthalf.inset.fill.arrow.right", title: "Log out", selectedTab: .constant(""), animation: animation)
                .padding(.leading, -15)
                
                Text("App Version 1.1.2")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .opacity(0.6)
            })
        })
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .onAppear(){
            fetchData()
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
                    
                    self.Email = email
                    self.Name = name
                    self.Point = point
                    if identity == "Merchant"{
                        
                        self.Identity = true
                        
                    }else{
                        
                        self.Identity = false
                    }
                }

                return Person(email: email, identity: identity, name: name, point: point)
            }
        }
    }
}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
