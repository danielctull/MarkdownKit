
public struct Markdown {

    public let content: [Block]

    public init(content: [Block]) {
        self.content = content
    }

    public init(string: String) throws {
        try self.init(Node(markdown: string))
    }
}

// MARK: - Equatable

extension Markdown: Equatable {}
