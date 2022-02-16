


import SwiftUI
import FirebaseFirestore
import FirebaseAuth

class StoreViewModel : ObservableObject{
    
    @Published var stores = [Store]()

    @Published var address: String = ""
    @Published var name: String = ""
    @Published var discount: String = ""

    private var db = Firestore.firestore()

    func fetchData(){
        db.collection("discount").addSnapshotListener{(querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No documents")
                return
            }

            self.stores = documents.map {(QueryDocumentSnapshot) ->Store in

                let data = QueryDocumentSnapshot.data()
                let address = data["address"] as? String ?? ""
                let name = data["name"]as? String ?? ""
                let discount = data["discount"]as? String ?? ""
                let point = data["point"]as? Int ?? 0
                
                return Store(name: name, address: address, discount: discount, point: point)
            }
        }
    }
}
