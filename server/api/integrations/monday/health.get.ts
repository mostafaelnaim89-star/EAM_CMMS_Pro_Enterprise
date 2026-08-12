import { healthCheckMonday, mondayIsConfigured } from '../../../utils/monday'

export default defineEventHandler(async () => {
  if (!mondayIsConfigured()) {
    throw createError({ statusCode: 503, statusMessage: 'أضف MONDAY_API_TOKEN و MONDAY_BOARD_ID قبل اختبار الاتصال' })
  }

  const account = await healthCheckMonday()
  return {
    success: true,
    message: `تم الاتصال بـ Monday.com بنجاح — ${account.name}`,
    account
  }
})
