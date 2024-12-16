import Foundation
import SwiftUI

final class LanguageColorService {
    static func colorForLanguage(_ language: String) -> Color {
        let colors: [String: Color] = [
            "Swift": Color.orange,
            "JavaScript": Color.yellow,
            "Python": Color.blue,
            "Java": Color.brown,
            "Kotlin": Color.purple,
            "Ruby": Color.red,
            "Go": Color.cyan,
            "C++": Color.green,
            "C#": Color.indigo,
            "PHP": Color.purple,
            "TypeScript": Color.blue,
            "HTML": Color.red
        ]
        
        return colors[language] ?? Color.gray
    }
}
