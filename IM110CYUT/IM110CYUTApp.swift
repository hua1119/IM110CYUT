//
//  IM110CYUTApp.swift
//
//
//
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseCore

//MARK: Firebase
//初始化啟動Firebase
class AppDelegate: NSObject, UIApplicationDelegate 
{
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        let pf=AppCheckDebugProviderFactory()
        AppCheck.setAppCheckProviderFactory(pf)
        FirebaseApp.configure()
        return true
    }
}

//MARK: Main App
@main
struct IM110CYUTApp: App 
{
    //提供所有View使用的User結構
    @EnvironmentObject var user: User

    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    //控制深淺模式
    @AppStorage("colorScheme") private var colorScheme: Bool = true
//    @StateObject private var cameraManagerViewModel = CameraManagerViewModel()

    //CoreData
    let persistenceController = PersistenceController.shared

    var body: some Scene 
    {
        WindowGroup 
        {
            SigninView()
//            CameraContentView(cameraManagerViewModel: cameraManagerViewModel)
//           ContentView()
                .preferredColorScheme(self.colorScheme ? .light:.dark)
//              //CoreData連結
//                .environment(.managedObjectContext, persistenceController.container.viewContext)
                //提供環境User初始化
                .environmentObject(User())
        }
    }
}
