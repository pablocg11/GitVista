import SwiftUI
import Lottie

struct LoadingView: View {
    var body: some View {
        LottieView(animation: .named("loadingAnimation"))
            .configure(\.contentMode, to: .scaleAspectFit)
            .playing(loopMode: .loop)
            .animationSpeed(0.8)
            .frame(maxWidth: 300, maxHeight: 200)
    }
}
