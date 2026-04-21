import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
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
