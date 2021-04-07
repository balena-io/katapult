## Product-os

The following will output a docker-compose.yml for product-os
```
cue cmd printCompose katapult.cue katapult/keyframe.cue katapult/definitions.cue katapult/compose.cue katapult/compose_tool.cue katapult_productos.cue > docker-compose.yml
```

To see how an evaluation is built start by `eval` the first file in the command above, inspect the output and then continue with the next...

```
cue eval katapult.cue
```

```
cue eval katapult.cue katapult/keyframe.cue
```

etc...

## Development

[VSCode Extension for the CUE Language](https://github.com/cue-sh/vscode-cue) implements syntax highlighting for the CUE language.

Use `cue eval FILENAME ...` to view the combined output of the filenames listed. For example `cue eval katapult.cue katapult_openbalena.cue` to see how the `katapult.cue` definition combines with the openBalena contract and keyframes. If the output contains typings add the `--concrete` argument to throw an error stating what has not been resolved to concrete values.

Tip: redirect `cue` output to a snapshot file `cue eval katapult.cue katapult_openbalena.cue > snapshot` and then open `snapshot` in your IDE to more effectively inspect the output.
