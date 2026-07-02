//
//  CardContainer.swift
//  TruckMaster
//
//  Created by AuthentiCode on 10/06/26.
//

internal import SwiftUI


struct CardContainer<Content: View>: View {

    let cornerRadius: CGFloat
    let backgroundColor: Color
    let height: CGFloat?
    let content: () -> Content

    init(
        cornerRadius: CGFloat = 16,
        backgroundColor: Color = .white,
        height: CGFloat? = nil,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius = cornerRadius
        self.backgroundColor = backgroundColor
        self.height = height
        self.content = content
    }

    var body: some View {
        content()
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
    }
}

struct ElevatedCardContainer<Content: View>: View {

    let cornerRadius:    CGFloat
    let backgroundColor: Color
    let height:          CGFloat?
    let shadowColor:     Color
    let shadowRadius:    CGFloat
    let shadowX:         CGFloat
    let shadowY:         CGFloat
    let borderColor:     Color
    let borderWidth:     CGFloat
    let content:         () -> Content

    init(
        cornerRadius:    CGFloat = 16,
        backgroundColor: Color = .white,
        height:          CGFloat? = nil,
        shadowColor:     Color = .black.opacity(0.06),
        shadowRadius:    CGFloat = 1,
        shadowX:         CGFloat = 0,
        shadowY:         CGFloat = 1,
        borderColor:     Color = .black.opacity(0.08),
        borderWidth:     CGFloat = 1,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.cornerRadius    = cornerRadius
        self.backgroundColor = backgroundColor
        self.height          = height
        self.shadowColor     = shadowColor
        self.shadowRadius    = shadowRadius
        self.shadowX         = shadowX
        self.shadowY         = shadowY
        self.borderColor     = borderColor
        self.borderWidth     = borderWidth
        self.content         = content
    }

    var body: some View {
        content()
            .frame(maxWidth: .infinity)
            .frame(height: height)
            .background(backgroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(borderColor, lineWidth: borderWidth)
            )
            .shadow(
                color:  shadowColor,
                radius: shadowRadius,
                x:      shadowX,
                y:      shadowY
            )
    }
}


//Usage



//// Fixed height
//CardContainer(cornerRadius: 12, backgroundColor: .white, height: 120) {
//    Text("Fixed Height Card")
//}
//
//// Content size height
//CardContainer(cornerRadius: 12, backgroundColor: .white) {
//    VStack {
//        Text("Line 1")
//        Text("Line 2")
//    }
//    .padding()
//}
//
//// Custom background
//CardContainer(cornerRadius: 20, backgroundColor: Color("PrimaryColor"), height: 80) {
//    Text("Colored Card")
//        .foregroundColor(.white)
//}



