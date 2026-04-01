import SwiftUI

@main
struct JapaneseClockWidgetApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                MainTabView()
            } else {
                OnboardingView()
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Image(systemName: "clock.fill")
                    Text("시계")
                }
                .tag(0)

            GachaView()
                .tabItem {
                    Image(systemName: "sparkles")
                    Text("뽑기")
                }
                .tag(1)

            PetCollectionView()
                .tabItem {
                    Image(systemName: "pawprint.fill")
                    Text("컬렉션")
                }
                .tag(2)
        }
        .tint(.black)
    }
}
