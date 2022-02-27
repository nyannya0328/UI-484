//
//  Home.swift
//  UI-484
//
//  Created by nyannyan0328 on 2022/02/27.
//

import SwiftUI

struct Home: View {
    
    @State var expandCard : Bool = false
    
    @State var currentCard : Card?
    @State var showDetailCard : Bool = false
    @Namespace var animation
    var body: some View {
        VStack(spacing:0){
            
            
            Text("Wallet")
                .font(.largeTitle.weight(.bold))
                .foregroundColor(.black)
                .frame(maxWidth:.infinity,alignment: expandCard ? .leading :  .center)
                .overlay(alignment: .trailing) {
                    
                    Button {
                        withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 1, blendDuration: 1)){
                            
                            
                            expandCard = false
                        }
                    } label: {
                        
                        Image(systemName: "plus")
                            .font(.title2)
                            .padding()
                            .foregroundColor(.orange)
                            .background(.black,in: Circle())
                    }
                    .rotationEffect(.init(degrees: expandCard ? 45 : 0))
                    .offset(x: expandCard ? 10 : 15)

                }
                .padding(.horizontal,15)
                .padding(.bottom,10)
            
            
            ScrollView(.vertical, showsIndicators: false) {
                
                
                VStack(spacing:20){
                    
                    
                    ForEach(cards){card in
                        
                        
                        Group{
                            if currentCard?.id == card.id && showDetailCard{
                                
                                
                                cardView(card: card)
                                    .opacity(0)
                            }
                            else{
                                
                                cardView(card: card)
                                    .matchedGeometryEffect(id: card.id, in: animation)
                            }
                        }
                        .onTapGesture {
                            
                            
                            withAnimation(.easeInOut(duration: 0.3)){
                                
                                
                                currentCard = card
                                showDetailCard = true
                            }
                        }
                     
                          
                    }
                  
                    
                    
                }
               
                .overlay{
                    
                    
                    
                    Rectangle()
                        .fill(.black.opacity( expandCard ? 0 : 0.01))
                        .onTapGesture {
                            
                            
                            withAnimation(.easeInOut(duration: 0.35)){
                                
                                expandCard = true
                            }
                        }
                
                        
                }
                .padding(.top,expandCard ? 30 : 0)
                
                
                
            }
            .coordinateSpace(name: "SCROLL")
            .offset(y: expandCard ? 0 : 30)
            
            
            
            Button {
                
            } label: {
                
                
                Image(systemName: "plus")
                    .font(.title2)
                    .padding()
                    .foregroundColor(.orange)
                    .background(.black,in: Circle())
                
                
            }
            .rotationEffect(.init(degrees: expandCard ? 180 : 0))
            .scaleEffect(expandCard ? 0.01 : 1)
            .opacity(!expandCard ? 1  : 0)
            .frame(height: expandCard ? 0 : nil)
            .padding(.bottom,expandCard ? 0 : 30)

            
            
            
        }
        .padding([.horizontal,.bottom])
        .frame(maxWidth:.infinity,maxHeight: .infinity)
        .overlay {
            
            
            if let currentCard = currentCard,showDetailCard {
                
                
                DetailView(currentCard: currentCard, showDetail: $showDetailCard, animation: animation)
                
                
            }
        }
    }
    
    @ViewBuilder
    func cardView(card : Card)->some View{
        

        
        GeometryReader{proxy in
            
            let rect = proxy.frame(in: .named("SCROLL"))
            
            let offset = CGFloat(getIndex(card: card) * (expandCard ? 10 : 70))
            
            ZStack(alignment: .bottomLeading) {
                
                Image(card.cardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    
                    Text(card.name)
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                    
                    Text(CustomCardNumber(number:card.cardNumber))
                        .font(.callout.weight(.semibold))
                    
                    
                    
                }
                .padding()
                .padding(.bottom,10)
                .foregroundColor(.white)
                
                
        
                
                
            }
            .offset(y: expandCard ? offset : -rect.minY + offset)
          
            
        }
        .frame(height: 200)
    }
            
            func getIndex(card : Card) -> Int{
                
                
                return cards.firstIndex { currentCard in
                    card.id == currentCard.id
                } ?? 0
            }
            
         
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

