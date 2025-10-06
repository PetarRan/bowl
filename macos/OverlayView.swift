import SwiftUI

struct OverlayView: View {
    @ObservedObject var browserState: BrowserState
    @Binding var isVisible: Bool
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool

    private func setupEscapeHandler() {
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 53 { // ESC key
                withAnimation {
                    isVisible = false
                }
                return nil
            }
            return event
        }
    }

    var body: some View {
        ZStack {
            // Dark translucent background
            Color.black.opacity(0.85)
                .ignoresSafeArea()
                .onTapGesture {
                    withAnimation {
                        isVisible = false
                    }
                }

            VStack(spacing: 20) {
                // Header
                if let logoPath = Bundle.main.path(forResource: "bowl", ofType: "png"),
                   let nsImage = NSImage(contentsOfFile: logoPath) {
                    Image(nsImage: nsImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(height: 60)
                } else {
                    Text("bowl")
                        .font(.system(size: 32, weight: .thin))
                        .foregroundColor(.white.opacity(0.9))
                }

                // Search/URL bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.white.opacity(0.6))

                    TextField("Search or enter URL", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 18))
                        .foregroundColor(.white)
                        .focused($isSearchFocused)
                        .onSubmit {
                            if !searchText.isEmpty {
                                browserState.navigate(to: searchText)
                                searchText = ""
                                withAnimation {
                                    isVisible = false
                                }
                            }
                        }
                }
                .padding()
                .background(Color.white.opacity(0.1))
                .cornerRadius(10)
                .frame(maxWidth: 600)

                Divider()
                    .background(Color.white.opacity(0.2))
                    .frame(maxWidth: 600)

                // Tabs list
                ScrollView {
                    VStack(spacing: 8) {
                        ForEach(Array(browserState.tabs.enumerated()), id: \.element.id) { index, tab in
                            TabRow(
                                tab: tab,
                                isActive: index == browserState.activeTabIndex,
                                onTap: {
                                    browserState.switchTab(to: index)
                                    withAnimation {
                                        isVisible = false
                                    }
                                },
                                onClose: {
                                    browserState.closeTab(at: index)
                                }
                            )
                        }
                    }
                }
                .frame(maxWidth: 600, maxHeight: 400)

                // Actions
                HStack(spacing: 16) {
                    OverlayButton(icon: "plus", label: "New Tab") {
                        browserState.createTab()
                        withAnimation {
                            isVisible = false
                        }
                    }

                    OverlayButton(icon: "arrow.left", label: "Back") {
                        browserState.webView?.goBack()
                        withAnimation {
                            isVisible = false
                        }
                    }

                    OverlayButton(icon: "arrow.right", label: "Forward") {
                        browserState.webView?.goForward()
                        withAnimation {
                            isVisible = false
                        }
                    }

                    OverlayButton(icon: "arrow.clockwise", label: "Reload") {
                        browserState.webView?.reload()
                        withAnimation {
                            isVisible = false
                        }
                    }
                }

                // Hint
                Text("Press Cmd+B to close • ESC to dismiss")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .padding(.top, 8)
            }
            .padding(40)
        }
        .onAppear {
            isSearchFocused = true
            setupEscapeHandler()
        }
    }
}

struct TabRow: View {
    let tab: Tab
    let isActive: Bool
    let onTap: () -> Void
    let onClose: () -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(tab.title)
                    .font(.system(size: 14, weight: isActive ? .medium : .regular))
                    .foregroundColor(.white)
                    .lineLimit(1)

                Text(tab.url)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.6))
                    .lineLimit(1)
            }

            Spacer()

            Button(action: onClose) {
                Image(systemName: "xmark")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.6))
            }
            .buttonStyle(.plain)
            .padding(6)
            .background(Color.white.opacity(0.1))
            .cornerRadius(4)
        }
        .padding()
        .background(isActive ? Color.white.opacity(0.15) : Color.white.opacity(0.05))
        .cornerRadius(8)
        .onTapGesture(perform: onTap)
    }
}

struct OverlayButton: View {
    let icon: String
    let label: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: 20))
                Text(label)
                    .font(.system(size: 10))
            }
            .foregroundColor(.white.opacity(0.8))
            .frame(width: 80, height: 60)
            .background(Color.white.opacity(0.1))
            .cornerRadius(8)
        }
        .buttonStyle(.plain)
    }
}
