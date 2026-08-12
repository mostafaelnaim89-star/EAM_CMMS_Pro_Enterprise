function obsidianConfig() {
  const runtime = useRuntimeConfig()
  return {
    baseUrl: String(runtime.obsidianApiUrl || process.env.OBSIDIAN_API_URL || '').replace(/\/$/, ''),
    apiKey: String(runtime.obsidianApiKey || process.env.OBSIDIAN_API_KEY || '')
  }
}

export function obsidianIsConfigured() {
  const { baseUrl, apiKey } = obsidianConfig()
  return Boolean(baseUrl && apiKey)
}

export async function writeObsidianNote(path: string, content: string) {
  const { baseUrl, apiKey } = obsidianConfig()
  if (!baseUrl || !apiKey) {
    throw createError({ statusCode: 503, statusMessage: 'OBSIDIAN_API_URL و OBSIDIAN_API_KEY غير مهيأين' })
  }

  const safePath = path
    .split('/')
    .filter(Boolean)
    .map(segment => encodeURIComponent(segment))
    .join('/')

  return await $fetch(`${baseUrl}/vault/${safePath}`, {
    method: 'PUT',
    headers: {
      Authorization: `Bearer ${apiKey}`,
      'Content-Type': 'text/markdown'
    },
    body: content
  })
}
