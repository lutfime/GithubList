//
//  UserProfileView.swift
//  Test
//
//  Created by Wan Ahmad Lutfi on 22/11/2022.
//

import SwiftUI

struct UserProfileView: View {
    var loginName: String!
    var avatarURL: String!
    
    let viewModel: ProfileViewModel
    
    @State var userProfileViewModel = UserProfileViewModel()
    @State var notes = ""
    @State var title = "Profile"
    @State private var showingAlert = false
    
    init(viewModel: ProfileViewModel){
        self.viewModel = viewModel
    }
    
    func loadData() {
        if let loginName{
            viewModel.loadUserProfile(loginName: loginName)
        }
    }
    
    var body: some View {
        
        ScrollView{
            VStack{
                if let avatarURL = avatarURL{
                    ImageView(withURL: avatarURL)
                }else{
                    Image("emptyImage", bundle: .main).resizable().frame(height: 200)
                }
                
                VStack{
                    HStack(alignment: .center, spacing: 0, content: {
                        Spacer()
                        Text("Followers: \(userProfileViewModel.followerCount)").font(.system(size: 13))
                        Spacer()
                        Text("Following: \(userProfileViewModel.followingCount)").font(.system(size: 13))
                        Spacer()
                    }).padding(.bottom, 15)
                    
                    GroupBox {
                        VStack(alignment: .leading) {
                            Text("Name: \(userProfileViewModel.name ?? "-")").padding(.bottom, 5)
                            Text("Company: \(userProfileViewModel.company ?? "-")").padding(.bottom, 5)
                            Text("Blog: \(userProfileViewModel.blog ?? "-")")
                        }.font(.system(size: 13)).frame(maxWidth: .infinity, alignment: .topLeading)
                    }.shadow(radius: 5).padding(.bottom, 15).groupBoxStyle(WhiteGroupBoxStyle())
                    
                    Text("Notes:").font(.footnote).frame(maxWidth: .infinity, alignment: .leading).padding(.bottom, -2)
                    GroupBox {
                        TextView(text: $notes).frame(minHeight: 100)
                    }.shadow(radius: 5).groupBoxStyle(WhiteGroupBoxStyle()).padding(.bottom, 15)
                    Button{
                        hideKeyboard()
                        viewModel.saveNotes(notes)
                        showingAlert = true
                    }label: {
                        Text("Save").frame(maxWidth: .infinity)
                    }.buttonStyle(BlueButton())
                        .alert(isPresented: $showingAlert) {
                                    Alert(title: Text("Notes saved"), message: Text(""), dismissButton: .default(Text("OK")))
                                }

                }.padding(.leading, 15).padding(.trailing, 15)
                
            }
            .onAppear(
                perform: {loadData()}
            )
            .onReceive(viewModel.$userProfileViewModel) { model in
                if let model{
                    self.notes = model.notes ?? ""
                    self.userProfileViewModel = model
                    self.title = model.loginName
                }
                
            }
        }.navigationTitle("\(title.capitalized)")
    }
}

struct UserProfileView_Previews: PreviewProvider {
    static var previews: some View {
        UserProfileView(viewModel: ProfileViewModel())
    }
}


struct ImageView: View {
    @ObservedObject var imageLoader:ImageLoader
    @State var image:UIImage = UIImage()

    init(withURL url:String) {
        imageLoader = ImageLoader(urlString:url)
    }

    var body: some View {
        
        Image(uiImage: image)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame( height:200)
            .clipped()
            .onReceive(imageLoader.$updatedImage) { image in
                if let image{
                    self.image = image
                }
            }
    }
}

struct TextView: UIViewRepresentable {
 
    @Binding var text: String
 
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
 
        textView.autocapitalizationType = .sentences
        textView.isSelectable = true
        textView.isUserInteractionEnabled = true
        textView.delegate = context.coordinator
        textView.font = .systemFont(ofSize: 13)
 
        return textView
    }
 
    func updateUIView(_ uiView: UITextView, context: Context) {
        uiView.text = text
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator($text)
    }
     
    class Coordinator: NSObject, UITextViewDelegate {
        var text: Binding<String>
     
        init(_ text: Binding<String>) {
            self.text = text
        }
     
        func textViewDidChange(_ textView: UITextView) {
            self.text.wrappedValue = textView.text
        }
    }
}

struct WhiteGroupBoxStyle: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack(alignment: .leading) {
            configuration.label
            configuration.content
        }
        .padding()
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 5, style: .continuous))
    }
}

struct BlueButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(Color(red: 0, green: 0, blue: 0.8))
            .foregroundColor(.white)
            .cornerRadius(10)
    }
}

#if canImport(UIKit)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
