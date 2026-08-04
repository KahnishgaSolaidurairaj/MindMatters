import SwiftUI

struct ResourcesHubView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("University of Illinois at Chicago")
                    .font(Theme.bodyText)
                    .foregroundColor(Theme.textDark.opacity(0.75))

                VStack(spacing: 16) {
                    NavigationLink {
                        ResourceListView(
                            title: "Formal Help",
                            resources: CampusResourceDatabase.formalHelp
                        )
                    } label: {
                        ResourceOptionCardLabel(
                            icon: "person.fill.checkmark",
                            title: "Formal Help",
                            subtitle: "Talk to a counselor or join a group therapy session"
                        )
                    }

                    NavigationLink {
                        ResourceListView(
                            title: "Workshops",
                            resources: CampusResourceDatabase.workshops
                        )
                    } label: {
                        ResourceOptionCardLabel(
                            icon: "figure.mind.and.body",
                            title: "On Campus Workshops",
                            subtitle: "Mind Body, Puppy Yoga, F45 Workout Week, and more"
                        )
                    }
                }
                .padding(.horizontal)
            }
            .padding(.top, 8)
            .padding(.bottom, 24)
        }
    }
}

struct ResourceOptionCardLabel: View {
    let icon: String
    let title: String
    let subtitle: String

    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 50, height: 50)
                .background(Theme.teal)
                .clipShape(RoundedRectangle(cornerRadius: 14))

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Theme.rowTitle)
                    .foregroundColor(Theme.textDark)
                    .wrapping()
                Text(subtitle)
                    .font(Theme.bodyText)
                    .foregroundColor(Theme.textDark.opacity(0.75))
                    .wrapping()
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            Image(systemName: "chevron.right")
                .foregroundColor(Theme.textDark.opacity(0.4))
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .contentShape(RoundedRectangle(cornerRadius: 16))
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
                                .font(Theme.rowTitle)
                                .foregroundColor(Theme.textDark)
                                .wrapping()
                            Text(resource.detail)
                                .font(Theme.bodyText)
                                .foregroundColor(Theme.textDark.opacity(0.75))
                                .wrapping()

                            if let phone = resource.phone {
                                Label(phone, systemImage: "phone.fill")
                                    .font(Theme.bodyText)
                                    .foregroundColor(Theme.teal)
                            }
                            if let location = resource.location {
                                if let mapsQuery = resource.mapsDirectionsQuery,
                                   let mapsURL = MapsDirectionsLink.url(for: mapsQuery) {
                                    Link(destination: mapsURL) {
                                        Label(location, systemImage: "mappin.and.ellipse")
                                            .font(Theme.bodyText)
                                            .foregroundColor(Theme.teal)
                                            .underline()
                                    }
                                } else {
                                    Label(location, systemImage: "mappin.and.ellipse")
                                        .font(Theme.bodyText)
                                        .foregroundColor(Theme.teal)
                                }
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
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

/// Builds Apple Maps directions URLs for campus resource addresses.
enum MapsDirectionsLink {
    /// Returns an Apple Maps URL that opens directions to the given address query.
    static func url(for addressQuery: String) -> URL? {
        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [URLQueryItem(name: "daddr", value: addressQuery)]
        return components?.url
    }
}
