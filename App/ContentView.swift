import SwiftUI

struct ContentView: View {
    @StateObject private var game = GameModel()
    @State private var dragStart: CGPoint?

    var body: some View {
        VStack(spacing: 20) {
            Text("Score: \(game.score)")
                .font(.title)
            boardView
            Button("New Game") {
                game.reset()
            }
        }
        .padding()
    }

    private var boardView: some View {
        GeometryReader { geo in
            let size = min(geo.size.width, geo.size.height)
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color(white: 0.8))
                VStack(spacing: 5) {
                    ForEach(0..<4, id: \.self) { row in
                        HStack(spacing: 5) {
                            ForEach(0..<4, id: \.self) { col in
                                tileView(value: game.board[row][col])
                            }
                        }
                    }
                }
                .padding(5)
            }
            .frame(width: size, height: size)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { gesture in
                        let delta = gesture.translation
                        game.handleSwipe(delta: delta)
                    }
            )
        }
        .aspectRatio(1, contentMode: .fit)
    }

    private func tileView(value: Int) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5)
                .fill(tileColor(value))
            if value > 0 {
                Text("\(value)")
                    .font(.title)
                    .bold()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func tileColor(_ value: Int) -> Color {
        switch value {
        case 2: return Color.yellow
        case 4: return Color.orange
        case 8: return Color.red
        case 16: return Color.purple
        case 32: return Color.blue
        case 64: return Color.green
        case 128: return Color.teal
        case 256: return Color.cyan
        case 512: return Color.indigo
        case 1024: return Color.mint
        case 2048: return Color.gray
        default: return Color(white: 0.9)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
