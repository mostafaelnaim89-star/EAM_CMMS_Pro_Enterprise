# دليل نشر وتشغيل EAM_CMMS_Pro Enterprise

يوضح هذا الدليل تشغيل **نظام EAM_CMMS_Pro Enterprise بالكامل** كموقع Nuxt دائم، مع قاعدة بيانات Supabase وتكاملات Obsidian وMonday.com وReplit وn8n. لا تُحفظ المفاتيح السرية داخل ملفات Vue أو المستودع.

## 1. نشر النظام الكامل

اربط مستودع GitHub التالي بمنصة الاستضافة التي تستخدمها:

`https://github.com/mostafaelnaim89-star/EAM_CMMS_Pro_Enterprise`

استخدم الإعدادات التالية:

| الإعداد | القيمة |
|---|---|
| إطار العمل | Nuxt 3 / Nitro |
| أمر البناء | `npm run build` |
| أمر التشغيل المحلي | `npm run dev -- --host 0.0.0.0` |
| الصفحة الرئيسية | `/` لوحة القيادة التنفيذية |
| مركز التكاملات | `/integrations` |

بعد النشر، افتح `/integrations` من داخل النظام لمراجعة حالة الخدمات الثلاث.

## 2. متغيرات البيئة

انسخ `.env.example` إلى ملف البيئة الخاص بمنصة الاستضافة، ثم استبدل القيم الوهمية بقيمك الفعلية:

```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
SUPABASE_SERVICE_KEY=server-only-service-key

MONDAY_API_TOKEN=your-monday-api-token
MONDAY_BOARD_ID=your-monday-board-id
MONDAY_GROUP_ID=optional-monday-group-id

OBSIDIAN_API_URL=https://127.0.0.1:27124
OBSIDIAN_API_KEY=your-obsidian-local-rest-api-key
```

يُحظر وضع `SUPABASE_SERVICE_KEY` أو `MONDAY_API_TOKEN` أو `OBSIDIAN_API_KEY` في متغيرات عامة أو داخل ملفات الواجهة.

## 3. تكامل Obsidian

يوجد Vault متوافق مع Obsidian داخل:

`obsidian-vault/`

ويحتوي حالياً على ملفات إجراءات ومعايير فنية بصيغة Markdown. لاستخدامه محلياً، نزّل المستودع ثم اختر مجلد `obsidian-vault` من Obsidian عبر **Open folder as vault**.

للمزامنة الآلية مع نسخة Obsidian تعمل على جهاز أو خادم، ثبّت إضافة **Local REST API**، ثم عرّف `OBSIDIAN_API_URL` و`OBSIDIAN_API_KEY` على خادم النظام. إذا كان Obsidian يعمل على جهاز شخصي خلف شبكة خاصة، يجب توفير Bridge أو عنوان قابل للوصول من خادم الاستضافة؛ رابط `127.0.0.1` داخل الاستضافة لا يشير إلى جهاز المستخدم.

## 4. تكامل Monday.com

يعتمد التكامل على Monday GraphQL API. يتيح النظام:

- فحص الحساب عبر الاستعلام `me`.
- إنشاء عنصر لأمر عمل عبر `POST /api/integrations/monday/sync`.
- عرض حالة الإعداد من `GET /api/integrations/status`.
- اختبار الاتصال من `GET /api/integrations/monday/health`.

مثال طلب مزامنة آمن من خادم أو نظام داخلي:

```bash
curl -X POST "https://YOUR_DOMAIN.example/api/integrations/monday/sync" \
  -H "Content-Type: application/json" \
  -d '{
    "title": "فحص مضخة أبو عارف الجديدة",
    "status": "Working on it",
    "priority": "High",
    "sector": "السويس",
    "station": "أبو عارف الجديدة",
    "assignedTo": "فريق الكهرباء",
    "dueDate": "2026-08-20",
    "description": "فحص الاهتزاز وقراءة التيار قبل الإغلاق الوقائي"
  }'
```

يجب أن يملك المستخدم أو التطبيق صلاحيات القراءة والكتابة على اللوحة المستهدفة. راجع [Monday GraphQL basics](https://developer.monday.com/api-reference/docs/basics) و[Items API](https://developer.monday.com/api-reference/reference/items) قبل ضبط أسماء الأعمدة؛ أسماء الأعمدة تختلف من لوحة إلى أخرى.

## 5. تكامل Replit

تم تجهيز `.replit` و`replit.nix` داخل المستودع. للاستيراد:

1. افتح [Replit Import](https://replit.com/import).
2. اختر GitHub.
3. اختر المستودع `mostafaelnaim89-star/EAM_CMMS_Pro_Enterprise`.
4. أضف أسرار Supabase وMonday.com وObsidian من قسم **Secrets**.
5. استخدم أمر التشغيل `npm run dev -- --host 0.0.0.0`.
6. استخدم أمر البناء `npm run build` عند إنشاء Deployment.

وفقاً لوثائق Replit، لا تنتقل قيم الأسرار أو بيانات Supabase تلقائياً عند الاستيراد، ولذلك يجب إدخالها من Secrets بعد إنشاء المشروع. راجع [استيراد المشاريع من GitHub إلى Replit](https://docs.replit.com/build/import-from-providers).

## 6. n8n وWebhooks

يمكن استخدام n8n لبدء مزامنة أوامر العمل أو إرسال التنبيهات. يجب وضع رابط Webhook ومفتاح المصادقة في متغيرات البيئة أو إعدادات خادم n8n، وليس في الواجهة العامة. صمّم Workflow ليقبل JSON موحداً، ثم يرسل البيانات إلى API النظام أو إلى Monday.com بعد التحقق من التوقيع والصلاحيات.

قبل التشغيل الفعلي، اختبر Workflow على بيانات غير حساسة وتحقق من منع التكرار باستخدام `workOrderId` أو معرف حدث فريد.

## 7. فحص ما بعد النشر

بعد النشر، نفّذ الاختبارات التالية:

```bash
curl -sS https://YOUR_DOMAIN.example/api/integrations/status
curl -sS https://YOUR_DOMAIN.example/api/integrations/monday/health
```

يجب أن تظهر حالة Replit جاهزة، بينما تظهر Monday.com وObsidian كـ **بانتظار الإعداد** إلى أن تُضاف أسرارهما. لا تعتبر التكامل متصلاً فعلياً قبل نجاح اختبار الخدمة من صفحة `/integrations`.
