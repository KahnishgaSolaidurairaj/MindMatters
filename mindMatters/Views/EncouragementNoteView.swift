import SwiftUI

struct EncouragementNoteView: View {
    @State private var note = ""
    @State private var noteSent = false

    var body: some View {
        ZStack {
            Theme.background
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(Theme.teal)

                Text("Leave Encouragement")
                    .font(Theme.pageTitle)

                Text("Write a supportive note for their potting shed.")
                    .font(Theme.bodyText)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Theme.textDark.opacity(0.8))

                TextEditor(text: $note)
                    .font(Theme.bodyText)
                    .frame(height: 160)
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Button("Send Note") {
                    noteSent = true
                }
                .font(Theme.buttonText)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Theme.teal)
                .foregroundStyle(.white)
                .clipShape(RoundedRectangle(cornerRadius: 16))
                .disabled(note.trimmingCharacters(
                    in: .whitespacesAndNewlines
                ).isEmpty)

                if noteSent {
                    Label(
                        "Your note was added to the potting shed.",
                        systemImage: "checkmark.circle.fill"
                    )
                    .font(Theme.bodyText)
                    .foregroundStyle(.green)
                }

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Potting Shed")
    }
}

#Preview {
    NavigationStack {
        EncouragementNoteView()
    }
}
