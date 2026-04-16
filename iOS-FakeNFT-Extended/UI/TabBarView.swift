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

            TestCatalogView()
                .tabItem {
                    Label(
                        NSLocalizedString("Tab.catalog", comment: ""),
                        systemImage: "square.stack.3d.up.fill"
                    )
                }
                .backgroundStyle(.background)
        }
    }
}
