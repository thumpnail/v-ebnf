module ebnf

pub fn (mut ctx VParseusContext) finalize() {
	mut tmp := ctx.ast.raw.clone()
	for key in ctx.ast.operators {
		replace_literal(mut tmp, key, get_name(key))
		tmp << ['${get_name(key)}', ':=', '\'${key}\'', ';']
	}
	for key in ctx.ast.keywords {
		if key.len > 1 {
			replace_literal(mut tmp, key, get_name(key))
			tmp << ['${get_name(key)}', ':=', '\'${key}\'', ';']
		}
	}
	lexed := lexer(tmp)
	ast := parser(lexed)
	ctx.ast.raw, ctx.ast.rules = tmp, ast
}
pub fn (mut ctx VParseusContext) get_ebnf(list []SyntaxNode) string {
	mut result := ''
	mut linef := ''
	for key in list {
		if key.value == ';' {
			linef = '\n'
		}
		result += '${key.value} ${ctx.get_ebnf(key.children)}${linef}'
	}
	return result
}
fn get_name(symbols string) string {
	mut out := 'tk'
	mut i := 0
	for key in symbols {
		if !((key >= 65 && key <= 90) || (key >= 97 && key <= 122)) {
			match key.ascii_str() {
				'^' {out += '_circumflex'}
				'°' {out += '_degree'}
				'!' {out += '_exclamation'}
				'"' {out += '_double_quote'}
				'§' {out += '_paragraph'}
				'$' {out += '_dollar'}
				'%' {out += '_percent'}
				'&' {out += '_and'}
				'/' {out += '_slash'}
				'(' {out += '_parentheses_open'}
				')' {out += '_parentheses_close'}
				'=' {out += '_equals'}
				'?' {out += '_question_mark'}
				'`' {out += '_grave'}
				'{' {out += '_braces_open'}
				'[' {out += '_bracket_open'}
				']' {out += '_bracket_close'}
				'}' {out += '_braces_close'}
				'\\' {out += '_backslash'}
				'\´' {out += '_acute'}
				'+' {out += '_plus'}
				'#' {out += '_hash'}
				'*' {out += '_asterisk'}
				"'" {out += '_quote'}
				'~' {out += '_tilde'}
				'.' {out += '_dot'}
				'-' {out += '_minus'}
				';' {out += '_semicolon'}
				':' {out += '_colon'}
				'_' {out += '_underscore'}
				'<' {out += '_less'}
				'>' {out += '_greater'}
				'|' {out += '_vbar'}
				',' {out += '_comma'}
				else {
					out += key.ascii_str()
				}
			}
		} else {
			if i++ == 0 {
				out += '_'
			}
			out += key.ascii_str()
		}
	}
	return out
}
fn replace_literal(mut arr []string, lookup_value string, new_value string) {
	for i := 0; i < arr.len; i++ {
		if arr[i] == ('\''+lookup_value+'\'') && arr[i].starts_with('\'') && arr[i].ends_with('\'') {
			arr[i] = new_value
		}
	}
}
