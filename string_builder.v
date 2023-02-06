module ebnf

pub struct StringBuilder {
	mut:
		final string
}
pub fn (mut sb StringBuilder) append_line(line string) {
	sb.final += line + '\n'
}
pub fn (mut sb StringBuilder) append_text(text string) {
	sb.final += text
}
pub fn (mut sb StringBuilder) get_final() string {
	return sb.final
}
