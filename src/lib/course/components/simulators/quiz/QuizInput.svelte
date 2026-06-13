<script lang="ts">
	import { uiTheme } from '../../../uiTheme.svelte';
	import type { QuizItem } from '../../../types';

	let {
		contentText,
		quizConfig,
		quizLayout,
		isQuizCorrect = $bindable(false)
	}: {
		contentText?: string;
		quizConfig?: QuizItem | QuizItem[];
		quizLayout?: 'table';
		isQuizCorrect: boolean;
	} = $props();

	let quizItems = $derived.by(() => {
		if (quizConfig) {
			return Array.isArray(quizConfig) ? quizConfig : [quizConfig];
		}

		if (!contentText) return [];
		const match = contentText.match(/^1\s*(.+?)\s*=\s*(.*)$/);
		if (match) {
			return [{ prefix: '1', answer: match[1].trim(), suffix: ' = ' + match[2].trim() }];
		}

		return [];
	});
	let userInputs = $state<string[]>([]);
	let styles = $derived(uiTheme.styles);

	$effect(() => {
		if (quizItems.length > 0 && userInputs.length !== quizItems.length) {
			userInputs = quizItems.map(() => '');
		}
	});

	$effect(() => {
		if (quizItems.length > 0) {
			isQuizCorrect = quizItems.every((quiz, index) => {
				return quiz.answer === undefined || (userInputs[index] ?? '').trim() === quiz.answer;
			});
		}
	});
</script>

{#if quizItems.length > 0}
	<div class="animate-in zoom-in-95 p-4 duration-300 {styles.quiz}">
		{#if quizLayout === 'table'}
			<table class="w-full border-collapse text-xl font-bold {styles.text}">
				<tbody>
					{#each quizItems as quiz, index (`table-${index}-${quiz.prefix}-${quiz.answer ?? ''}-${quiz.suffix}`)}
						<tr class="border-b border-black/10 last:border-0">
							<td class="py-2 pr-3 whitespace-nowrap">
								{#if quiz.answer !== undefined}
									<input
										type="text"
										bind:value={userInputs[index]}
										placeholder="???"
										class="w-24 py-1 text-center transition-all {styles.input}"
										class:correct={(userInputs[index] ?? '').trim() === quiz.answer}
									/>
								{/if}
							</td>
							{#each quiz.suffix.split('|') as cell (`${index}-${cell}`)}
								<td class="py-2 pr-4 text-lg font-normal whitespace-nowrap">
									<!-- eslint-disable-next-line svelte/no-at-html-tags -->
									{@html cell}
								</td>
							{/each}
						</tr>
					{/each}
				</tbody>
			</table>
		{:else}
			<div class="flex flex-col items-center gap-3">
				{#each quizItems as quiz, index (`inline-${index}-${quiz.prefix}-${quiz.answer ?? ''}-${quiz.suffix}`)}
					<div class="flex items-baseline gap-3 text-3xl font-black {styles.text}">
						{#if quiz.prefix}
							<span class="text-xl font-bold select-none">{quiz.prefix}</span>
						{/if}
						{#if quiz.answer !== undefined}
							<input
								type="text"
								bind:value={userInputs[index]}
								placeholder="???"
								class="w-32 py-1 text-center transition-all {styles.input}"
								class:correct={(userInputs[index] ?? '').trim() === quiz.answer}
							/>
						{/if}
						<span class="text-xl font-bold select-none">
							<!-- eslint-disable-next-line svelte/no-at-html-tags -->
							{@html quiz.suffix}
						</span>
					</div>
				{/each}
			</div>
		{/if}
	</div>
{/if}

<style>
	input.correct {
		color: #10b981;
		border-color: #10b981;
		background-color: #f0fdf4;
	}
</style>
