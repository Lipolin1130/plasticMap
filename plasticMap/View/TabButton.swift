
import SwiftUI
import Firebase

struct TabButton: View {
    
    var image: String
    var title: String
    
    // Selected Tab...
    @Binding var selectedTab: String
    // For Hero Animation Slide
    var animation: Namespace.ID
    
    var body: some View {
        
        Button(action: {
            
            withAnimation(.spring()){
                selectedTab = title
            }
            if title == "Log out"{
                
                try! Auth.auth().signOut()
                UserDefaults.standard.set(false, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
            }
            
        }, label:{
            
            HStack(spacing: 15){
                
                Image(systemName: image)
                    .font(.title2)
                    .frame(width: 30)
                
                Text(title)
                    .fontWeight(.semibold)
                
            }
            .foregroundColor(selectedTab == title ? Color("Color") : .white)
            .padding(.vertical, 12)
            .padding(.horizontal, 10)
            // Max Frame...
            .frame(maxWidth: getRect().width - 170, alignment: .leading)
            .background(
            
                //hero Animation
                ZStack{
                    if selectedTab == title{
                        Color.white
                            .opacity(selectedTab == title ? 1 : 0)
                            .clipShape(CustomCorners(corners: [.topRight, .bottomRight], radius: 12))
                            .matchedGeometryEffect(id: "TAB", in: animation)
                    }
                }
            )
        })
    }
}

struct TabButton_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

struct CustomCorners: Shape{
    
    var corners: UIRectCorner
    var radius: CGFloat
    
    func path(in rect: CGRect) -> Path{
        
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}
