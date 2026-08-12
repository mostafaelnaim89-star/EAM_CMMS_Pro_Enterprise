import { writeObsidianNote } from '../../../utils/obsidian'

export default defineEventHandler(async (event) => {
  const body = await readBody<{ path?: string; content?: string }>(event)
  const path = String(body?.path || '').trim()
  const content = String(body?.content || '')

  if (!path || path.includes('..') || path.startsWith('/')) {
    throw createError({ statusCode: 400, statusMessage: 'مسار مذكرة Obsidian غير صالح' })
  }
  if (!path.toLowerCase().endsWith('.md')) {
    throw createError({ statusCode: 400, statusMessage: 'يجب أن ينتهي مسار المذكرة بامتداد .md' })
  }
  if (!content.trim()) {
    throw createError({ statusCode: 400, statusMessage: 'محتوى مذكرة Obsidian مطلوب' })
  }

  await writeObsidianNote(path, content)
  return { success: true, message: `تمت مزامنة المذكرة ${path} إلى Obsidian` }
})
