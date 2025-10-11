import SwiftUI

struct OverlayView: View {
    @ObservedObject var browserState: BrowserState
    @Binding var isVisible: Bool
    @State private var searchText: String = ""
    @FocusState private var isSearchFocused: Bool
    @State private var showWelcome: Bool = !UserDefaults.standard.bool(forKey: "hasSeenWelcome")

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
                    if !showWelcome {
                        withAnimation {
                            isVisible = false
                        }
                    }
                }

            if showWelcome {
                WelcomeView(isVisible: $showWelcome)
            } else {
                mainOverlayContent
            }
        }
        .onAppear {
            if !showWelcome {
                isSearchFocused = true
            }
            setupEscapeHandler()
        }
    }

    private var mainOverlayContent: some View {
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
}

struct WelcomeView: View {
    @Binding var isVisible: Bool

    var body: some View {
        VStack(spacing: 30) {
            Text("Welcome to Bowl")
                .font(.system(size: 42, weight: .thin))
                .foregroundColor(.white)

            Text("A minimal browser for developers")
                .font(.system(size: 18))
                .foregroundColor(.white.opacity(0.8))

            Divider()
                .background(Color.white.opacity(0.3))
                .frame(maxWidth: 400)
                .padding(.vertical, 10)

            VStack(alignment: .leading, spacing: 12) {
                ShortcutRow(key: "Cmd+B", description: "Toggle overlay")
                ShortcutRow(key: "Cmd+T", description: "New tab")
                ShortcutRow(key: "Cmd+N", description: "New window")
            }
            .frame(maxWidth: 400)

            VStack(spacing: 8) {
                Text("From terminal:")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(.white.opacity(0.7))

                VStack(alignment: .leading, spacing: 6) {
                    Text("bowl <url>          # Open URL")
                    Text("bowl \"search\"        # Search web")
                    Text("bowl .               # Open git repo")
                }
                .font(.system(size: 12, design: .monospaced))
                .foregroundColor(.white.opacity(0.6))
            }
            .padding(.top, 10)

            Button(action: {
                UserDefaults.standard.set(true, forKey: "hasSeenWelcome")
                withAnimation {
                    isVisible = false
                }
            }) {
                Text("Get Started")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.white)
                    .frame(width: 200, height: 44)
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(8)
            }
            .buttonStyle(.plain)
            .padding(.top, 20)
        }
        .padding(60)
    }
}

struct ShortcutRow: View {
    let key: String
    let description: String

    var body: some View {
        HStack {
            Text(key)
                .font(.system(size: 14, design: .monospaced))
                .foregroundColor(.white)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(Color.white.opacity(0.15))
                .cornerRadius(6)

            Text(description)
                .font(.system(size: 14))
                .foregroundColor(.white.opacity(0.8))

            Spacer()
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
