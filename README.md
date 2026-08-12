# EAM_CMMS_Pro — SaaS Edition
### الشركة القابضة لمياه الشرب والصرف الصحى بمدن القناة

نظام إدارة الأصول والصيانة (EAM/CMMS) SaaS مبني على **Nuxt 4** + **Supabase**، يغطي القطاعات الثلاثة: بورسعيد، الإسماعيلية، السويس (44+ محطة).

---

## 🏗️ البنية

```
eam-saas/
├── app/
│   ├── pages/              # 14 صفحة (dashboard, assets, work-orders...)
│   ├── composables/        # useStations, useAssets, useWorkOrders, useCosts, useKPIs, useAuth
│   ├── layouts/default.vue # القائمة الجانبية + الهيدر
│   └── middleware/auth.ts  # حماية المسارات
├── assets/css/main.css     # نظام التصميم الكامل (Navy + Orange, Cairo font, RTL)
├── supabase/migrations/
│   ├── 001_full_schema.sql # 15 جدول + 9 Views (80+ محطة، أصول، تكاليف، تقييمات)
│   └── 002_rls_policies.sql# سياسات الأمان بحسب الدور
├── nuxt.config.ts
└── package.json
```

---

## 🚀 التشغيل خطوة بخطوة

### 1. تثبيت الحزم
```bash
cd eam-saas
npm install
```

### 2. إعداد Supabase
1. أنشئ مشروع جديد على [supabase.com](https://supabase.com)
2. من **SQL Editor** نفّذ الملفين بالترتيب:
   ```
   supabase/migrations/001_full_schema.sql
   supabase/migrations/002_rls_policies.sql
   ```
3. من **Authentication → Users** أضف مستخدمين، أو فعّل **Email/Password** signup
4. من **Project Settings → API** انسخ:
   - `Project URL`
   - `anon public key`

### 3. متغيرات البيئة
```bash
cp .env.example .env
```
عدّل `.env`:
```
SUPABASE_URL=https://xxxxx.supabase.co
SUPABASE_ANON_KEY=eyJhbGc...
SUPABASE_SERVICE_KEY=eyJhbGc...
```

### 4. ربط جدول `users` بحسابات Auth
بعد إنشاء مستخدم في Supabase Auth، أضف سجلاً مطابقاً في جدول `users` بنفس البريد:
```sql
INSERT INTO users (name, email, role, sector_id)
VALUES ('مصطفى أحمد', 'mostafa@canal-water.eg', 'system_admin', NULL);
```

### 5. التشغيل محلياً
```bash
npm run dev
# افتح http://localhost:3000
```

### 6. النشر (Vercel موصى به)
```bash
npm run build
vercel deploy
```
أضف متغيرات البيئة نفسها في إعدادات Vercel.

---

## 🔐 نظام الصلاحيات (5 أدوار)

| الدور | لوحة القيادة | أوامر العمل | التكاليف | الأصول | المستخدمون |
|---|---|---|---|---|---|
| `system_admin` مدير النظام | ✅ | ✅ | ✅ | ✅ | ✅ |
| `sector_manager` مدير القطاع | ✅ | ✅ | ✅ موافقة | ✅ | ❌ |
| `station_manager` مدير المحطة | ✅ | ✅ | 👁 عرض | ✅ | ❌ |
| `maintenance_engineer` مهندس صيانة | 👁 | ✅ | ❌ | ✅ | ❌ |
| `operator` مشغّل | 👁 | ➕ إنشاء | ➕ إدخال | 👁 | ❌ |

الصلاحيات مطبّقة على مستويين:
- **الواجهة**: `useAuth().canAccess('module')`
- **قاعدة البيانات**: RLS policies في `002_rls_policies.sql`

---

## 📊 قاعدة البيانات (15 جدول + 9 Views)

**الجداول الأساسية:**
`sectors` · `stations` (80+) · `assets` · `asset_categories` · `monthly_costs` · `chemical_types` · `work_orders` · `inventory` · `water_quality` · `pm_schedules` · `users`

**جداول تقييم المحطات (نموذج 765 درجة):**
`station_profile` · `maint_eval_axes` · `maint_eval_items` · `station_assessments`

**Views جاهزة للاستعلام المباشر:**
- `v_executive_dashboard` — لوحة القيادة التنفيذية بكل القطاعات
- `v_assets_full_statement` — بيان الأصول الكامل (يدمج المعدة + المحطة + التقييم + المخاطر)
- `v_assessment_report` — تقرير التقييم بالنسب المئوية لكل محور
- `v_station_full_profile` — الملف التشغيلي الكامل لكل محطة
- `v_sector_kpis` · `v_overdue_work_orders` · `v_low_inventory` · `v_monthly_cost_summary` · `v_asset_health_summary`

---

## 🎨 نظام التصميم

- **الألوان:** Navy `#0F1F3D` + Orange `#F07C2A` + Gold `#D4AF37`
- **الخط:** Cairo (عربي) + JetBrains Mono (أرقام)
- **الاتجاه:** RTL كامل
- **التأثيرات:** Soft Blink للتنبيهات الحرجة، Interactive Sector Filtering

---

## 🔗 الربط مع النسخة HTML المستقلة

ملف `EAM_CMMS_Unified.html` (النسخة أوفلاين/بدون سيرفر) يستخدم نفس مخطط البيانات، ويمكن توصيله بنفس مشروع Supabase عبر:
```js
const SUPA_URL = 'https://xxxxx.supabase.co'
const SUPA_KEY = 'eyJhbGc...'
```
من صفحة **الإعدادات → اتصال Supabase** داخل الملف نفسه.

---

## 📌 المهام القادمة المقترحة

- [ ] تفعيل Realtime subscriptions لتحديث لوحة القيادة تلقائياً
- [ ] تصدير PDF عبر server API (بدلاً من `window.print()`)
- [ ] رفع صور/مرفقات الأصول عبر Supabase Storage
- [ ] تطبيق PWA للعمل بدون اتصال (offline-first)
- [ ] تطبيق موبايل عبر Capacitor
