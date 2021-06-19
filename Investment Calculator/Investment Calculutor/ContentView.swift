//
//  ContentView.swift
//  Investment Calculutor
//
//  Created by Matthew Smith on 14/02/2021.
//
import SwiftUI

struct ContentView: View {
    
    // input variables
    @State private var initialDeposit = ""
    @State private var interestRate = ""
    @State private var monthlyAdditions = ""
    @State public var years = ""
    
    // output variables
    @State private var futureValue = ""
    @State private var totalInterest = ""
    @State private var totalDeposits = ""
    
    // initialised variables
    @State private var flag = false
    @State private var showingAlert = false
    
    @State public var chartWidth = 0.0
    @State public var data: [Point] = []
    @State public var data2: [Point] = []
    
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack(alignment: .leading, spacing: 20){
                    Text("Calculator")
                        .modifier(Title())
                    
                    VStack(spacing: 15){
                        
                        HStack{
                            VStack(alignment: .leading, spacing: 4){
                                Text("Initial Deposit")
                                    .modifier(inputText())
                                TextField("$0.00", text: $initialDeposit)
                                    .frame(height: 45)
                                    .modifier(inputTextField())
                            }
                            VStack(alignment: .leading, spacing: 4){
                                Text("Interest Rate %")
                                    .modifier(inputText())
                                TextField("0%", text: $interestRate)
                                    .frame(height: 45)
                                    .modifier(inputTextField())
                            }
                        }
                        HStack{
                            VStack(alignment: .leading, spacing: 4){
                                Text("Monthly Addition")
                                    .modifier(inputText())
                                TextField("$0.00", text: $monthlyAdditions)
                                    .frame(height: 45)
                                    .modifier(inputTextField())
                            }
                            VStack(alignment: .leading, spacing: 4){
                                Text("Years")
                                    .modifier(inputText())
                                TextField("0", text: $years)
                                    .frame(height: 45)
                                    .modifier(inputTextField())
                            }
                        }
                        
                        Button(
                            action:{
                                
                                // input validation statement
                                if (interestRate != "" && interestRate != "0") && (years != "" && years != "0") && ((initialDeposit != "" && initialDeposit != "0") || (monthlyAdditions != "" && monthlyAdditions != "0")){
                                    
                                    data.removeAll()
                                    data2.removeAll()
                                    
                                    flag = true
                                    
                                    let result = calculateButton(deposit: initialDeposit, intRate: interestRate, monthAdd: monthlyAdditions, year: years)
                                    
                                    self.futureValue = result.futureVal
                                    self.totalInterest = result.interestEarned
                                    self.totalDeposits = result.totalDeposits
                                    self.chartWidth = result.chartCalc
                                    
                                    createGraph(deposit: initialDeposit, intRate: interestRate, monthAdd: monthlyAdditions, year: years)
                                    self.endEditing(true)
                                }
                                else {
                                    showingAlert = true
                                }
                            },
                            label:{
                            Text("Calculate")
                                .modifier(ButtonFormat())
                        })
                    }
                    .frame(maxWidth: .infinity, maxHeight: 210, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                    .padding(.bottom, 3)
                    .modifier(ContainerStack())
                    
                    .alert(isPresented: $showingAlert) {
                        Alert(title: Text("Missing Information"), message: Text("Please make sure appropriate input values have been entered."), dismissButton: .default(Text("Got it!")))
                    }
                    
                    
                    VStack(alignment: .center, spacing: 10){
                        VStack(alignment: .leading){
                            
                            VStack{
                                Text("Future Value")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(Color.gray)
                                    .offset(y: -5)
                                TextField("$0.00", text: $futureValue)
                                    .font(.system(size: 27, weight: .semibold))
                                    .foregroundColor(Color("MainText"))
                                    .multilineTextAlignment(.center)
                                    .offset(y: -10)
                                    .disabled(true)
                                
                            }.frame(maxWidth: .infinity, maxHeight: 40, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                            .padding(.all, 10)
                            
                            HStack(alignment: .center){
                                BarView(value: CGFloat(chartWidth))
                            }
                            
                            HStack{
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .background(Circle().foregroundColor(Color("ProfitColor")))
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Text("Interest Earned")
                                    .modifier(inputText())
                                
                                Spacer()
                                
                                TextField("$0.00", text: $totalInterest)
                                    .modifier(outputText())
                                    .disabled(true)
                            }
                            
                            HStack{
                                Circle()
                                    .strokeBorder(Color.white, lineWidth: 4)
                                    .background(Circle().foregroundColor(Color.blue))
                                    .frame(width: 25, height: 25, alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/)
                                Text("Total Deposits")
                                    .modifier(inputText())
                                
                                Spacer()
                                
                                TextField("$0.00", text: $totalDeposits)
                                    .modifier(outputText())
                                    .disabled(true)
                            }
                            
                            VStack(alignment: .center){
                                
                                if flag {
                                    Path { path in
                                        path.move(to: .init(x: 0, y: 0))
                                        path.addLine(to: .init(x: geometry.size.width / 1.2, y: 0))
                                    }
                                    .stroke(Color("LightGray2"), style: StrokeStyle(lineWidth: 1.5))
                                    .padding(.top, 20)
                                }
                                if flag {
                                    ChartView(data: data2, data2: data, years: years, total: futureValue)
                                        .modifier(GraphStack())
                                }
                            }
                        }.modifier(ContainerStack())
                        .animation(.easeInOut(duration: 1))
                        Spacer()
   
                    }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }.padding()
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .topLeading)
            }
        }.background(Color("BackgroundColor").edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/))
        .onTapGesture {
            self.endEditing(true)
        }
    }
    func createGraph(deposit: String, intRate: String, monthAdd: String, year: String) {
        
        let P = Double(deposit) ?? 0.0
        let r = ((Double(intRate) ?? 0.0)/100)/12
        let t = (Double(year) ?? 0.0)*12
        let M = Double(monthAdd) ?? 0.0
        let f = Int(t/12)
        
        for val in 1...f {
            
            let val2 = val*12
            let endSum = (M * ((pow(r + 1, Double(val2)) - 1) / r))
            let endSum2 = endSum + (P * (pow((1 + r), Double(val2))))
            let endDeposits = P + (M * Double(val2))
            
            let yearF = CGFloat(val)
            let sumF = CGFloat(endSum2)
            let depoF = CGFloat(endDeposits)
            
            data2.append(Point(x: yearF, y: sumF))
            data.append(Point(x: yearF, y: depoF))
        }
    }
}

