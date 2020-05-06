
import cmark

extension Markdown {

    init(_ node: Node) throws {
        struct NotDocumentType: Error {}
        guard node.type == CMARK_NODE_DOCUMENT else { throw NotDocumentType() }
        self.init(content: try node.children.map(Block.init))
    }
}
