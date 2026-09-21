import SwiftUI
import PencilKit

struct ActiveExamView: View {
    @EnvironmentObject var viewModel: ExamFlowViewModel
    @EnvironmentObject var assessmentManager: AssessmentManager
    
    // The core drawing canvas
    @State private var canvasView = PKCanvasView()
    
    var body: some View {
        VStack(spacing: 0) {
            // Sticky Top Menu
            HStack(spacing: 20) {
                // Drawing Tools
                Button(action: { viewModel.selectTool(color: .black) }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.black)
                }
                Button(action: { viewModel.selectTool(color: .blue) }) {
                    Image(systemName: "pencil")
                        .foregroundColor(.blue)
                }
                Button(action: { viewModel.selectTool(color: nil, isLasso: true) }) {
                    Image(systemName: "lasso")
                        .foregroundColor(.primary)
                }
                Button(action: { viewModel.selectTool(color: nil, isEraser: true) }) {
                    Image(systemName: "eraser")
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                // Trailing Sub-Menu
                Button("Toggle Formula Page") {
                    // TODO: Implement formula overlay or split view
                }
                .foregroundColor(.primary)
                
                Button("Add Page") {
                    viewModel.addGridPage()
                }
                .foregroundColor(.primary)
                
                Button("Submit") {
                    viewModel.showSubmitConfirmation = true
                }
                .foregroundColor(.red)
                .fontWeight(.bold)
            }
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .shadow(radius: 2)
            
            // Exam Document Area
            ZStack {
                ScrollView {
                    VStack(spacing: 0) {
                        // PDF Placeholder
                        Rectangle()
                            .fill(Color.gray.opacity(0.1))
                            .frame(height: 1000)
                            .overlay(Text("Exam PDF Renders Here").foregroundColor(.secondary))
                        
                        // Math Grid Pages
                        ForEach(0..<viewModel.gridPageCount, id: \.self) { _ in
                            MathGridView()
                                .frame(height: 1000)
                                .border(Color.gray, width: 1)
                        }
                    }
                }
                
                // PencilKit Overlay spanning the entire scrollable area.
                ExamCanvasView(canvasView: $canvasView, currentTool: $viewModel.currentTool)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            assessmentManager.clearClipboard()
            assessmentManager.beginExamLockdown()
        }
        // Submit Confirmation Dialog
        .alert("Submit Exam", isPresented: $viewModel.showSubmitConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Yes, Submit", role: .destructive) {
                viewModel.submitExam(assessmentManager: assessmentManager)
            }
        } message: {
            Text("Are you sure you want to submit your exam? You cannot undo this action.")
        }
        // Success Overlay
        .overlay(
            Group {
                if viewModel.submissionSuccess {
                    VStack(spacing: 16) {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 80, height: 80)
                            .foregroundColor(.green)
                        Text("Exam Submitted Successfully")
                            .font(.title2)
                            .fontWeight(.semibold)
                    }
                    .padding(40)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(16)
                    .shadow(radius: 10)
                }
            }
        )
    }
}