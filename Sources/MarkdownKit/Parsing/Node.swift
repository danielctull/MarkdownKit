
import cmark

final class Node {

    private let node: OpaquePointer
    init(node: OpaquePointer) {
        self.node = node
    }

    deinit {
        // Only free the reference to the document node.
        guard type == CMARK_NODE_DOCUMENT else { return }
        cmark_node_free(node)
    }
}

// MARK: - Initialization

extension Node {

    convenience init(markdown: String) throws {

        guard
            let node = cmark_parse_document(markdown, markdown.utf8.count, 0)
        else {
            throw UnknownParsingError()
        }

        self.init(node: node)
    }

    convenience init(type: cmark_node_type) {
        self.init(node: cmark_node_new(type))
    }

    convenience init(type: cmark_node_type, literal: String) {
        self.init(type: type)
        self.literal = literal
    }

    convenience init(type: cmark_node_type, children: [Node]) {
        self.init(type: type)
        for child in children {
            cmark_node_append_child(node, child.node)
        }
    }
}

// MARK: - Properties

extension Node {

    var children: [Node] {
        var result: [Node] = []
        var child = cmark_node_first_child(node)
        while let unwrapped = child {
            result.append(Node(node: unwrapped))
            child = cmark_node_next(unwrapped)
        }
        return result
    }

    var fenceInfo: String? {
        get { cmark_node_get_fence_info(node).map(String.init) }
        set { setOptional(newValue, setter: cmark_node_set_fence_info) }
    }

    var headingLevel: Int {
        get { Int(cmark_node_get_heading_level(node)) }
        set { cmark_node_set_heading_level(node, Int32(newValue)) }
    }

    var listStart: Int32 {
        get { cmark_node_get_list_start(node) }
        set { cmark_node_set_list_start(node, newValue) }
    }

    var listTight: Int32 {
        get { cmark_node_get_list_tight(node) }
        set { cmark_node_set_list_tight(node, newValue) }
    }

    var listType: cmark_list_type {
        get { cmark_node_get_list_type(node) }
        set { cmark_node_set_list_type(node, newValue) }
    }

    var literal: String? {
        get { cmark_node_get_literal(node).map(String.init) }
        set { setOptional(newValue, setter: cmark_node_set_literal) }
    }

    var url: String? {
        get { cmark_node_get_url(node).map(String.init) }
        set { setOptional(newValue, setter: cmark_node_set_url) }
    }

    var title: String? {
        get { cmark_node_get_title(node).map(String.init) }
        set { setOptional(newValue, setter: cmark_node_set_title) }
    }

    var type: cmark_node_type {
        cmark_node_get_type(node)
    }

    var typeString: String {
        cmark_node_get_type_string(node).map(String.init) ?? ""
    }
}

// MARK: - Helper functions

extension Node {

    private func setOptional<T>(_ value: T?,
                                setter: (OpaquePointer, T?) -> Int32) {
        switch value {
        case .some(let value): _ = setter(node, value)
        case .none: _ = setter(node, nil)
        }
    }
}
