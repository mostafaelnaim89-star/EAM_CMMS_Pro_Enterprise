<template>
  <div class="page-container integrations-page">
    <div class="page-heading">
      <div>
        <div class="breadcrumb">الإدارة <span>/</span> التكاملات</div>
        <h1>مركز التكاملات المؤسسية</h1>
        <p>إدارة اتصال نظام EAM_CMMS_Pro مع مكتبة Obsidian ولوحات Monday.com وبيئة Replit.</p>
      </div>
      <div class="heading-actions">
        <button class="secondary-button" type="button" :disabled="loading" @click="refreshStatus">{{ loading ? 'جاري الفحص...' : '↻ فحص الاتصالات' }}</button>
      </div>
    </div>

    <section class="notice-card">
      <div class="notice-icon">⌘</div>
      <div>
        <strong>حماية بيانات الاتصال</strong>
        <p>لا يتم حفظ مفاتيح API في الواجهة أو المستودع. تُقرأ الأسرار من متغيرات البيئة في الخادم، وتظهر هنا حالة الإعداد فقط.</p>
      </div>
    </section>

    <section class="integration-grid">
      <article class="integration-card obsidian-card">
        <div class="integration-topline">
          <div class="platform-mark obsidian-mark">◈</div>
          <div class="platform-title"><h2>Obsidian</h2><span>المكتبة الفنية وملفات SOP</span></div>
          <span class="status-pill" :class="statusClass(status.obsidian)">{{ statusLabel(status.obsidian) }}</span>
        </div>
        <p class="integration-description">تم تجهيز مجلد <code>obsidian-vault</code> داخل المشروع ليُفتح مباشرة كـ Vault في Obsidian، مع ملفات Markdown للأصول والإجراءات والمعايير الفنية.</p>
        <div class="integration-meta"><span>الصيغة</span><strong>Markdown / Wiki-links</strong></div>
        <div class="integration-meta"><span>المسار</span><strong>obsidian-vault/</strong></div>
        <div class="card-actions">
          <a class="secondary-button" :href="obsidianLink" target="_blank" rel="noreferrer">فتح مجلد Vault</a>
          <button class="primary-button" type="button" @click="copyText('obsidian-vault')">{{ copied === 'obsidian-vault' ? 'تم النسخ' : 'نسخ اسم المجلد' }}</button>
        </div>
        <small class="hint">للمزامنة الآلية من خادم Obsidian، أضف إضافة Local REST API ثم عرّف OBSIDIAN_API_URL و OBSIDIAN_API_KEY في بيئة التشغيل.</small>
      </article>

      <article class="integration-card monday-card">
        <div class="integration-topline">
          <div class="platform-mark monday-mark">▦</div>
          <div class="platform-title"><h2>Monday.com</h2><span>أوامر العمل والمهام</span></div>
          <span class="status-pill" :class="statusClass(status.monday)">{{ statusLabel(status.monday) }}</span>
        </div>
        <p class="integration-description">يدعم النظام إنشاء عنصر جديد في لوحة Monday.com من أمر العمل، باستخدام Monday GraphQL API من الخادم فقط.</p>
        <div class="integration-meta"><span>العملية</span><strong>إنشاء Work Item</strong></div>
        <div class="integration-meta"><span>المتطلبات</span><strong>MONDAY_API_TOKEN · MONDAY_BOARD_ID</strong></div>
        <div class="card-actions">
          <button class="secondary-button" type="button" :disabled="mondayChecking" @click="checkMonday">{{ mondayChecking ? 'جاري الاختبار...' : 'اختبار الاتصال' }}</button>
          <a class="primary-button" href="https://developer.monday.com/api-reference/reference/items" target="_blank" rel="noreferrer">الوثائق الرسمية</a>
        </div>
        <small class="hint">تم تجهيز نقطة API داخل التطبيق، لكنها لا تنشئ عناصر فعلية إلا بعد إضافة بيانات Monday.com إلى بيئة الإنتاج واستدعاء المزامنة.</small>
      </article>

      <article class="integration-card replit-card">
        <div class="integration-topline">
          <div class="platform-mark replit-mark">▶</div>
          <div class="platform-title"><h2>Replit</h2><span>التشغيل والتطوير السحابي</span></div>
          <span class="status-pill ready">جاهز للاستيراد</span>
        </div>
        <p class="integration-description">تمت إضافة ملفات <code>.replit</code> و <code>replit.nix</code>، وأصبح المشروع قابلاً للاستيراد من GitHub وتشغيله كـ Nuxt App داخل Replit.</p>
        <div class="integration-meta"><span>المستودع</span><strong class="repo-value">EAM_CMMS_Pro_Enterprise</strong></div>
        <div class="integration-meta"><span>أمر التشغيل</span><strong>npm run dev -- --host 0.0.0.0</strong></div>
        <div class="card-actions">
          <a class="primary-button" href="https://replit.com/import" target="_blank" rel="noreferrer">استيراد إلى Replit</a>
          <button class="secondary-button" type="button" @click="copyText(repositoryUrl)">{{ copied === repositoryUrl ? 'تم النسخ' : 'نسخ رابط GitHub' }}</button>
        </div>
        <small class="hint">بعد الاستيراد، أضف أسرار Supabase وMonday.com من قسم Secrets داخل Replit؛ لا تنتقل الأسرار تلقائياً مع المستودع.</small>
      </article>
    </section>

    <section class="setup-panel">
      <div class="setup-header"><div><span class="eyebrow">تهيئة الإنتاج</span><h2>متغيرات البيئة المطلوبة</h2></div><span class="secure-badge">🔒 خادم فقط</span></div>
      <div class="env-table">
        <div class="env-row env-head"><span>المتغير</span><span>الوظيفة</span><span>الحالة</span></div>
        <div v-for="item in envItems" :key="item.key" class="env-row"><code>{{ item.key }}</code><span>{{ item.description }}</span><span class="env-state" :class="item.configured ? 'configured' : 'pending'">{{ item.configured ? 'مُعدّ' : 'بانتظار الإعداد' }}</span></div>
      </div>
      <p class="setup-note">أضف هذه القيم في Vercel أو Replit أو ملف البيئة المحلي. لا تضعها داخل ملفات Vue أو GitHub.</p>
    </section>

    <div v-if="toast" class="toast-message">✓ {{ toast }}</div>
  </div>
