import SwiftUI

struct AppHeaderView: View {
    var body: some View {
        HStack {
            Button {
                // Menu is handled by parent view via appState.showAppMenu
            } label: {
                Image(systemName: "line.3.horizontal")
                    .font(.title2)
                    .foregroundColor(Theme.textDark)
            }

            Spacer()

            MindMattersLogoView(size: 32)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 10))

            Spacer()

            Image(systemName: "person.circle.fill")
                .font(.title)
                .foregroundColor(Theme.teal)
        }
        .padding(.horizontal)
    }
}
