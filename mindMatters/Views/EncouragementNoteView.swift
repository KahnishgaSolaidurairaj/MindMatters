import SwiftUI

struct EncouragementNoteView: View {
    @State private var note = ""
    @State private var noteSent = false

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(Theme.teal)

                Text("Send a note to their potting shed.")
                    .font(Theme.bodyText)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.textDark.opacity(0.8))

                TextEditor(text: $note)
                    .font(Theme.bodyText)
                    .frame(height: 160)
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                PrimaryCapsuleButton(title: "Send Note", isEnabled: !note.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty) {
                    noteSent = true
                }

                if noteSent {
                    Label("Note sent!", systemImage: "checkmark.circle.fill")
                    .font(Theme.bodyText)
                    .foregroundStyle(.green)
                }
            }
            .padding()
        }
    }
}

#Preview {
    AppPageShell(title: "Send a Message") {
        EncouragementNoteView()
    }
}
