
public struct Markdown {

    public let content: [Block]

    public init(content: [Block]) {
        self.content = content
    }
}

// MARK: - Equatable

extension Markdown: Equatable {}
