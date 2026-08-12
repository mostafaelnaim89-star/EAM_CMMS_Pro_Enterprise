# مراجع التكاملات الخارجية

## Monday.com

- الوثائق الأساسية: https://developer.monday.com/api-reference/docs/basics
- مرجع العناصر: https://developer.monday.com/api-reference/reference/items
- النمط المستخدم في النظام: GraphQL عبر `POST https://api.monday.com/v2` مع ترويسة `Authorization`.
- فحص الاتصال: الاستعلام `{ me { id name email } }`.
- العملية المدمجة: `create_item` لإنشاء عنصر أمر عمل داخل لوحة محددة.
- متطلبات النظام: `MONDAY_API_TOKEN` و`MONDAY_BOARD_ID`، مع `MONDAY_GROUP_ID` اختياري.

## Obsidian

- يستخدم النظام ملفات Markdown داخل `obsidian-vault/` لتوثيق إجراءات التشغيل والمعايير الفنية.
- المزامنة الآلية مع نسخة Obsidian البعيدة تحتاج Bridge أو Local REST API قابل للوصول من خادم الاستضافة.
- لا يجب افتراض أن `127.0.0.1` في الاستضافة يشير إلى جهاز المستخدم؛ لذلك تُعد قيم Obsidian اختيارية حتى توفير عنوان Bridge مناسب.

## Replit

- دليل الاستيراد: https://docs.replit.com/build/import-from-providers
- ملفات التهيئة الموجودة في جذر المشروع: `.replit` و`replit.nix`.
- يجب إدخال مفاتيح البيئة من Replit Secrets بعد استيراد المستودع، ولا تُدرج الأسرار داخل GitHub.
