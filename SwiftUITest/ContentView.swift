//
//  ContentView.swift
//  SwiftUITest
//
//  Created by Inho Choi on 2022/10/29.
//

import SwiftUI
import UIKit

struct Card {
    var image: Image
    var originalPosition: CGFloat
    var isSelected = false
}

struct ContentView: View {
    @State var currentIndex: Int = 0
    @State var cards: [Card] = {
        var array: [Card] = []
        for i in 1..<9 {
            array.append(.init(image: Image("card\(i)"), originalPosition: CGFloat((i-1) * 56), isSelected: (i == 1)))
        }
        return array
    }()
    @State var isExpand = false
    var body: some View {
        ScrollView(showsIndicators: false) {
            ScrollViewReader { value in
                ZStack {
                    ForEach(0..<2, id: \.self) { index in
                        cards[index].image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .offset(y: calculateY(index: index))
                            .onTapGesture {
                                if index == currentIndex {
                                    withAnimation(.spring()) {
                                        if isExpand {
                                            cards[index].image = Image("card\(index + 1)")
                                        } else {
                                            cards[index].image = Image("card\(index + 1)ex")
                                        }
                                        isExpand.toggle()
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        value.scrollTo(0, anchor: .top)
                                        cards[index].isSelected = true
                                        cards[currentIndex].isSelected = false
                                        currentIndex = index
                                    }
                                }
                            }
                    }.offset(y: UIScreen.main.bounds.height / 2)
                }
                Spacer(minLength: UIScreen.main.bounds.height)
            }
        }
        .padding()
    } // body
}

extension ContentView {
    func calculateY(index : Int?) -> CGFloat {
        guard let index = index else { return .zero }
        var result = cards[index].originalPosition
        if cards[index].isSelected {
            result = .zero - UIScreen.main.bounds.height / 2
        }
        return result
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
        
        ContentView()
            .previewDevice(PreviewDevice(rawValue: "iPhone SE (3rd generation)"))
    }
}


