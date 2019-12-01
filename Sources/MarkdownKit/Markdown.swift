
import Foundation

public struct Markdown {

    private let root: Node
    public let blocks: [Block]

    public init(blocks: [Block]) {
        root = Node(blocks: blocks)
        self.blocks = blocks
    }

    public init(string: String) throws {
        root = try Node(markdown: string)
        blocks = try root.children.map(Block.init)
    }
}

extension Markdown: Equatable {

    public static func ==(lhs: Markdown, rhs: Markdown) -> Bool {
        lhs.blocks == rhs.blocks
    }
}
