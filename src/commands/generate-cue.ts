import { spawn } from 'child_process';
import { Command } from '@oclif/command';
import * as flags from '../lib/flags';

// TODO: Substitute normal generate.
export default class GenerateCue extends Command {
	static description = 'Generate a k8s frame for the specified environment';

	static flags = {
		target: flags.target,
		keyframe: flags.keyframePath,
	};

	async run() {
		const { flags } = this.parse(GenerateCue);

		if (flags.target != 'kubernetes') {
			throw new Error('k8s is the only supported target');
		}

		// TODO: Review how the external process is run and handled. Should we compile cue into JS instead?
		const workDir = `${__dirname}/../../cue`;
		const args = ['cmd', 'dumpK8s', 'katapult.cue', 'katapult_tool.cue'];
		if (flags.keyframe === '!examples') {
			args.push('examples.cue');
		}
		// TODO: Pass a real (non-example) keyframe to cue.
		const cue = spawn('cue', args, {
			cwd: workDir,
		});

		cue.stdout.setEncoding('utf8');
		cue.stderr.setEncoding('utf8');

		cue.stdout.on('data', data => {
			console.log(data.toString());
		});
		cue.stderr.on('data', data => {
			console.error(data.toString());
		});

		return new Promise(resolve => {
			cue.on('close', resolve);
		});
	}
}
