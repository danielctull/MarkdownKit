
import Foundation

public struct Markdown {

    private let root: Node
    public let content: [Block]

    public init(content: [Block]) {
        root = Node(content: content)
        self.content = content
    }

    public init(string: String) throws {
        root = try Node(markdown: string)
        content = try root.children.map(Block.init)
    }
}

extension Markdown: Equatable {

    public static func ==(lhs: Markdown, rhs: Markdown) -> Bool {
        lhs.content == rhs.content
    }
}