</template>

<script setup lang="ts">
import { computed, onMounted, ref } from 'vue'

useHead({ title: 'EAM_CMMS_Pro — مركز التكاملات' })
definePageMeta({ layout: 'default' })

interface IntegrationStatus { configured: boolean; detail?: string }
interface StatusResponse { monday: IntegrationStatus; obsidian: IntegrationStatus; replit: IntegrationStatus }

const repositoryUrl = 'https://github.com/mostafaelnaim89-star/EAM_CMMS_Pro_Enterprise'
const obsidianLink = repositoryUrl + '/tree/main/obsidian-vault'
const loading = ref(false)
const mondayChecking = ref(false)
const copied = ref('')
const toast = ref('')
const status = ref<StatusResponse>({
  monday: { configured: false },
  obsidian: { configured: false },
  replit: { configured: true }
})

const envItems = computed(() => [
  { key: 'MONDAY_API_TOKEN', description: 'رمز Monday API للوصول الآمن إلى GraphQL', configured: status.value.monday.configured },
  { key: 'MONDAY_BOARD_ID', description: 'معرّف اللوحة التي تستقبل أوامر العمل', configured: status.value.monday.configured },
  { key: 'OBSIDIAN_API_URL', description: 'رابط Local REST API عند تشغيل Obsidian Bridge', configured: status.value.obsidian.configured },
  { key: 'OBSIDIAN_API_KEY', description: 'مفتاح Local REST API — لا يظهر للمتصفح', configured: status.value.obsidian.configured }
])

const statusLabel = (item: IntegrationStatus) => item.configured ? 'متصل ومُعدّ' : 'بانتظار الإعداد'
const statusClass = (item: IntegrationStatus) => item.configured ? 'connected' : 'pending'

async function refreshStatus() {
  loading.value = true
  try { status.value = await $fetch<StatusResponse>('/api/integrations/status') }
  catch { showToast('تعذر قراءة حالة التكاملات') }
  finally { loading.value = false }
}

async function checkMonday() {
  mondayChecking.value = true
  try {
    const result = await $fetch<{ success: boolean; message: string }>('/api/integrations/monday/health')
    showToast(result.message)
    await refreshStatus()
  } catch (error: any) {
    showToast(error?.data?.message || 'تعذر اختبار Monday.com')
  } finally { mondayChecking.value = false }
}

async function copyText(value: string) {
  try {
    await navigator.clipboard.writeText(value)
    copied.value = value
    showToast('تم نسخ القيمة')
    setTimeout(() => copied.value = '', 1800)
  } catch { showToast('تعذر النسخ تلقائياً') }
}

function showToast(message: string) { toast.value = message; setTimeout(() => toast.value = '', 3500) }
onMounted(refreshStatus)
</script>

