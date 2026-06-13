<script lang="ts">
	import type { PageData } from './$types';
	import CoursePage from '$lib/course/components/CoursePage.svelte';

	let { data }: { data: PageData } = $props();
</script>

<CoursePage courseData={data.courseData} contentUrl="/1-1.3" />
