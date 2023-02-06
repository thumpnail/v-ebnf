module ebnf
const(
	all_symbols = ['^','°','!','"','§','$','%','&','/','(',')','=','?','`','{','[',']','}','\\','\´','+','#','*','\'','~',',','.','-',';',':','_','<','>','|']
)
fn string_exist_of(src string, arr []u8) bool {
	mut check := 0
	for item in src {
		if arr.contains(item) {
			check++
		}
	}
	return check == src.len // Exist Of
}
fn string_contains_u8(src string, arr []u8) bool {
	mut check := 0
	for item in src {
		if arr.contains(item) {
			check++
		}
	}
	return check >= 0 // Contains
}
fn string_contains_string(src string, arr []string) bool {
	return arr.contains(src)
}
fn string_equals(src string, arr []u8) bool {
	mut check := 0
	for c in arr {
		if src == c.ascii_str() {
			check++
		}
	}
	return check == src.len
}
// array_contains(c string,arr []string) -> checks if c is inside array
fn array_contains(c string, arr []string) bool {
	for item in arr {
		if item == c {
			return true
		}
	}
	return false
}
