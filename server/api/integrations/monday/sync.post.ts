import { syncWorkOrder, type MondayWorkOrder } from '../../../utils/monday'

export default defineEventHandler(async (event) => {
  const body = await readBody<Partial<MondayWorkOrder>>(event)
  const title = String(body?.title || '').trim()

  if (!title) {
    throw createError({ statusCode: 400, statusMessage: 'عنوان أمر العمل مطلوب قبل المزامنة' })
  }

  const item = await syncWorkOrder({
    title,
    id: body.id,
    status: body.status,
    priority: body.priority,
    sector: body.sector,
    station: body.station,
    assignedTo: body.assignedTo,
    dueDate: body.dueDate,
    description: body.description
  })

  return {
    success: true,
    message: 'تم إنشاء أمر العمل في Monday.com',
    item
  }
})
