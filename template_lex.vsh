enum TokenType {
	unknown
	tk_semicolon
	tk_colon
	tk_parentheses_open
	tk_parentheses_close
	tk_colon_equals
	tk_braces_open
	tk_braces_close
	tk_comma
	tk_vbar_vbar
	tk_and_and
	tk_exclamation
	tk_less
	tk_less_equals
	tk_greater
	tk_greater_equals
	tk_equals_equals
	tk_exclamation_equals
	tk_question_mark
	tk_plus
	tk_minus
	tk_asterisk
	tk_slash
	tk_percent
	tk_dot
	tk_double_quote
	tk_underscore
	tk_break
	tk_continue
	tk_data
	tk_use
	tk_fnc
	tk_loop
	tk_end
	tk_if
	tk_elseif
	tk_else
	tk_number
	tk_string
	tk_bool
	tk_void
	tk_any

}
const(
	//create arrays from ebnf
	all_digit = [
		'0','1','2','3','4','5','6','7','8','9',
	]
	all_letter = [
		'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
	]

	all_chars = [
		'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
		'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z'
	]
	all_num = [
		'0','1','2','3','4','5','6','7','8','9','.'
	]
	symbol_list = {
		';': TokenType.tk_semicolon
		':': TokenType.tk_colon
		'(': TokenType.tk_parentheses_open
		')': TokenType.tk_parentheses_close
		'{': TokenType.tk_braces_open
		'}': TokenType.tk_braces_close
		',': TokenType.tk_comma
		'!': TokenType.tk_exclamation
		'<': TokenType.tk_less
		'>': TokenType.tk_greater
		'?': TokenType.tk_question_mark
		'+': TokenType.tk_plus
		'-': TokenType.tk_minus
		'*': TokenType.tk_asterisk
		'/': TokenType.tk_slash
		'%': TokenType.tk_percent
		'.': TokenType.tk_dot
		'"': TokenType.tk_double_quote
		'_': TokenType.tk_underscore
	}
	keyword_list = {
		'break': TokenType.tk_break
		'continue': TokenType.tk_continue
		'data': TokenType.tk_data
		'use': TokenType.tk_use
		'fnc': TokenType.tk_fnc
		'loop': TokenType.tk_loop
		'end': TokenType.tk_end
		'if': TokenType.tk_if
		'elseif': TokenType.tk_elseif
		'else': TokenType.tk_else
		'number': TokenType.tk_number
		'string': TokenType.tk_string
		'bool': TokenType.tk_bool
		'void': TokenType.tk_void
		'any': TokenType.tk_any
	}
	operator_list = {
		';': TokenType.tk_semicolon
		':': TokenType.tk_colon
		'(': TokenType.tk_parentheses_open
		')': TokenType.tk_parentheses_close
		':=': TokenType.tk_colon_equals
		'{': TokenType.tk_braces_open
		'}': TokenType.tk_braces_close
		',': TokenType.tk_comma
		'||': TokenType.tk_vbar_vbar
		'&&': TokenType.tk_and_and
		'!': TokenType.tk_exclamation
		'<': TokenType.tk_less
		'<=': TokenType.tk_less_equals
		'>': TokenType.tk_greater
		'>=': TokenType.tk_greater_equals
		'==': TokenType.tk_equals_equals
		'!=': TokenType.tk_exclamation_equals
		'?': TokenType.tk_question_mark
		'+': TokenType.tk_plus
		'-': TokenType.tk_minus
		'*': TokenType.tk_asterisk
		'/': TokenType.tk_slash
		'%': TokenType.tk_percent
		'.': TokenType.tk_dot
		'"': TokenType.tk_double_quote
		'_': TokenType.tk_underscore
	}
)

fn preprocessor(script_lines []string) []string {
	mut is_comment := false
	mut is_string := false
	mut is_char := false
	//mut is_number := false
	mut words := []string{}
	mut word := ''
	for line in script_lines {
		word = ''
		for i := 0; i < line.len; i+=1 {
			//HEAD
			mut c := line[i].ascii_str()
			mut next := ' '
			//BODY
			if i + 1 < line.len {
				next = line[i + 1].ascii_str()
			} else {
				//next = 'EOL'
			}
			// string and chars
			if is_string || is_char {
				if c != '\"' {
					word += c
					continue
				}
			}
			if c == 'fn () string' || is_comment {
				is_comment = true
				continue
			}

			if c == '-' && all_num.contains(next) {
				word += c
				continue
			}

			if c == ' ' {
				// whitespace
				if word != '' {
					words << (word)
					word = ''
				}
			}

			if all_chars.contains(c) {
				// word
				word += c
			}
			if c in symbol_list {
				if next in symbol_list {
					tmp := '' + c + next
					if tmp in operator_list {
						words << tmp
						word = ''
						i += 2
						continue
					}
				}
				if c == '\'' {
					word += '\''
					i++
					for i < line.len {
						if line[i].ascii_str() != '\'' {
							word += line[i].ascii_str()
						} else {
							break
						}
						i++
					}
					word += '\''
					continue
				}
				if c == '\"' {
					word += '\''
					i++
					for i < line.len {
						if line[i].ascii_str() != '\"' {
							word += line[i].ascii_str()
						} else {
							break
						}
						i++
					}
					word += '\''
					continue
				}
				if word != '' {
					words << word
					word = ''
				}
				word += c
				if word != '' {
					words << word
					word = ''
				}
			}
		}
		is_comment = false
		is_string = false
		is_char = false
		//is_number = false
		if word != '' {
			words << (word)
		}
	}
	return words
}
struct TokenTuple {
	item1 TokenType
	item2 string
}

fn lexer(words []string) []TokenTuple {
	mut final := []TokenTuple{}
	mut inside_comment := false
	for i := 0; i < words.len; i++ {
		mut token := TokenType.unknown
		mut str := words[i]
		// is digit
		if words[i].contains_only('-1234567890') {
			//is no floating point
			token = TokenType.unknown
		} else if words[i].contains_only('-1234567890.') {
			//is floating point
			token = TokenType.unknown
			if !words[i].contains_only('-1234567890') {
				//anything else or just dot
				token = TokenType.unknown
			}
		} else {
			// special keyword_list
			if str in keyword_list{
				token = keyword_list[str]
			}
			// symbol_list and operator
			else if str in operator_list {
				token = operator_list[str]
			}
			// strings and chars
			else if str.contains('\"') {
				token = TokenType.unknown
			} else if str.contains('\'') {
				token = TokenType.unknown
				if str.len > 3 {
					token = TokenType.unknown
				}
			} else {
				token = TokenType.unknown
			}
		}
		final << TokenTuple{
			item1: token
			item2: str
		}
		str = ''
	}
	inside_comment = false
	mut remlist := []TokenTuple{}
	for item in final {
		if item.item2.contains('\n') {
			inside_comment = false
		} else if item.item2 == ('\n') {
			remlist << item
		} else if item.item2 == '#' {
			remlist << item
			inside_comment = true
		} else if inside_comment {
			remlist << item
		}
	}
	return final
}

