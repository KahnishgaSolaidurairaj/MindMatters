import SwiftUI

struct ResourcesHubView: View {
    @Environment(\.dismiss) var dismiss
    @State private var selectedPath: ResourcePath?

    enum ResourcePath: Identifiable {
        case formalHelp, workshops
        var id: Self { self }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.background.ignoresSafeArea()

                VStack(spacing: 20) {
                    Text("On Campus Resources")
                        .font(.title2.bold())
                        .foregroundColor(Theme.textDark)
                    Text("University of Illinois at Chicago")
                        .font(.subheadline)
                        .foregroundColor(Theme.textDark.opacity(0.6))

                    VStack(spacing: 16) {
                        ResourceOptionCard(
                            icon: "person.fill.checkmark",
                            title: "Formal Help",
                            subtitle: "Talk to a counselor or join a group therapy session"
                        ) {
                            selectedPath = .formalHelp
                        }

                        ResourceOptionCard(
                            icon: "figure.mind.and.body",
                            title: "On Campus Workshops",
                            subtitle: "Mind Body, Puppy Yoga, F45 Workout Week, and more"
                        ) {
                            selectedPath = .workshops
                        }
                    }
                    .padding(.horizontal)

                    Spacer()
                }
                .padding(.top, 30)
            }
            .navigationDestination(item: $selectedPath) { path in
                switch path {
                case .formalHelp:
                    ResourceListView(title: "Formal Help", resources: CampusResourceDatabase.formalHelp)
                case .workshops:
                    ResourceListView(title: "Workshops", resources: CampusResourceDatabase.workshops)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") { dismiss() }
                        .foregroundColor(Theme.teal)
                }
            }
        }
    }
}

struct ResourceOptionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                    .frame(width: 50, height: 50)
                    .background(Theme.teal)
                    .clipShape(RoundedRectangle(cornerRadius: 14))

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(Theme.textDark)
                    Text(subtitle)
                        .font(.caption)
                        .foregroundColor(Theme.textDark.opacity(0.6))
                        .multilineTextAlignment(.leading)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(Theme.textDark.opacity(0.4))
            }
            .padding()
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
        .buttonStyle(.plain)
    }
}

struct ResourceListView: View {
    let title: String
    let resources: [CampusResource]

    var body: some View {
        ZStack {
            Theme.background.ignoresSafeArea()
            ScrollView {
                VStack(spacing: 14) {
                    ForEach(resources) { resource in
                        VStack(alignment: .leading, spacing: 8) {
                            Text(resource.title)
                                .font(.headline)
                                .foregroundColor(Theme.textDark)
                            Text(resource.detail)
                                .font(.subheadline)
                                .foregroundColor(Theme.textDark.opacity(0.7))

                            if let phone = resource.phone {
                                Label(phone, systemImage: "phone.fill")
                                    .font(.caption)
                                    .foregroundColor(Theme.teal)
                            }
                            if let location = resource.location {
                                Label(location, systemImage: "mappin.and.ellipse")
                                    .font(.caption)
                                    .foregroundColor(Theme.teal)
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(Color.white)
                        .clipShape(RoundedRectangle(cornerRadius: 14))
                    }
                }
                .padding()
            }
        }
    }
}
