import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            NavigationStack {
                ProfileView()
            }
            .tabItem {
                Label(
                    NSLocalizedString("Tab.profile", comment: ""),
                    systemImage: "person.crop.circle"
                )
            }
            .backgroundStyle(.background)

            CatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "person.crop.rectangle.stack"
                    )
                }
                .backgroundStyle(.background)
        }
    }
}

#Preview {
    TabBarView()
}
