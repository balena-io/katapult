package katapult

npmData: [string]: [string]: _

for name, p in npmData["package.json"] {
	keyframes: "\(name)": {
		children: [
			for depName, dep in p.dependencies {slug: depName, version: npmData["package-lock.json"][name].dependencies[depName].version},
		]
	}
}
