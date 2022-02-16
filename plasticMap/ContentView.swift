
import SwiftUI
import Firebase
import FirebaseFirestore

struct ContentView: View {
    var body: some View {
        Home()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home : View {
    
    @State var person = [Person]()
    @State var show = false
    @State var status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
    //UserDefault.standard 資料儲存不限格式（value) forkey: 字串
    
    
    var body: some View{
        
        NavigationView{
            
            VStack{
                
                if self.status{
                    //跳轉到homescreen
                    MainView()
                        .navigationBarHidden(true)
                }
                else{
                    
                    ZStack{
                        
                        NavigationLink(destination: SignUp(show: self.$show), isActive: self.$show) {
                        }
                        .hidden()//隱藏上面的navigationLink
                        
                        Login(show: self.$show)
                            
                    }
                }
            }
            .navigationTitle("")
            .navigationBarHidden(true)
            .navigationBarBackButtonHidden(true)
            .onAppear {//跳轉到登入畫面
                //進行傳值
                NotificationCenter.default.addObserver(forName: NSNotification.Name("status"), object: nil, queue: .main) { (_) in
                    //更改初始
                    self.status = UserDefaults.standard.value(forKey: "status") as? Bool ?? false
                }
            }
        }
    }
}

struct Login : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    var body: some View{
        
        ZStack{
            
            ZStack(alignment: .topTrailing) {
                    
                VStack(){
                    
                    Spacer()
                    
                    Image("logo")
                        .resizable()
                        .frame(width: 180, height: 180)
                        .scaledToFit()//圖片維持比例左右上下留白
                    
                    Text("Log in to your account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                        .padding(.top, 35)
                    
                    TextField("Email", text: self.$email)
                    .autocapitalization(.none)//自動大寫
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                    .padding(.top, 25)
                    
                    HStack(spacing: 15){
                        
                        VStack{
                            
                            if self.visible{
                                
                                TextField("Password", text: self.$pass)
                                .autocapitalization(.none)
                            }
                            else{
                                
                                SecureField("Password", text: self.$pass)
                                .autocapitalization(.none)
                                
                            }
                        }
                        
                        Button(action: {
                            
                            self.visible.toggle()
                            
                        }) {
                            
                            Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(self.color)
                        }
                        
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color, lineWidth: 2))
                    .padding(.top, 25)
                    
                    HStack{
                        
                        Spacer()
                        
                        Button(action: {
                            
                            self.reset()
                            
                        }) {
                            
                            Text("Forget password")
                                .fontWeight(.bold)
                                .foregroundColor(Color("Color"))
                        }
                    }
                    .padding(.top, 20)
                    
                    Button(action: {
                        
                        self.verify()
                        
                    }) {
                        
                        Text("Login")
                            .bold()
                            .foregroundColor(.white)
                            .padding(.vertical)
                            .frame(width: UIScreen.main.bounds.width - 50)
                            .font(.title2)
                        
                    }
                    .background(Color("Color"))
                    .cornerRadius(10)
                    .padding(.top, 25)
                    
                    Spacer()
                    
                }
                .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.show.toggle()
                    
                }) {
                    
                    Text("Register")
                        .fontWeight(.bold)
                        .foregroundColor(Color("Color"))
                }
                .padding()
                
            }
            
            if self.alert{
                
                ErrorView(alert: self.$alert, error: self.$error)
            }
        }
    }
    
    func verify(){
        
        if self.email != "" && self.pass != ""{
            
            Auth.auth().signIn(withEmail: self.email, password: self.pass) { (res, err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                UserDefaults.standard.set(true, forKey: "status")
                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                
            }
        }
        else{
            
            self.error = "Please fill all the contents properly"
            self.alert.toggle()
        }
    }
    
    func reset(){
        
        if self.email != ""{
            
            Auth.auth().sendPasswordReset(withEmail: self.email) { (err) in
                
                if err != nil{
                    
                    self.error = err!.localizedDescription
                    self.alert.toggle()
                    return
                }
                
                self.error = "RESET"
                self.alert.toggle()
            }
        }
        else{
            
            self.error = "Email Id is empty"
            self.alert.toggle()
        }
    }
}

struct SignUp : View {
    
    @State var color = Color.black.opacity(0.7)
    @State var email = ""
    @State var pass = ""
    @State var visible = false
    @Binding var show : Bool
    @State var alert = false
    @State var error = ""
    
    @State var name = ""
    @State var identify: String = ""
    @State var latitude: String = ""
    @State var longtitude: String = ""
    
    
    let roles: [String] = ["Merchant", "User"]
    
