<script setup lang="ts">
import { withBase } from 'vitepress'

const props = defineProps<{
  src: string
  title?: string
  height?: string
}>()
</script>

<template>
  <figure class="demo-frame">
    <div class="demo-frame__bar">
      <span class="demo-frame__dots"><i /><i /><i /></span>
      <span class="demo-frame__title">{{ props.title || props.src }}</span>
      <a class="demo-frame__open" :href="withBase(props.src)" target="_blank" rel="noreferrer">新窗口 ↗</a>
    </div>
    <iframe
      :src="withBase(props.src)"
      :title="props.title || props.src"
      :style="{ height: props.height || '520px' }"
      loading="lazy"
    />
  </figure>
</template>
