import (
	"list"
	"strings"
)

nums: [1, 2, 3, 4, 5, 6]
nums: [ for index, n in nums if index == 0 {n * n}] // cycle error cannot modify item in-place using iteration

arrOfArr: [
	[1, 2, 3],
	[2, 3, 4],
	[5, 6, 7],
]

flat: list.FlattenN(arrOfArr, 1)

first: [1, 2, 3]
second: [4, 5, 6, 7]
join: list.FlattenN([first, second], 1)

joined: first + second // use + operator to join lists

hello:      "hello"
world:      "world"
helloworld: strings.Join([hello, world], "") // use strings.Join to join list of strings

requires: [
	{type: "hello", data: "world"},
	{type: "code", data:  "withcheese"},
]

requiresByType: {for _, ref in requires {"\(ref.type)": ref}}
