import SwiftUI
import UIKit

extension UIFont {
    
    // Headline Fonts
    static var headline1 = UIFont.systemFont(ofSize: 34, weight: .bold)
    static var headline2 = UIFont.systemFont(ofSize: 28, weight: .bold)
    static var headline3 = UIFont.systemFont(ofSize: 22, weight: .bold)
    static var headline4 = UIFont.systemFont(ofSize: 20, weight: .bold)

    // Body Fonts
    static var bodyRegular = UIFont.systemFont(ofSize: 17, weight: .regular)
    static var bodyBold = UIFont.systemFont(ofSize: 17, weight: .bold)
    static var bodySemiboldBold = UIFont.systemFont(ofSize: 17, weight: .semibold)

    // Caption Fonts
    static var caption1 = UIFont.systemFont(ofSize: 15, weight: .regular)
    static var caption2 = UIFont.systemFont(ofSize: 13, weight: .regular)
    static var caption1Semibold = UIFont.systemFont(ofSize: 14, weight: .semibold)
    static var caption3Bold = UIFont.systemFont(ofSize: 12, weight: .bold)
}

private extension UIFont {
    var swiftUIFont: Font { Font(self) }
}

extension Font {
    static var dsHeadline1: Font { UIFont.headline1.swiftUIFont }
    static var dsHeadline3: Font { UIFont.headline3.swiftUIFont }
    static var dsBodyRegular: Font { UIFont.bodyRegular.swiftUIFont }
    static var dsBodyBold: Font { UIFont.bodyBold.swiftUIFont }
    static var dsBodySemibold: Font { UIFont.bodySemiboldBold.swiftUIFont }
    static var dsCaption1: Font { UIFont.caption1.swiftUIFont }
    static var dsCaption2: Font { UIFont.caption2.swiftUIFont }
    static var dsCaption1Semibold: Font { UIFont.caption1Semibold.swiftUIFont }
    static var dsCaption3Bold: Font { UIFont.caption3Bold.swiftUIFont }
}
