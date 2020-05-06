
/// The markdown document.
public struct Markdown {

    /// The array of content blocks in this document.
    public let content: [Block]

    /// Creates a markdown document from an array of content blocks.
    ///
    /// - Parameter content: The array of content blocks.
    public init(content: [Block]) {
        self.content = content
    }

    /// Creates a markdown document from the given content string.
    ///
    /// - Parameter string: The content string.
    /// - Throws: An error if the string cannot be parsed.
    public init(string: String) throws {
        try self.init(Node(markdown: string))
    }
}

// MARK: - Equatable

extension Markdown: Equatable {}
