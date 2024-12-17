import SwiftUI
import Lottie

struct LoadingView: View {
    var bigSize: Bool = false
    var body: some View {
        LottieView(animation: .named("loadingAnimation"))
            .configure(\.contentMode, to: .scaleAspectFit)
            .playing(loopMode: .loop)
            .animationSpeed(0.8)
            .frame(
                width: bigSize ? 300 : 200,
                height: bigSize ? 200 : 100
            )
    }
}
