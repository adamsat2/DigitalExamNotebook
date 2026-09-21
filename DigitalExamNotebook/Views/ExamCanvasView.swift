//
//  ExamCanvasView.swift
//  DigitalExamNotebook
//
//  Created by Adam Stern on 21/09/2026.
//


import SwiftUI
import PencilKit

/// Integrates PencilKit with SwiftUI. 
/// Native `PKCanvasView` automatically supports "Draw to Shape" (holding the pencil at the end of a stroke) in iPadOS 14+.
struct ExamCanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    @Binding var currentTool: PKTool
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.backgroundColor = .clear
        canvasView.isOpaque = false
        canvasView.tool = currentTool
        return canvasView
    }
    
    func updateUIView(_ uiView: PKCanvasView, context: Context) {
        uiView.tool = currentTool
    }
}

/// Generates the math notebook grid background.
struct MathGridView: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                let step: CGFloat = 25.0
                
                // Vertical lines
                for x in stride(from: 0, through: geometry.size.width, by: step) {
                    path.move(to: CGPoint(x: x, y: 0))
                    path.addLine(to: CGPoint(x: x, y: geometry.size.height))
                }
                
                // Horizontal lines
                for y in stride(from: 0, through: geometry.size.height, by: step) {
                    path.move(to: CGPoint(x: 0, y: y))
                    path.addLine(to: CGPoint(x: geometry.size.width, y: y))
                }
            }
            .stroke(Color.black.opacity(0.8), lineWidth: 0.5)
        }
        .background(Color(UIColor.systemBackground))
    }
}