
import UIKit
import CoreData
import FirebaseCore
import Firebase
import FirebaseAppCheck
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    
var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        FirebaseApp.configure()
        AppCheck.setAppCheckProviderFactory(AppCheckDebugProviderFactory())
        
        if cache.bool(forKey: "isTabbar") {
            window?.rootViewController = Tabbar()
        }else {
            window?.rootViewController = UINavigationController(rootViewController: LoginVC())
        }
        
        window?.makeKeyAndVisible()
        return true
    }

   

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
       
        let container = NSPersistentContainer(name: "MyShop")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

