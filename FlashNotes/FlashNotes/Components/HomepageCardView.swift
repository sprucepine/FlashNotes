import SwiftUI

struct HomepageCardView: View {
    var text: String
    var label: String
    var labelIcon: String
    var label2: String?
    var labelIcon2: String?

    var body: some View {
        ZStack {
            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5) {
                    IconTableView(outlineColor: .accentColor, backgroundColor: AnyShapeStyle(Color.accentColor.opacity(0.2).gradient), icon: "document")
                        .padding(.bottom, 10)
                    Text(text)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)

                    Label(label, systemImage: labelIcon)
                        .labelStyle(CustomLabel(spacing: 5))
                        .font(.caption)
                    if ((label2 != nil) && (labelIcon2 != nil)) {
                        Label(label2!, systemImage: labelIcon2!)
                            .labelStyle(CustomLabel(spacing: 5))
                            .font(.caption)
                    }
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding()
            .cardStyle()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}




#Preview {
    HomepageCardView(text: "Hello", label: "8/8/24", labelIcon: "clock")
}
