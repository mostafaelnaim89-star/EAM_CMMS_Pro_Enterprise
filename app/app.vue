<template>
  <NuxtLayout>
    <NuxtPage />
  </NuxtLayout>
</template>

<script setup lang="ts">
useHead({
  htmlAttrs: { lang: 'ar', dir: 'rtl' },
  bodyAttrs: { class: 'eam-body' },
})
</script>
