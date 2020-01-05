
import cmark

extension Inline {

    init(_ node: Node) throws {

        let inlineChildren = { try node.children.map(Inline.init) }
        
        switch node.type {

        case CMARK_NODE_TEXT:
            self = .text(node.literal!)

        case CMARK_NODE_SOFTBREAK:
            self = .softBreak

        case CMARK_NODE_LINEBREAK:
            self = .lineBreak

        case CMARK_NODE_CODE:
            self = .code(node.literal!)

        case CMARK_NODE_HTML_INLINE:
            self = .html(node.literal!)

        case CMARK_NODE_CUSTOM_INLINE:
            self = .custom(node.literal!)

        case CMARK_NODE_EMPH:
            self = .emphasis(try inlineChildren())

        case CMARK_NODE_STRONG:
            self = .strong(try inlineChildren())

        case CMARK_NODE_LINK:
            self = .link(title: node.title,
                         url: node.url,
                         content: try inlineChildren())

        case CMARK_NODE_IMAGE:
            self = .image(title: node.title,
                          url: node.url,
                          content: try inlineChildren())

        default:
            struct UnexpectedInlineType: Error {
                let name: String
            }
            throw UnexpectedInlineType(name: node.typeString)
        }
    }
}

extension Node {

    convenience init(type: cmark_node_type, elements: [Inline]) {
        self.init(type: type, children: elements.map(Node.init))
    }
}

extension Node {

    convenience init(_ inline: Inline) {

        switch inline {

        case .text(let text):
            self.init(type: CMARK_NODE_TEXT, literal: text.literal)

        case .emphasis(let emphasis):
            self.init(type: CMARK_NODE_EMPH, elements: emphasis.content)

        case .code(let code):
            self.init(type: CMARK_NODE_CODE, literal: code.literal)

        case .strong(let strong):
            self.init(type: CMARK_NODE_STRONG, elements: strong.content)

        case .html(let html):
            self.init(type: CMARK_NODE_HTML_INLINE, literal: html.literal)

        case .custom(let custom):
            self.init(type: CMARK_NODE_CUSTOM_INLINE, literal: custom.literal)

        case let .link(link):
            self.init(type: CMARK_NODE_LINK, elements: link.content)
            title = link.title
            url = link.url

        case let .image(image):
            self.init(type: CMARK_NODE_IMAGE, elements: image.content)
            title = image.title
            url = image.url

        case .softBreak:
            self.init(type: CMARK_NODE_SOFTBREAK)

        case .lineBreak:
            self.init(type: CMARK_NODE_LINEBREAK)
        }
    }
}
