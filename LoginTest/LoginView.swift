
//
//  ContentView.swift
//  MyLoginApp
//
//  Created by Nishio Naoki on 2023/02/19.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    @State public var errorMessage:String = ""
    
    @State public var stateLogin:Bool = false
    var body: some View {
        VStack {
            TextField("ユーザー名",text: $username)
                .padding()
                .frame(width:300,height:50)
                .background(Color.gray.opacity(0.1))
                .border(.gray)
            TextField("パスワード",text: $password)
                .padding()
                .frame(width:300,height:50)
                .background(Color.gray.opacity(0.1))
                .border(.gray)
            
            Button(action: {
                if(self.username == ""){
                    self.errorMessage = "メールアドレスが入力されていません"
                } else if(self.password == ""){
                    self.errorMessage = "パスワードが入力されていません"
                } else {
                   
                    Auth.auth().signIn(withEmail: self.username, password: self.password) { authResult, error in
                                if authResult?.user != nil {
                                    // ログイン成功処理
                                    print("success")
                                    self.stateLogin = true
                                } else {
                                    // ログイン失敗処理
                                    if let error = error as NSError?, let errorCode = AuthErrorCode(rawValue: error.code) {
                                        switch errorCode {
                                        case .invalidEmail:
                                            self.errorMessage = "メールアドレスの形式が正しくありません"
                                            print(errorMessage)
                                        case .userNotFound, .wrongPassword:
                                            self.errorMessage = "メールアドレス、またはパスワードが間違っています"
                                            print(errorMessage)
                                            
                                        case .userDisabled:
                                            self.errorMessage = "このユーザーアカウントは無効化されています"
                                            print(errorMessage)
                                        default:
                                            self.errorMessage = error.domain
                                        }
                                    }
                                }
                            }
                }
                
            }, label: {
                Text("ログイン")
            })
            .foregroundColor(.white)
            .frame(width:300,height:50)
            .background(Color.orange)
            .padding(.top)
            
            Button(action: {
                if(self.username == ""){
                    self.errorMessage = "メールアドレスが入力されていません"
                } else if(self.password == ""){
                    self.errorMessage = "パスワードが入力されていません"
                } else {
                    Auth.auth().createUser(withEmail: self.username, password: self.password) { authResult, error in
                       print(authResult)
                    }
                }
            }, label: {
                Text("アカウント作成")
            })
            .foregroundColor(.white)
            .frame(width:300,height:50)
            .background(Color.orange)
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

