import SwiftUI

enum Theme {
    static let background = Color(red: 0.925, green: 0.909, blue: 0.851)
    static let sage = Color(red: 0.588, green: 0.678, blue: 0.616)
    static let teal = Color(red: 0.431, green: 0.596, blue: 0.627)
    static let cardWhite = Color.white
    static let textDark = Color(red: 0.16, green: 0.2, blue: 0.2)

    static var pageTitle: Font { .largeTitle.weight(.bold) }
    static var sectionTitle: Font { .title2.weight(.bold) }
    static var rowTitle: Font { .title3.weight(.semibold) }
    static var bodyText: Font { .body }
    static var supportingText: Font { .body }
    static var linkText: Font { .body.weight(.medium) }
    static var buttonText: Font { .headline }
}