func CustomCardNumber(number : String) -> String{
    
    var newValue : String = ""
    
    
    let maxCount = number.count - 4
    
    number.enumerated().forEach { value in
        
        
        if value.offset >= maxCount{
            
            
            let string = String(value.element)
            
            newValue.append(contentsOf: string)
            
            
        }
        
        else{
            
            let string = String(value.element)
            
            if string == " "{
                
                newValue.append(contentsOf: " ")
                
            }
            
            else{
                
                newValue.append(contentsOf: "*")
            }
        }
    }
    
    
    return newValue
    
    
    
}


struct DetailView : View{
    
    var currentCard : Card
    @Binding var showDetail : Bool
    
    var animation : Namespace.ID
    
    @State var showExpanseView : Bool = false
    
    
    var body: some View{
        
        VStack{
            
            cardView(card: currentCard)
                .matchedGeometryEffect(id: currentCard.id, in: animation)
                .frame(height: 200)
                .onTapGesture {
                    
                    
                    withAnimation(.easeInOut){
                        
                        
                        showExpanseView = false
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                        
                        withAnimation(.easeInOut(duration: 0.3)){
                            
                            showDetail = false
                        }
                        
                    }
                }
                .padding(.top)
                .zIndex(10)
            
            
            GeometryReader{proxy in
                
                let height = proxy.size.height + 50
                
                
                ScrollView(.vertical, showsIndicators: false) {
                    
                    
                    VStack(spacing:20){
                        
                        
                        ForEach(expenses){exp in
                            
                            ExpacneView(expance: exp)
                            
                            
                            
                        }
                    }
                    .padding()
                }
                .background(
                
                    Color.white
                        .clipShape(RoundedRectangle(cornerRadius: 25))
                        .ignoresSafeArea()
                )
                .padding([.horizontal,.top])
                .zIndex(-100)
                
            }
            
            
            
            
            
            
        }
        .padding()
        .frame(maxWidth:.infinity,maxHeight: .infinity,alignment: .top)
        .background(Color("BG"))
    }
    
    @ViewBuilder
    func cardView(card : Card)->some View{
        

        
        GeometryReader{proxy in
       
            
            ZStack(alignment: .bottomTrailing) {
                
                Image(card.cardImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                
                
                VStack(alignment: .leading, spacing: 15) {
                    
                    
                    
                    Text(card.name)
                        .font(.title3.weight(.bold))
                        .foregroundColor(.white)
                    
                    Text(CustomCardNumber(number:card.cardNumber))
                        .font(.callout.weight(.semibold))
                    
                    
                    
                }
                .padding()
                .padding(.bottom,10)
                .foregroundColor(.white)
                
                
        
                
                
            }
           
          
            
        }
        .frame(height: 200)
    }
    
    
}

struct ExpacneView : View{
    
    var expance : Expense
    
    @State var showView : Bool = false
    var body: some View{
        
        HStack{
            
            Image(expance.productIcon)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 50, height: 50)
            
            
            VStack(alignment: .leading, spacing: 13) {
                
                
                Text(expance.product)
                    .fontWeight(.bold)
                
                
                Text(expance.spendType)
                    .font(.callout)
                    .foregroundColor(.gray)
            }
            .frame(maxWidth:.infinity,alignment: .leading)
            
            
            VStack(spacing:10){
                
                Text(expance.amountSpent)
                    .fontWeight(.bold)
                
                
                Text(Date().formatted(date: .numeric, time: .omitted))
                    .font(.callout)
                    .foregroundColor(.gray)
                
            }
            
            
        }
        .opacity(showView ? 1 : 0)
        .offset(y: showView ? 0 : 20)
        .onAppear {
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                
                withAnimation(.easeInOut(duration: 0.3).delay(Double(getIndex()) * 0.2)){
                    
                    showView = true
                }
                
            }
        }
    }
    func getIndex()->Int{
        
        return expenses.firstIndex { index in
            
            
            return expance.id == index.id
        } ?? 0
    }
}



