#ref: {slug: "custom_type"}

isMatch: (#ref & {slug: "custom_type"}) != _|_

isMismatch: (#ref & {slug: "wrong_type"}) == _|_
