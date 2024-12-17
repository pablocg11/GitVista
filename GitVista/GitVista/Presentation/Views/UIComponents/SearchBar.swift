import SwiftUI

struct SearchBar: View {
    @Binding var searchText: String 
    @State var searchAction: () -> Void
    var body: some View {
        HStack {
            TextField("",
                      text: $searchText,
                      prompt: Text("Enter a GitHub username")
                        .foregroundColor(.white.opacity(0.6)))
                .accentColor(.white)
                .font(.callout)
                .autocorrectionDisabled(true)
                .textInputAutocapitalization(.never)
                .onSubmit {
                    searchAction()
                }
            Button(action: {
                searchAction()
            }, label: {
                Image(systemName: "magnifyingglass")
            })
        }
        .foregroundStyle(.white)
        .padding()
        .background(Color.gray.opacity(0.8))
        .cornerRadius(20)
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.gray.opacity(0.5), lineWidth: 1)
        )
    }
}
