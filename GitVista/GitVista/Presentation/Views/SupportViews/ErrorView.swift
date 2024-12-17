import SwiftUI

struct ErrorView: View {
    var errorMessage: String
    var body: some View {
        VStack(spacing: 6) {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 100)
                .padding(.bottom, 20)
            
            Text(errorMessage)
                .font(.callout)
        }
        .padding(.horizontal, 30)
        .foregroundStyle(Color.white)
        .multilineTextAlignment(.center)
    }
}

#Preview {
    ErrorView(errorMessage: "You have exceeded the request rate limit. Please wait and try again later.")
}
