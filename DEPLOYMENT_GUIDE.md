# دليل النشر والتشغيل الدائم — EAM_CMMS_Pro Enterprise

يسلط هذا الدليل الضوء على خطوات تشغيل نظام **EAM_CMMS_Pro Enterprise** كموقع ويب دائم على الإنترنت، مع تفعيل الربط السحابي وقواعد بيانات **Supabase** وأتمتة العمليات عبر **n8n**.

---

## 1. متطلبات التشغيل الدائم
- **استضافة سحابية متوافقة مع Nuxt 3/Nitro**: (مثل Vercel, Netlify, أو Cloudflare Pages).
- **قاعدة بيانات Supabase**: تم إعداد ملفات الهجرة (`.sql`) مسبقاً لتغطية الجداول، سياسات الأمان (RLS)، والمكتبة الفنية.
- **منصة n8n**: لإدارة مهام الأتمتة واستقبال إشعارات أوامر العمل والصيانة الوقائية عبر الـ Webhook.

---

## 2. خطوات النشر على Vercel (موصى به)
1. قم بربط مستودع GitHub الخاص بك (`mostafaelnaim89-star/EAM_CMMS_Pro_Enterprise`) بحسابك على [Vercel](https://vercel.com).
2. عند إعداد المشروع، استخدم الإعدادات التلقائية لـ Nuxt 3:
   - **Build Command**: `npm run build`
   - **Output Directory**: `.vercel/output`
3. قم بإضافة متغيرات البيئة (Environment Variables) التالية في لوحة تحكم Vercel:
   ```env
   SUPABASE_URL=https://agnnoiwclcflymecwzpz.supabase.co
   SUPABASE_ANON_KEY=EyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImFnbm5vaXdjbGNmbHltZWN3enB6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODM2ODA4NzIsImV4cCI6MjA5OTI1Njg3Mn0.dURqiKsfXm6QXV-iwnmOV0HmS9O8mbEjeAomdXhYZyA
   ```
4. اضغط **Deploy**، وسيحصل الموقع على رابط دائم ومستقر (Production URL) خلال دقائق.

---

## 3. ربط n8n بالمنصة الدائمة
1. في لوحة تحكم **n8n**، أنشئ Workflow جديد واستخدم **Webhook Trigger**.
2. انسخ رابط الـ Webhook الخاص بـ n8n.
3. داخل تطبيق EAM_CMMS_Pro، توجه إلى إعدادات التكامل وألصق الرابط لاستقبال:
   - تنبيهات انخفاض مخزون قطع الغيار.
   - إنشاء أوامر العمل التلقائية عند تجاوز حدود كفاءة المحطات.
   - تقارير استهلاك الطاقة والتشغيل اليومية.

---
*تم إعداد هذا المستند بواسطة Manus AI لصالح الشركة القابضة لمياه الشرب والصرف الصحي بمدن القناة.*
