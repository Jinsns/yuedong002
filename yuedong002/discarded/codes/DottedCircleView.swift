import SwiftUI
//
//
//struct PowerGaugeStyle: GaugeStyle {
//    private var purpleGradient = LinearGradient(gradient: Gradient(colors: [ Color(red: 207/255, green: 150/255, blue: 207/255), Color(red: 107/255, green: 116/255, blue: 179/255) ]), startPoint: .trailing, endPoint: .leading)
//
//    func makeBody(configuration: Configuration) -> some View {
//        ZStack {
//
//            Circle()
//                .foregroundColor(Color(.systemGray6))
//
//            Circle()
//                .trim(from: 0, to: 0.75 * configuration.value)
//                .stroke(purpleGradient, style: StrokeStyle(lineWidth: 30, lineCap: .butt))
//                .rotationEffect(.degrees(135))
//                .shadow(radius: 5.0)
//
//
//            Circle()
//                .trim(from: 0, to: 0.75)
//                .stroke(Color.black, style: StrokeStyle(lineWidth: 10, lineCap: .butt, lineJoin: .round, dash: [1, 34], dashPhase: 0.0))
//                .rotationEffect(.degrees(135))
//
//            VStack {
//                configuration.currentValueLabel
//                    .font(.system(size: 60, weight: .bold, design: .rounded))
//                    .foregroundColor(.gray)
//                    .padding()
//                Text("赛亚人战斗力 / 单位：亿")
//                    .font(.system(.body, design: .rounded))
//                    .bold()
//                    .foregroundColor(.gray)
//            }
//        }
//    }
//}
//
//
//
//struct DottedCircleView: View {
//
//    @State private var power = 0.0
//
//    var body: some View {
//        Gauge(value: power, in: 0...100_00.0) {
//            Image(systemName: "gauge.medium")
//                .font(.system(size: 50.0))
//        } currentValueLabel: {
//            Text("\(String(format: "%0.1f", power))")
//        }
//        .gaugeStyle(PowerGaugeStyle())
//
//    }
//}

struct CircularProgressDemoView: View {
    @State private var progress = 0.0


    var body: some View {
        VStack {
            ProgressView(value: progress)
                .progressViewStyle(.circular)
        }
    }
}


struct CircularProgressDemoView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressDemoView()
    }
}