<style scoped>
.page-container { padding: 24px; font-family: 'Cairo', sans-serif; color: #E8EDF5; }
.page-heading { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 22px; gap: 16px; flex-wrap: wrap; }
.page-heading h1 { font-size: 22px; font-weight: 900; color: #F07C2A; margin-top: 4px; }
.page-heading p { color: #7A8FAD; font-size: 11px; margin-top: 4px; }
.heading-actions, .card-actions { display: flex; gap: 10px; flex-wrap: wrap; }
.notice-card, .setup-panel, .integration-card { background: rgba(22, 42, 80, .52); border: 1px solid rgba(255,255,255,.08); border-radius: 14px; }
.notice-card { padding: 15px 18px; display: flex; align-items: flex-start; gap: 12px; margin-bottom: 18px; }
.notice-icon { width: 38px; height: 38px; border-radius: 10px; display: grid; place-items: center; background: rgba(0,180,166,.13); color: #00B4A6; font-size: 20px; }
.notice-card strong { display: block; font-size: 13px; color: #F1F5FA; }
.notice-card p { color: #8EA3BF; font-size: 11px; margin-top: 3px; }
.integration-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 18px; }
.integration-card { padding: 18px; min-height: 340px; display: flex; flex-direction: column; }
.integration-card:hover { border-color: rgba(240,124,42,.3); }
.integration-topline { display: flex; align-items: center; gap: 10px; }
.platform-mark { width: 44px; height: 44px; border-radius: 12px; display: grid; place-items: center; font-weight: 900; font-size: 20px; }
.obsidian-mark { background: rgba(126,92,255,.16); color: #A98CFF; }
.monday-mark { background: rgba(97,97,255,.16); color: #8D8DFF; }
.replit-mark { background: rgba(245,166,35,.16); color: #F5A623; }
.platform-title { flex: 1; min-width: 0; }
.platform-title h2 { font-size: 16px; color: #F3F6FA; }
.platform-title span { color: #7A8FAD; font-size: 10px; }
.status-pill { font-size: 9px; font-weight: 800; border-radius: 20px; padding: 4px 8px; white-space: nowrap; }
.status-pill.connected, .status-pill.ready { color: #2ECC71; background: rgba(46,204,113,.12); }
.status-pill.pending { color: #F5A623; background: rgba(245,166,35,.12); }
.integration-description { color: #A9B8CB; font-size: 11px; line-height: 1.9; margin: 16px 0 12px; }
.integration-description code, .env-row code { color: #F5A623; font-family: 'JetBrains Mono', monospace; font-size: 10px; }
.integration-meta { border-top: 1px solid rgba(255,255,255,.06); padding: 9px 0; display: flex; justify-content: space-between; gap: 10px; font-size: 10px; }
.integration-meta span { color: #7A8FAD; }
.integration-meta strong { color: #DCE5F0; font-family: 'JetBrains Mono', 'Cairo', sans-serif; font-size: 9px; text-align: left; }
.repo-value { direction: ltr; overflow: hidden; text-overflow: ellipsis; }
.card-actions { margin-top: auto; padding-top: 14px; }
.primary-button, .secondary-button { text-decoration: none; border-radius: 7px; padding: 8px 11px; font-family: 'Cairo', sans-serif; font-size: 10px; cursor: pointer; border: 1px solid transparent; }
.primary-button { color: #fff; background: #F07C2A; border-color: #F07C2A; }
.secondary-button { color: #DCE5F0; background: rgba(255,255,255,.04); border-color: rgba(255,255,255,.1); }
.primary-button:hover, .secondary-button:hover { filter: brightness(1.1); }
.primary-button:disabled, .secondary-button:disabled { opacity: .55; cursor: wait; }
.hint { color: #7086A4; font-size: 9px; line-height: 1.8; margin-top: 13px; }
.setup-panel { padding: 18px; }
.setup-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 14px; }
.eyebrow { color: #00B4A6; font-size: 10px; font-weight: 800; }
.setup-header h2 { font-size: 17px; color: #F1F5FA; margin-top: 3px; }
.secure-badge { color: #00B4A6; font-size: 10px; }
.env-table { border: 1px solid rgba(255,255,255,.07); border-radius: 9px; overflow: hidden; }
.env-row { display: grid; grid-template-columns: 1.1fr 2fr .8fr; gap: 12px; padding: 11px 13px; border-top: 1px solid rgba(255,255,255,.06); align-items: center; font-size: 10px; color: #9EB1C9; }
.env-row:first-child { border-top: 0; }
.env-head { color: #6F85A3; background: rgba(255,255,255,.03); font-weight: 800; }
.env-state { justify-self: start; border-radius: 20px; padding: 3px 7px; font-size: 9px; }
.env-state.configured { color: #2ECC71; background: rgba(46,204,113,.12); }
.env-state.pending { color: #F5A623; background: rgba(245,166,35,.12); }
.setup-note { color: #7086A4; font-size: 10px; margin-top: 12px; }
.toast-message { position: fixed; bottom: 26px; left: 26px; z-index: 60; background: #162A50; border: 1px solid #F07C2A; color: #F5F7FA; padding: 12px 18px; border-radius: 8px; font-size: 11px; box-shadow: 0 8px 25px rgba(0,0,0,.3); }
@media (max-width: 1000px) { .integration-grid { grid-template-columns: 1fr; } .integration-card { min-height: auto; } }
@media (max-width: 600px) { .page-container { padding: 15px; } .env-row { grid-template-columns: 1fr; gap: 5px; } .env-head { display: none; } .env-state { justify-self: start; } }
</style>
