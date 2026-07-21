import SwiftUI

struct MindMattersLogoView: View {
    var size: CGFloat = 44

    var body: some View {
        Image(MindMattersAssets.logo)
            .resizable()
            .scaledToFit()
            .frame(width: size, height: size)
            .accessibilityLabel("Mind Matters")
    }
}

struct MindMattersBrandLockup: View {
    var logoSize: CGFloat = 32

    var body: some View {
        MindMattersLogoView(size: logoSize)
    }
}