func calculateButton(deposit: String, intRate: String, monthAdd: String, year: String) ->
                    (futureVal: String, interestEarned: String, totalDeposits: String, chartCalc: Double) {
    
    let P = Double(deposit) ?? 0.0
    let r = ((Double(intRate) ?? 0.0)/100)/12
    let t = (Double(year) ?? 0.0)*12
    let M = Double(monthAdd) ?? 0.0
    
    let endSum = (M * ((pow(r + 1, t) - 1) / r)) + (P * (pow((1 + r), t)))
    let endDeposits = P + (M * t)
    let endInterest = endSum - endDeposits
    
    let result1 = NumberFormatter.localizedString(from: NSNumber(value: (round(endSum*100))/100.0), number: .currency)
    let result2 = NumberFormatter.localizedString(from: NSNumber(value: (round(endInterest*100))/100.0), number: .currency)
    let result3 = NumberFormatter.localizedString(from: NSNumber(value: (round(endDeposits*100))/100.0), number: .currency)
    let result4 = endInterest / endSum

    return (result1, result2, result3, result4)
}


struct Title: ViewModifier {
    func body(content: Content) -> some View {
        content
            .foregroundColor(Color("MainText"))
            .font(.system(size: 40, weight: .semibold))
    }
}

struct ButtonFormat: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .font(.system(size: 23, weight: .semibold))
            .foregroundColor(.white)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 65, alignment: .center)
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .shadow(color: Color("ContainerShadow"), radius: 5, x: 2, y: 2)
            )
    }
}

struct ContainerStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.white)
                    .shadow(color: Color("ContainerShadow"), radius: 5, x: 1, y: 1)
        )
    }
}

struct inputText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(Color("InputText"))
            .padding(.leading, 5)
    }
}

