module ebnf

pub struct VParseusContext {
	pub mut:
	args map[string][]string
	ast EbnfDocument
	//
}
pub fn (mut ctx VParseusContext) read_ebnf(lines []string) {
	document_lines := lines.clone()
	preprocessed := preprocessor(document_lines)
	mut lexed := lexer(preprocessed)
	for i := lexed.len-1; i < lexed.len; i-=1 {
		if i < 0 {
			break
		}
		if lexed[i].item1 == .assign {
			lexed.insert(i+1, TokenTuple{item1: .group_open,item2: '('})
		} else if lexed[i].item1 == .end {
			lexed.insert(i,TokenTuple{item1: .group_close,item2: ')'})
		}
	}
	ast := parser(lexed)
	ctx.ast.raw, ctx.ast.rules = preprocessed, ast
	ctx.ast.literals = get_literals(ctx)
	ctx.ast.operators, ctx.ast.symbols, ctx.ast.keywords, ctx.ast.regex = filter_keywords(ctx.ast.literals)
}
