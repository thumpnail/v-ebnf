module ebnf

pub struct Traverser[T] {
	mut:
		idx int
	pub mut:
		array []T
}
// push puts a given item on top of the array
pub fn (t Traverser[T]) push(item T) {
	t.array.push(item)
}
// pop removes topmost item from the array and returns it
pub fn (t Traverser[T]) pop() T {
	return t.array.pop()
}
// get_itm returns the item by index
pub fn (t Traverser[T]) get_itm(idx int) T {
	return t.array[idx]
}
// set_itm sets a item at a given position
pub fn (t Traverser[T]) set_itm(item T, idx int) {
	t.array[idx] = item
}
// current return the current item
pub fn (t Traverser[T]) current() T {
	return t.array[t.idx]
}
// consume consumes the next next item in the array based of the given item.
// Increments the index on success and returns true.
// Returns false if it doesnt match.
pub fn (t Traverser[T]) consume(item T) bool {
	if t.peek() == item {
		t.idx++
		return true
	} else {
		return false
	}
	error('Expected ' + value + ' got ' + t.next())
}
// peek return the next item without incrementing the index
pub fn (t Traverser[T]) peek() T {
	if t.idx >= t.array.len {
		error('Array out of bounds')
	}
	return t.array[t.idx+1]
}
// last return the last element without changing the index
pub fn (t Traverser[T]) last() T {
	return t.array[t.idx-1]
}
// next just increments the index and returns the given item.
// Has bounds checking
pub fn (t Traverser[T]) next() T {
	if t.idx >= t.array.len {
		error('Array out of bounds')
	}
	t.idx++
	return t.array[t.idx]
}
// get_idx return the current index
pub fn (t Traverser[T]) get_idx() int {
	return t.idx
}
// set_idx sets the index to a given value.
// Has Bounds checking.
pub fn (t Traverser[T]) set_idx(idx int) {
	if t.idx >= t.array.len {
		error('Array out of bounds')
	}
	t.idx = idx
}
