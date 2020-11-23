//
//  CardView.swift
//  Moose
//
//  Created by Samuel Brasileiro on 19/11/20.
//

import SwiftUI

struct SlideOverView<Content> : View where Content : View {
    
    @ObservedObject var bank: PaintingsBank
    var content: () -> Content
    
    public var body: some View {
        ModifiedContent(content: self.content(), modifier: CardView(bank: bank))
    }
}


struct CardView: ViewModifier {
    @State private var dragging = false
    @GestureState private var dragTracker: CGSize = CGSize.zero
    
    @ObservedObject var bank: PaintingsBank
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            ZStack(alignment: .top) {
                RoundedRectangle(cornerRadius: 2.5)
                    .frame(width: 40, height: 5.0)
                    .foregroundColor(Color(.systemGray5))
                    .padding(10)
                content.padding(.top, 30)
            }
            .frame(minWidth: UIScreen.main.bounds.width)
            .scaleEffect(x: 1, y: 1, anchor: .center)
            .background(Color(.systemGray6))
            .cornerRadius(15)
        }
        .offset(y:  max(0, bank.cardPosition + self.dragTracker.height))
        .animation(dragging ? nil : {
            Animation.interpolatingSpring(stiffness: 250.0, damping: 40.0, initialVelocity: 5.0)
        }())
        .gesture(DragGesture()
                    .updating($dragTracker) { drag, state, transaction in state = drag.translation }
                    .onChanged {_ in  dragging = true }
                    .onEnded(onDragEnded))
    }
    
    private func onDragEnded(drag: DragGesture.Value) {
        dragging = false
        let high = UIScreen.main.bounds.height - 120
        let low: CGFloat = 100
        let dragDirection = drag.predictedEndLocation.y - drag.location.y
        //can also calculate drag offset to make it more rigid to shrink and expand
        if dragDirection > 0 {
            bank.cardPosition = high
            bank.isCardOpen = false
        } else {
            bank.cardPosition = low
            bank.isCardOpen = true
        }
    }
}

