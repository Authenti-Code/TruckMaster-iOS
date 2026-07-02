internal import SwiftUI

@available(iOS 16.0, *)
struct MainTabView: View {

    let container: AppContainer
    @State private var selectedTab: Tab = .home

    @State private var previousTab: Tab = .home

    enum Tab {
        case home, orders, settings
    }

    var body: some View {
        ZStack(alignment: .bottom) {

            // MARK: - Screen Content
            Group {
                switch selectedTab {
                case .home:     container.makeHomeView()
                case .orders:   container.makeOrdersView()
                case .settings: container.makeSettingsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
          
            // MARK: - Tab Bar
                     HStack(spacing: 5) {

                         TabBarButton(
                             title: "Home",
                             selectedIcon: ImageConstants.homeSelected,
                             unselectedIcon: ImageConstants.homeUnSelected,
                             isSelected: selectedTab == .home
                         ) {  previousTab = selectedTab
                             withAnimation(.easeInOut(duration: 0.3)) {
                                 selectedTab = .home
                             }
                         }
                              
                         TabBarButton(
                             title: "Orders",
                             selectedIcon: ImageConstants.ordersSelected,
                             unselectedIcon: ImageConstants.ordersUnSelected,
                             isSelected: selectedTab == .orders
                         ) {
                             previousTab = selectedTab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = .orders
                                }
                         }
                             
                         TabBarButton(
                             title: "Setting",
                             selectedIcon: ImageConstants.settingsSelected,
                             unselectedIcon: ImageConstants.settingsUnSelected,
                             isSelected: selectedTab == .settings
                         ) {
                             previousTab = selectedTab
                                withAnimation(.easeInOut(duration: 0.3)) {
                                    selectedTab = .settings
                                }
                         }
                         
                     }
                     .frame(width: 250)
                     .frame(height: 67)
                     .background(Color.white)
                     .clipShape(RoundedRectangle(cornerRadius: 32))
                     .overlay(
                         RoundedRectangle(cornerRadius: 32)
                             .stroke(Color.black.opacity(0.08), lineWidth: 1)
                     )
                     .shadow(color: .black.opacity(0.04), radius: 6, x: 0, y: 2)
//                     .padding(.horizontal, 60)
                     .padding(.bottom, max(getSafeAreaBottom(), 16))

                 }
        .ignoresSafeArea(edges: .bottom)
    }
}

// MARK: - Tab Bar Button
@available(iOS 16.0, *)
private struct TabBarButton: View {

    let title: String
    let selectedIcon: String
    let unselectedIcon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(isSelected ? selectedIcon : unselectedIcon)
                    .resizable()
                    .scaledToFit()
                    .frame(
                        width: isSelected ? 100 : 50,
                        height: isSelected ? 100 : 50
                    )
                    
            }
            
            .frame(maxWidth: .infinity)
            .padding(.vertical, 10)
            .padding(.horizontal, isSelected ? 14 : 0)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Safe Area
private func getSafeAreaBottom() -> CGFloat {
    UIApplication.shared
        .connectedScenes
        .compactMap { $0 as? UIWindowScene }
        .first?
        .windows
        .first?
        .safeAreaInsets
        .bottom ?? 0
}


@available(iOS 16.0, *)
extension MainTabView.Tab: Comparable {
    static func < (lhs: MainTabView.Tab, rhs: MainTabView.Tab) -> Bool {
        let order: [MainTabView.Tab] = [.home, .orders, .settings]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
