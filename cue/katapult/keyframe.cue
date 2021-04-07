package katapult

// evalate identifier 
#func_identifier: {

	#as:   string
	#slug: string

	if #as != _|_ {
		out: #as
	}
	if #as == _|_ {
		out: #slug
	}
}

for id, blueprint in blueprints {
	keyframes: "\(id)": {
		slug: "\(id)-keyframe"
		data: {
			children: {
				for ref in blueprint.data.selector {
					let identifier = (#func_identifier & {#as: ref.as, #slug: ref.slug}).out
					"\(identifier)": contracts[ref.slug]
				}
			}
			links: blueprint.data.links
		}
	}
}
