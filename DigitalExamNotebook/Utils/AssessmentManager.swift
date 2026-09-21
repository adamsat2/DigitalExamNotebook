//
//  AssessmentManager.swift
//  DigitalExamNotebook
//
//  Created by Adam Stern on 21/09/2026.
//


import Foundation
import AutomaticAssessmentConfiguration
import UIKit

/// Manages device locking and environment restrictions during an exam.
@MainActor
final class AssessmentManager: ObservableObject {
    private var assessmentSession: AEAssessmentSession?
    
    /// Clears the clipboard to prevent pasting external content.
    func clearClipboard() {
        UIPasteboard.general.items.removeAll()
    }
    
    /// Locks the iPad into Assessment Mode (Single App Mode specifically designed for exams).
    func beginExamLockdown() {
        let configuration = AEAssessmentConfiguration()
        // Configuration flags can be added here (e.g., enabling dictation, autocorrect restrictions)
        
        let session = AEAssessmentSession(configuration: configuration)
        self.assessmentSession = session
        
        session.begin { error in
            if let error = error {
                print("Failed to begin assessment session: \(error.localizedDescription)")
                // Handle error: possibly block exam entry if lockdown fails
            }
        }
    }
    
    /// Releases the device from Assessment Mode.
    func endExamLockdown() {
        assessmentSession?.end { error in
            if let error = error {
                print("Failed to end assessment session: \(error.localizedDescription)")
            }
        }
    }
}