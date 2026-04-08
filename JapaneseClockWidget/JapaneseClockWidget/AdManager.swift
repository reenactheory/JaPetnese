import SwiftUI
import GoogleMobileAds

class AdManager: NSObject, ObservableObject, GADFullScreenContentDelegate {
    static let shared = AdManager()

    private let adUnitID = "ca-app-pub-6059401773154108/7528178444"

    @Published var isAdReady = false
    private var rewardedAd: GADRewardedAd?
    private var rewardEarned = false
    private var adDismissedCompletion: (() -> Void)?

    override private init() {
        super.init()
        GADMobileAds.sharedInstance().start { [weak self] _ in

            self?.loadAd()
        }
    }

    func loadAd() {

        GADRewardedAd.load(withAdUnitID: adUnitID, request: GADRequest()) { [weak self] ad, error in
            DispatchQueue.main.async {
                if let error = error {
                    self?.isAdReady = false
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10) { self?.loadAd() }
                    return
                }
                self?.rewardedAd = ad
                self?.rewardedAd?.fullScreenContentDelegate = self
                self?.isAdReady = true
            }
        }
    }

    func showAd(completion: @escaping (Bool) -> Void) {
        guard let ad = rewardedAd, let rootVC = rootViewController() else {
            loadAd()
            completion(false)
            return
        }
        rewardEarned = false
        ad.present(fromRootViewController: rootVC) { [weak self] in
            self?.rewardEarned = true
        }
        adDismissedCompletion = { [weak self] in
            completion(self?.rewardEarned ?? false)
            self?.loadAd()
        }
    }

    private func rootViewController() -> UIViewController? {
        UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }

    // MARK: - GADFullScreenContentDelegate

    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        DispatchQueue.main.async {
            self.isAdReady = false
            self.adDismissedCompletion?()
            self.adDismissedCompletion = nil
        }
    }

    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        DispatchQueue.main.async {
            self.isAdReady = false
            self.adDismissedCompletion?()
            self.adDismissedCompletion = nil
            self.loadAd()
        }
    }
}
