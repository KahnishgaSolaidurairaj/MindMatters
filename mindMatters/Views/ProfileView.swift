import PhotosUI
import SwiftUI

/// Profile screen for avatar, bio, and journal history.
struct ProfileView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedPhoto: PhotosPickerItem?
    @State private var draftName: String = ""
    @State private var draftBio: String = ""
    @State private var draftMajor: String = ""
    @State private var draftHobbies: String = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                profileHeader
                interestsSection
                bioSection
                journalSection
                linksSection
            }
            .padding()
        }
        .onAppear {
            draftName = appState.userName.isEmpty ? "Guest" : appState.userName
            draftBio = appState.bio
            draftMajor = appState.major
            draftHobbies = appState.hobbies
        }
        .onDisappear {
            appState.updateUserName(draftName)
            appState.bio = draftBio
            appState.major = draftMajor
            appState.hobbies = draftHobbies
        }
        .onChange(of: selectedPhoto) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self) {
                    appState.profileImageData = data
                }
            }
        }
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            PhotosPicker(selection: $selectedPhoto, matching: .images) {
                profileImage
                    .overlay(alignment: .bottomTrailing) {
                        Image(systemName: "camera.fill")
                            .font(.caption)
                            .foregroundStyle(.white)
                            .padding(6)
                            .background(Theme.teal)
                            .clipShape(Circle())
                    }
            }

            if appState.equippedPin != nil || appState.equippedProfileFrame != nil {
                HStack(spacing: 8) {
                    if let frame = appState.equippedProfileFrame {
                        Label(frame, systemImage: "person.crop.circle")
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.teal)
                    }
                    if let pin = appState.equippedPin {
                        Label(pin, systemImage: "pin.fill")
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.teal)
                    }
                }
            }

            TextField("Name", text: $draftName)
                .font(Theme.sectionTitle)
                .multilineTextAlignment(.center)
                .foregroundStyle(Theme.textDark)
                #if os(iOS)
                .textInputAutocapitalization(.words)
                #endif
                .autocorrectionDisabled()
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.white.opacity(0.92))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    @ViewBuilder
    private var profileImage: some View {
        if let data = appState.profileImageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
                .frame(width: 96, height: 96)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.crop.circle.fill")
                .font(.system(size: 96))
                .foregroundStyle(Theme.teal)
        }
    }

    private var interestsSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Interests")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            TextField("Major (e.g., Computer Science)", text: $draftMajor)
                .font(Theme.bodyText)
                .padding(12)
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            TextField("Hobbies (e.g., Running, Reading)", text: $draftHobbies)
                .font(Theme.bodyText)
                .padding(12)
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 14))

            HStack {
                Text("Focused Priority")
                    .font(Theme.bodyText.weight(.semibold))
                    .foregroundStyle(Theme.textDark)
                Spacer()
                Text(appState.focusedPriority.rawValue)
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.teal)
            }
            .padding(12)
            .background(Color.white.opacity(0.92))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bioSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Bio")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            TextField("Tell connections a little about you…", text: $draftBio, axis: .vertical)
                .font(Theme.bodyText)
                .lineLimit(3...5)
                .padding(12)
                .background(Color.white.opacity(0.92))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var journalSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Recent Reflections")
                .font(Theme.rowTitle)
                .foregroundStyle(Theme.textDark)

            if appState.journalEntries.isEmpty {
                Text("Complete a task and reflect to see entries here.")
                    .font(Theme.bodyText)
                    .foregroundStyle(Theme.textDark.opacity(0.75))
            } else {
                ForEach(appState.journalEntries.reversed().prefix(5)) { entry in
                    VStack(alignment: .leading, spacing: 4) {
                        Text(entry.taskTitle)
                            .font(Theme.bodyText.weight(.semibold))
                            .foregroundStyle(Theme.textDark)
                            .wrapping()
                        Text(entry.text)
                            .font(Theme.bodyText)
                            .foregroundStyle(Theme.textDark.opacity(0.8))
                            .wrapping()
                        Text(entry.date, style: .date)
                            .font(Theme.supportingText)
                            .foregroundStyle(Theme.textDark.opacity(0.5))
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(Color.white.opacity(0.92))
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var linksSection: some View {
        VStack(spacing: 12) {
            NavigationLink(value: AppDestination.encouragementNote) {
                Label("Send a Message", systemImage: "envelope.fill")
                    .font(Theme.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Theme.teal)
                    .foregroundStyle(.white)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
            }

            NavigationLink(value: AppDestination.privacySettings) {
                Label("Privacy Settings", systemImage: "lock.shield.fill")
                    .font(Theme.buttonText)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.white.opacity(0.92))
                    .foregroundStyle(Theme.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 14))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14)
                            .stroke(Theme.teal.opacity(0.35), lineWidth: 1)
                    )
            }
        }
    }
}

#Preview {
    NavigationStack {
        AppPageShell(title: "Profile") {
            ProfileView()
        }
        .environmentObject(AppState())
    }
}