struct inputTextField: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 18, weight: .bold))
            .keyboardType(.decimalPad)
            .padding(.leading)
            .background(
                RoundedRectangle(cornerRadius: 7.5)
                    .fill(Color("TextFieldBackground"))
            )
            
    }
}

struct BarView: View{
    var value: CGFloat
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment: .leading) {
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.blue)
                    .frame(width: geometry.size.width / 1, height: 20)

                RoundedRectangle(cornerRadius: 15)
                    .frame(width: geometry.size.width / (1/(value)), height: 20)
                    .foregroundColor(Color("ProfitColor"))
                    .animation(.easeInOut(duration: 1))
            }
        }.frame(height: 30)
    }
}


struct outputText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(size: 16, weight: .semibold))
            .foregroundColor(Color("MainText"))
            .padding(.leading, 5)
            .multilineTextAlignment(.trailing)
    }
}

struct Point {
    let x: CGFloat
    let y: CGFloat
}

// graph view modifier
struct ChartView: View {
    
    @State private var isPresented: Bool = false
    
    let data: [Point]
    let data2: [Point]
    let years: String
    let total: String
    
    private var maxYValue: CGFloat {
        data.max { $0.y < $1.y }?.y ?? 0
    }
    private var maxXValue: CGFloat {
        data.max { $0.x < $1.x }?.x ?? 0
    }
      
    var body: some View {
        ZStack {
            chartBody
            chartBody2
            dataView
        }
    }
    // profit graph line
    private var chartBody: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: geometry.size.height))
                
                self.data.forEach { point in
                    let x = (point.x / self.maxXValue) * geometry.size.width
                    let y = geometry.size.height - (point.y / self.maxYValue) * geometry.size.height
                    path.addLine(to: .init(x: x, y: y))
                }
            }
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color("ProfitColor"),
                style: StrokeStyle(lineWidth: 5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.7))
        }
        .onAppear {
            self.isPresented = true
        }
    }
    // deposit graph line
    private var chartBody2: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: geometry.size.height))
                
                self.data2.forEach { point in
                    let x = (point.x / self.maxXValue) * geometry.size.width
                    let y = geometry.size.height - (point.y / self.maxYValue) * geometry.size.height
                    path.addLine(to: .init(x: x, y: y))
                }
            }
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color.blue,
                style: StrokeStyle(lineWidth: 5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.5))
        }
        .onAppear {
            self.isPresented = true
        }
    }
    // data display line
    private var dataView: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: .init(x: 0, y: -3))
                path.addLine(to: .init(x: 0, y: geometry.size.height))
                
                path.move(to: .init(x: 0, y: geometry.size.height ))
                path.addLine(to: .init(x: geometry.size.width, y: geometry.size.height))
            }
            .offset(y: 2)
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color("LightGray"),
                style: StrokeStyle(lineWidth: 2.5)
            )
            .animation(Animation.easeInOut(duration: 1).delay(0.2))
  
            Text("0")
                .offset(x: -10, y: 187.5)
                .modifier(outputText())
            
            Text(years)
                .offset(x: (geometry.size.width)-10, y: 187.5)
                .modifier(outputText())
            
            Path { path in
                path.move(to: .init(x: 0, y: 0 ))
                path.addLine(to: .init(x: geometry.size.width, y: 0))
            }
            .trim(from: 0, to: self.isPresented ? 1 : 0)
            .stroke(
                Color("ProfitColorLow"),
                style: StrokeStyle(lineWidth: 2.5, dash: [5])
            )
            .animation(Animation.easeInOut(duration: 1).delay(1))
            
            Text(total)
                .modifier(outputText())
                .padding(.trailing,5)
                .background(Color.white)
                .offset(x: 1, y: -10)
        }
        .onAppear {
            self.isPresented = true
        }
    }
}


struct GraphStack: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 180)
            .padding()
            .padding(.bottom,30)
            .background(
                RoundedRectangle(cornerRadius: 5)
                    .fill(Color.white)
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ContentView()
                .previewDevice("iPhone SE (2nd generation)")
        }
    }
}

extension View {
        func endEditing(_ force: Bool) {
            UIApplication.shared.windows.forEach { $0.endEditing(force)}
        }
}

