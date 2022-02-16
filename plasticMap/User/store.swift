//
//  store.swift
//  map
//
//  Created by iOS Club on 2021/7/14.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct store: View {
    
    @ObservedObject private var viewModel = StoreViewModel()
    
    var body: some View {
        
        NavigationView{
            
            List(viewModel.stores){store in

                VStack(alignment: .leading){

                    HStack{
                        Text(store.name)
                            .font(.headline)
                            
                        Spacer()
                        
                        Text("point:\(store.point)")
                            .font(.headline)
                    }
                    Text(store.discount)
                        .font(.subheadline)
                    
                    Text(store.address)
                        .font(.subheadline)
                }
            }
            .navigationBarTitle("Store")
        }
        .navigationBarHidden(true)
        .onAppear(){
            
            self.viewModel.fetchData()
        }
    }
}

struct store_Previews: PreviewProvider {
    static var previews: some View {
        store()
    }
}
