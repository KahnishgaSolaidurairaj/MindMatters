import SwiftUI

struct EncouragementNoteView: View {
    @State private var note = ""
    @State private var noteSent = false

    var body: some View {
        ZStack {
            Color(red: 0.89, green: 0.88, blue: 0.82)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "envelope.fill")
                    .font(.system(size: 70))
                    .foregroundStyle(
                        Color(red: 0.35, green: 0.57, blue: 0.60)
                    )

                Text("Leave Encouragement")
                    .font(.largeTitle)
                    .fontWeight(.bold)

                Text(
                    "Write a supportive note for their potting shed."
                )
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)

                TextEditor(text: $note)
                    .frame(height: 160)
                    .padding(8)
                    .background(Color.white.opacity(0.9))
                    .clipShape(RoundedRectangle(cornerRadius: 16))

                Button("Send Note") {
                    noteSent = true
                }
                .fontWeight(.semibold)
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    Color(red: 0.35, green: 0.57, blue: 0.60)
                )
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