    var body: some View{
        
            ZStack{
                
                ZStack(alignment: .topLeading){
                        
                    VStack{
                        
                        VStack{
                            Text("Create your account")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(self.color)
                                .padding(.top, 35)
                            
                            HStack{
                                
                                Text("身份: ")
                                    .fontWeight(.semibold)
                                    .foregroundColor(self.color)
                                
                                Picker(selection: $identify, label:
                                        
                                        HStack{
                                            
                                            if identify == ""{
                                                HStack{
                                                    
                                                    Text("       ")
                                                }
                                            }else{
                                                Text(identify)
                                            }

                                            Image(systemName: "arrowtriangle.down")
                                                .foregroundColor(.black)
                                        }
                                        .font(.headline)
                                        .foregroundColor(Color("Color"))
                                        .padding()
                                        .background(RoundedRectangle(cornerRadius: 8).stroke(Color.black, lineWidth: 2))
                                        .padding(.horizontal)
                                        .cornerRadius(10)
                                       
                                       ,content:{
                                        
                                            Text("店家").tag("Merchant")
                                        
                                            Text("使用者").tag("User")
                                       })
                                    .pickerStyle(MenuPickerStyle())
                            }
                        }
                        
                        Text("店家需要輸入經緯度...")
                            .foregroundColor(.red)
                        VStack{
                            HStack{
                                
                                Text("緯度:")
                                TextField("22~25", text: $latitude)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                            
                            HStack{
                                
                                Text("經度:")
                                TextField("120~122", text: $longtitude)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                            }
                        }
                        .padding()
                        
                        
                        TextField("name/shop name",text: self.$name)
                            .autocapitalization(.none)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                            .padding(.top, 25)
                        
                        TextField("Email", text: self.$email)
                        .autocapitalization(.none)
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.email != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                        
                        
                        HStack(spacing: 15){
                            
                            VStack{
                                
                                if self.visible{
                                    
                                    TextField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                    
                                }
                                else{
                                    
                                    SecureField("Password", text: self.$pass)
                                    .autocapitalization(.none)
                                    
                                }
                            }
                            
                            Button(action: {
                                
                                self.visible.toggle()
                                
                            }) {
                                
                                Image(systemName: self.visible ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(self.color)
                            }
                            
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 4).stroke(self.pass != "" ? Color("Color") : self.color,lineWidth: 2))
                        .padding(.top, 25)
                                                    
                        Spacer()
                        
                        Button(action: {
                            
                            self.register()
                        }) {
                            
                            Text("註冊")
                                .bold()
                                .foregroundColor(.white)
                                .padding(.vertical)
                                .frame(width: UIScreen.main.bounds.width - 50)
                        }
                        .background(Color("Color"))
                        .cornerRadius(10)
                        .padding(.top, 25)
                        
                        Spacer()
                        
                    }
                    .padding(.horizontal, 25)
                    
                    Button(action: {

                        self.show.toggle()
                    }) {

                        Image(systemName: "chevron.left")
                            .font(.title)
                            .foregroundColor(Color("Color"))
                    }
                    .padding()
                }
                
                if self.alert{
                    
                    ErrorView(alert: self.$alert, error: self.$error)
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
    }
    
    func register(){
        
        if self.identify != ""{
            
            if self.name != ""{
                
                if self.email != ""{
                    
                    if self.pass != ""{// if self.pass != self.repass
                        
                        if self.identify == "Merchant"{
                            
                            if self.latitude != "" && self.longtitude != ""{
                                Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                                    
                                    if err != nil{
                                        
                                        self.error = err!.localizedDescription
                                        self.alert.toggle()
                                        return
                                    }
                                    
                                    Firestore.firestore().collection("maps").document(email).setData([
                                        "email": email,
                                        "identity": identify,
                                        "name": name,
                                        "point": 0
                                    ])
                                   
                                    Firestore.firestore().collection("store").document(email).setData([
                                        "name": name,
                                        "latitude": Double(latitude)!,
                                        "longtitude": Double(longtitude)!,
                                        "bag": 0
                                    ])
                                    
                                    UserDefaults.standard.set(true, forKey: "status")
                                    NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                                }
                            }else{
                                self.error = "請輸入經緯度"
                                self.alert.toggle()
                            }
                        }else if self.identify == "User"{
                            
                            Auth.auth().createUser(withEmail: self.email, password: self.pass) { (res, err) in
                                
                                if err != nil{
                                    
                                    self.error = err!.localizedDescription
                                    self.alert.toggle()
                                    return
                                }
                                
                                Firestore.firestore().collection("maps").document(email).setData([
                                    "email": email,
                                    "identity": identify,
                                    "name": name,
                                    "point": 0
                                ])
                                
                                UserDefaults.standard.set(true, forKey: "status")
                                NotificationCenter.default.post(name: NSNotification.Name("status"), object: nil)
                            }
                        }
                    }
                    else{
                        
                        self.error = "請輸入密碼"
                        self.alert.toggle()
                    }
                }
                else{
                    
                    self.error = "請完成內容"
                    self.alert.toggle()
                }
            }
            else{
                self.error = "請輸入名稱"
                self.alert.toggle()
            }
        }
        else{
            self.error = "請選擇身份"
            self.alert.toggle()
        }
    }
}

struct ErrorView : View {
    
    @State var color = Color.black.opacity(0.7)
    @Binding var alert : Bool
    @Binding var error : String
    
    var body: some View{
            
            VStack{
                
                HStack{
                    
                    Text("Message")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(self.color)
                    
                    Spacer()
                }
                .padding(.horizontal, 25)
                
                Text(self.error == "RESET" ? "Password reset link has been sent successfully" : self.error)
                .foregroundColor(self.color)
                .padding(.top)
                .padding(.horizontal, 25)
                
                Button(action: {
                    
                    self.alert.toggle()
                    
                }) {
                    
                    Text("OK")
                        .foregroundColor(.white)
                        .padding(.vertical)
                        .frame(width: UIScreen.main.bounds.width - 120)
                }
                .background(Color("Color"))
                .cornerRadius(10)
                .padding(.top, 25)
                
            }
            .padding(.vertical, 25)
            .frame(width: UIScreen.main.bounds.width - 70)
            .background(Color.white)
            .cornerRadius(15)
    }
}
