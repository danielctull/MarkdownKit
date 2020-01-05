
import Foundation

public struct Markdown {

    public let content: [Block]

    public init(content: [Block]) {
        self.content = content
    }
}

extension Markdown: Equatable {}
