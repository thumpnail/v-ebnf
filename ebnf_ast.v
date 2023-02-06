module ebnf

import math

enum SyntaxType {
	unknown
	rule
	group
	repeat
	optional
	literal
	assign
	alt
	end
}
pub struct EbnfDocument {
	pub mut:
	filename string

	raw []string
	rules []SyntaxNode

	literals []string
	keywords []string
	symbols []string
	operators []string
	regex []string
}
pub struct SyntaxNode {
	pub mut:
	value string
	s_type SyntaxType
	children []SyntaxNode
}
//recursive SyntaxNode functions

// get_literals returns all literals who match the @type
fn (node SyntaxNode) get_literals() []string {
	mut result := []string{}
	if node.s_type == .literal {
		result << node.value
	}
	for child in node.children{
		result << child.get_literals()
	}
	return result
}
fn (node SyntaxNode) get_value_by_type(@type SyntaxType) []string {
	mut result := []string{}
	if node.s_type == @type {
		result << node.value
	}
	for child in node.children{
		result << child.get_value_by_type(@type)
	}
	return result
}
fn (node SyntaxNode) get_depth() int {
	mut result := 0
	result++
	for child in node.children{
		result += child.get_depth()
	}
	return result
}
fn (node SyntaxNode) enforce_type(s_type SyntaxType) int {
	mut check := 0
	for item in node.children {
		match item.s_type {
			s_type {}
			.group {}
			.repeat {}
			.optional {}
			.assign {}
			.alt {}
			.end {}
			else {check++}
		}
		check += item.enforce_type(s_type)
	}
	return check
}
fn (node SyntaxNode) get_max_depth(depth int) int {
	mut max_depth := depth
	if node.children.len == 0 {
		return 0
	}
	max_depth = depth
	for child in node.children {
		max_depth = math.max[int](max_depth, child.get_max_depth(depth + 1))
	}
	return max_depth
}
