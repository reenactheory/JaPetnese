import SwiftUI
import AppTrackingTransparency

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

    init() {
        requestTrackingPermission()
    }

    private func requestTrackingPermission() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            ATTrackingManager.requestTrackingAuthorization { _ in
                // 권한 허용 여부와 관계없이 AdMob은 비개인화 광고로 동작
                _ = AdManager.shared
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

            ItemInventoryView()
                .tabItem {
                    Image(systemName: "bag.fill")
                    Text("아이템")
                }
                .tag(3)
        }
        .tint(.black)
    }
}
