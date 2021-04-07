// foo: {#a: int, #b: int, #a + #b } // struct with embedded scalar
// call1: foo&{_, #a: 1, #b: 2}         // 3
// six: call1 + call1

// bar: {
//   #a: int
//   #b: int
//   #c: true | bool
//   if #c  { out: #a + #b }
//   if !#c { out: 4 }
// } // struct without embedded scalar
// call2: (bar&{#a: 1, #b: 2, #c: true}).out         // 3
// call3: (bar&{#a: 1, #b: 2, #c: false})         // 4

#func_alias: {
	#a: string
	#b: string
	#c: true | bool
	if #c {out: "\(#a)_\(#b)"}
	if !#c {out: "\(#a)"}
}
hello:      (#func_alias & {#a: "Hello", #b: "World", #c: false}).out
helloWorld: (#func_alias & {#a: "Hello", #b: "World", #c: true}).out

obj: "\(hello)": "\(helloWorld)": true

#foo: {#a: int, #b: int, sum: #a + #b, multiply: #a * #b} // struct with embedded scalar

call: #foo & {_, #a: 1, #b: 2} // 3

complex: {
	six:  #foo & {_, #a: 4, #b: 2}
	nine: #foo & {_, #a: 4, #b: 5}
	five: #foo & {_, #a: 4, #b: 1}
}

// evalate identifier 
#func_identifier: {

	as?:  string
	slug: string

	if as != _|_ {
		out: as
	}
	if as == _|_ {
		out: slug
	}
}

api:       (#func_identifier & {#as:   "api", #slug: "balena-api"}).out
balenaApi: (#func_identifier & {#slug: "balena-api"}).out
