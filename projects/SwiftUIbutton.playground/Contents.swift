import SwiftUI

var greeting = "Hello, playground"


struct ButtonTest: View {
    var body: some View {
        Button(action: {
            print("Kungu: ksjdnf")
        }) {
            VStack(spacing: DesignTokens.Spacing.extraSmall) {
                Image(systemName: "xmark")
                    .scaledToFill()
                
                Text("Click Here")
                    .font(DesignTokens.Typography.buttonLabel)
                    .multilineTextAlignment(.center)
            }
            .frame(width: DesignTokens.Sizes.FlexButton.width - DesignTokens.Spacing.extraSmall)
            .padding(.vertical, DesignTokens.Spacing.small)
        }
    }
}

#Preview {
    ButtonTest()
}
