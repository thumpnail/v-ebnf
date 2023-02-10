# v-ebnf
EBNF parser module written in v

currently not optimized for ease of use.
Many functions may be private.
Bugs are expected.

## syntax
```ebnf
rule := 'literal' (sub_rule | 'a');
sub_rule := 'repeat' { ',' sub_rule};
opt := 'var' name [':' typename] '=' value;
many := sub_rule | opt | rule;
```
## usage(in theory)
```v
import ebnf
filename := 'somefile.ebnf'
mut context := ebnf.VParseusContext{}
ebnf_lines << os.read_lines(filename) or { panic("Could not read file...")}
context.read_ebnf(ebnf_lines)
println(context.ast.rules) // all the rules
```
