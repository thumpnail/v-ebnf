module ebnf

import datatypes
type Stack = datatypes.Stack[SyntaxNode]
struct ParserContext {
	pub mut:
	i int
	t_list []TokenTuple
	rules []SyntaxNode
}
// prgm := { name '=' { exp } } name;
// exp := number | exp '+' exp | exp '*' exp;
// name := "A" | "B" | "C";

fn parser(tokenTuple []TokenTuple) []SyntaxNode { // []SyntaxNode <- list of rules
	mut stk := []SyntaxNode{} // stack for a subrule
	mut ast := []SyntaxNode{} // [Rule1,Rule2,Rule3,...]
	mut in_group := 0
	for idx in tokenTuple {
		match idx.item1 {
			.rule {
				stk << SyntaxNode{value: idx.item2, s_type: .rule, children: []}
			}
			.assign { // create Rule and add a Subrule
				add_rule(mut ast, stk.pop())
				add_subrule(mut ast, SyntaxNode{ value: idx.item2, s_type: .assign, children: []SyntaxNode{} })
			}
			.literal {
				stk << (SyntaxNode{value: idx.item2, s_type: .literal, children: []})
			}
			.end {
				//Add all stack items in correct order
				add_item_m(mut ast, stk)
				stk.clear()
				add_subrule(mut ast,(SyntaxNode{value: idx.item2, s_type: .end, children: []}))
			}
			.opt_open {
				stk << SyntaxNode{value: idx.item2, s_type: .optional, children: []}
				in_group += 1
			}
			.opt_close {
				stk << SyntaxNode{value: idx.item2, s_type: .end, children: []}
				mut tmp := []SyntaxNode{}
				for stk.last().s_type != .optional {
					tmp << stk.pop()
				}
				tmp.reverse_in_place()
				stk.last().children << tmp
				in_group -= 1
			}
			.opt_repeat_open {
				stk << SyntaxNode{value: idx.item2, s_type: .repeat, children: []}
				in_group += 1
			}
			.opt_repeat_close {
				//mby closing bracket
				stk << SyntaxNode{value: idx.item2, s_type: .end, children: []}
				mut tmp := []SyntaxNode{}
				for stk.last().s_type != .repeat {
					tmp << stk.pop()
				}
				tmp.reverse_in_place()
				stk.last().children << tmp
				in_group -= 1
			}
			.group_open {
				stk << SyntaxNode{value: idx.item2, s_type: .group, children: []}
				in_group += 1
			}
			.group_close {
				stk << SyntaxNode{value: idx.item2, s_type: .end, children: []}
				mut tmp := []SyntaxNode{}
				for stk.last().s_type != .group {
					tmp << stk.pop()
				}
				tmp.reverse_in_place()
				stk.last().children << tmp
				in_group -= 1
			}
			.alt {
				// Add all elements from before

				if in_group > 0 {
					stk << SyntaxNode{ value: idx.item2, s_type: .alt, children: []SyntaxNode{} }
				} else {
					add_item_m(mut ast, stk)
					stk.clear()
					add_subrule(mut ast, SyntaxNode{ value: idx.item2, s_type: .alt, children: []SyntaxNode{} })
				}
			}
			else {
				panic("not implemented")
			}
		}
	}
	return ast
}
fn add_rule(mut ast []SyntaxNode, node SyntaxNode) {
	ast << node
}
fn add_subrule(mut ast []SyntaxNode, node SyntaxNode) {
	ast.last().children << node
}
fn add_item(mut ast []SyntaxNode, node SyntaxNode) {
	ast.last().children.last().children << node
}
fn add_item_m(mut ast []SyntaxNode, nodes []SyntaxNode) {
	ast.last().children.last().children << nodes
}
fn create_item(mut ast []SyntaxNode, nodes []SyntaxNode) {

}
