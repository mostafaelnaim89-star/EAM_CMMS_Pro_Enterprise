export default defineEventHandler(async (event) => {
  const body = await readBody(event)

  // 1. التعامل مع طلب التحقق من Monday.com (Challenge)
  if (body?.challenge) {
    return { challenge: body.challenge }
  }

  // 2. معالجة التحديثات القادمة من Monday
  const eventData = body?.event
  if (!eventData) return { success: false, message: 'لا توجد بيانات حدث' }

  // مثال: إذا تغيرت حالة في Monday، نقوم بتحديثها في النظام
  // eventData.pulseId هو معرّف العنصر في Monday
  // eventData.value.label.text هو النص الجديد للحالة

  console.log('Monday Webhook Received:', eventData)

  // هنا يتم إضافة المنطق لتحديث قاعدة البيانات (Supabase) 
  // بناءً على pulseId و معرّف أمر العمل المرتبط به

  return { success: true }
})
