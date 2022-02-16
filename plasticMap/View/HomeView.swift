
import SwiftUI
import Firebase
import FirebaseFirestore


struct HomeView: View {
    
    @Binding var selectedTab: String
    
    // Hiding Tab Bar...
    init(selectedTab: Binding<String>){
        
        self._selectedTab = selectedTab
        UITabBar.appearance().isHidden = true
        
    }
    
    var body: some View {
        
        // Tab View With  Tabs...
        TabView(selection: $selectedTab){
            
            //Views...
            Home_M()
                .tag("Home_M")
            //Home_U
            Home_U()
                .tag("Home_U")
            
            Map()
                .tag("Map")

            store()
                .tag("store")
            
            Discount()
                .tag("Discount")
                
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
       MainView()
    }
}
