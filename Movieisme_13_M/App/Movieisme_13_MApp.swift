import SwiftUI
import SwiftData

@main
struct Movieisme_13_MApp: App {

    @StateObject private var signInVM = SignInViewModel()

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([Item.self])
        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            return try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if signInVM.signedInUser == nil {
                    SignInView()
                } else {
                    MoviesView()
                }
            }
            .environmentObject(signInVM)   // ✅ نفس الـ VM لكل التطبيق
        }
        .modelContainer(sharedModelContainer)
    }
}

