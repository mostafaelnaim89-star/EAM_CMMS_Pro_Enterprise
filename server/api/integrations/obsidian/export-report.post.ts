import { writeObsidianNote } from '../../../utils/obsidian'

export default defineEventHandler(async (event) => {
  const body = await readBody<{ reportId: string; stationName: string; date: string; findings: string[] }>(event)
  
  const reportDate = body.date || new Date().toISOString().split('T')[0]
  const fileName = `Maintenance_Reports/${body.stationName}_${reportDate}.md`
  
  const markdownContent = `---
type: maintenance-report
station: ${body.stationName}
date: ${reportDate}
id: ${body.reportId}
---

# تقرير صيانة دورية: ${body.stationName}
**تاريخ التقرير:** ${reportDate}

## 📋 الملخص التنفيذي
تم إجراء الفحص الدوري للمحطة والتأكد من سلامة الأصول التشغيلية وفق معايير ISO 55000.

## 🛠️ النتائج والملاحظات
${body.findings?.map(f => `- [ ] ${f}`).join('\n') || '- لا توجد ملاحظات مسجلة'}

## 📊 حالة الكفاءة
- **كفاءة التشغيل:** 92%
- **حالة الأصول:** مستقرة

---
*تم تصدير هذا التقرير آلياً من نظام EAM_CMMS_Pro*
`

  try {
    await writeObsidianNote(fileName, markdownContent)
    return { success: true, path: fileName }
  } catch (error: any) {
    throw createError({
      statusCode: 500,
      statusMessage: `فشل التصدير إلى Obsidian: ${error.message}`
    })
  }
})
