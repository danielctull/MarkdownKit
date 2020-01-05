
import cmark

extension Block {
    
    init(_ node: Node) throws {

        let inlineChildren = { try node.children.map(Inline.init) }
        let blockChildren = { try node.children.map(Block.init) }

        switch node.type {

        case CMARK_NODE_PARAGRAPH:
            self = .paragraph(try inlineChildren())

        case CMARK_NODE_BLOCK_QUOTE:
            self = .quote(try blockChildren())

        case CMARK_NODE_LIST:
            let kind = try Block.List.Kind(node)
            let tight = node.listTight > 0
            let items = try node.children.map(Block.List.Item.init)
            self = .list(kind: kind, tight: tight, items: items)

        case CMARK_NODE_CODE_BLOCK:
            let language = node.fenceInfo.flatMap { $0.isEmpty ? nil : $0 }
            self = .code(node.literal!, info: language)

        case CMARK_NODE_HTML_BLOCK:
            self = .html(node.literal!)

        case CMARK_NODE_CUSTOM_BLOCK:
            self = .custom(node.literal!)

        case CMARK_NODE_HEADING:
            let level = Block.Heading.Level(node)
            self = .heading(try inlineChildren(),
                            level: level)

        case CMARK_NODE_THEMATIC_BREAK:
            self = .thematicBreak

        default:
            struct UnexpectedBlockType: Error {
                let name: String
            }
            throw UnexpectedBlockType(name: node.typeString)
        }
    }
}

extension Node {

    convenience init(type: cmark_node_type, content: [Block]) {
        self.init(type: type, children: content.map(Node.init))
    }

    convenience init(content: [Block]) {
        self.init(type: CMARK_NODE_DOCUMENT, content: content)
    }
}

extension Node {

    convenience init(block: Block) {
        
        switch block {

        case let .paragraph(paragraph):
            self.init(type: CMARK_NODE_PARAGRAPH, content: paragraph.content)

        case let .list(list):

            let listItems = list.items.map {
                Node(type: CMARK_NODE_ITEM, content: $0.content)
            }

            self.init(type: CMARK_NODE_LIST, children: listItems)
            listStart = Int32(list.kind)
            listTight = list.tight ? 1 : 0
            listType = cmark_list_type(list.kind)

        case let .quote(quote):
            self.init(type: CMARK_NODE_BLOCK_QUOTE, content: quote.content)

        case let .code(code):
            self.init(type: CMARK_NODE_CODE_BLOCK, literal: code.literal)
            fenceInfo = code.info

        case let .html(html):
            self.init(type: CMARK_NODE_HTML_BLOCK, literal: html.literal)

        case let .custom(custom):
            self.init(type: CMARK_NODE_CUSTOM_BLOCK, literal: custom.literal)

        case let .heading(heading):
            self.init(type: CMARK_NODE_HEADING, content: heading.content)
            headingLevel = Int(heading.level)

        case .thematicBreak:
            self.init(type: CMARK_NODE_THEMATIC_BREAK)
        }
    }
}

extension Block.List.Item {

    fileprivate init(_ node: Node) throws {

        guard node.type == CMARK_NODE_ITEM else {
            struct UnexpectedListItemType: Error {
                let name: String
            }
            throw UnexpectedListItemType(name: node.typeString)
        }

        self = .init(content: try node.children.map(Block.init))
    }
}

extension Block.List.Kind {

    fileprivate init(_ node: Node) throws {

        switch node.listType {
        case CMARK_ORDERED_LIST: self = .ordered(start: Int(node.listStart))
        case CMARK_BULLET_LIST: self = .unordered
        default:
            struct UnexpectedListKindType: Error {
                let name: String
            }
            throw UnexpectedListKindType(name: node.typeString)
        }
    }
}

extension cmark_list_type {

    fileprivate init(_ kind: Block.List.Kind) {
        switch kind {
        case .unordered: self = CMARK_BULLET_LIST
        case .ordered: self = CMARK_ORDERED_LIST
        }
    }
}

extension Int32 {

    fileprivate init(_ kind: Block.List.Kind) {
        switch kind {
        case .unordered: self = 0
        case .ordered(let start): self = Int32(start)
        }
    }
}

extension Block.Heading.Level {

    fileprivate init(_ node: Node) {
        switch node.headingLevel {
        case 1: self = .h1
        case 2: self = .h2
        case 3: self = .h3
        case 4: self = .h4
        case 5: self = .h5
        case 6: self = .h6
        default: self = .h1
        }
    }
}

extension Int {

    fileprivate init(_ level: Block.Heading.Level) {
        switch level {
        case .h1: self = 1
        case .h2: self = 2
        case .h3: self = 3
        case .h4: self = 4
        case .h5: self = 5
        case .h6: self = 6
        }
    }
}
