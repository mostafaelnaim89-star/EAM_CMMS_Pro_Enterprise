<template>
  <div class="system-root">
    <Transition name="screen-fade" mode="out-in">
      <div v-if="flow !== 'dashboard'" class="entry-layer">
        <SplashScreen v-if="flow === 'splash'" @start="flow = 'role'" />
        <RoleSelection v-else-if="flow === 'role'" @select="handleRoleSelect" @back="flow = 'splash'" />
        <LoginScreen v-else :role-name="selectedRole?.title" :initial-email="selectedRole?.email" @login="submitLogin" @change-role="flow = 'role'" />
      </div>

      <div v-else class="page-content dashboard-page">
        <div class="page-heading">
          <div>
            <div class="breadcrumb">الرئيسية <span>/</span> لوحة القيادة التنفيذية</div>
            <h1>لوحة القيادة التنفيذية</h1>
            <p>نظرة موحدة على أداء الأصول والمحطات والصيانة والتكاليف في قطاعات مدن القناة.</p>
          </div>
          <div class="heading-actions">
            <span class="last-sync">آخر مزامنة: {{ lastSync }}</span>
            <button class="secondary-button" type="button" @click="refreshDashboard">↻ تحديث البيانات</button>
            <NuxtLink class="primary-button" to="/reports"><span>▥</span> التقرير التنفيذي</NuxtLink>
          </div>
        </div>

        <section class="executive-banner">
          <div class="banner-copy"><span class="banner-label">EAM_CMMS_PRO · تقرير الأداء المؤسسي</span><h2>النظام يعمل <strong>بكفاءة مستقرة</strong></h2><p>تتم متابعة 81 محطة و1,248 أصلاً عبر 3 قطاعات تشغيلية مع ربط التكلفة والصيانة الوقائية.</p></div>
          <div class="banner-score"><div class="score-ring"><strong>94.2%</strong><span>الإنجاز العام</span></div><div class="score-trend"><b>↑ 4.8%</b><small>مقارنة بالشهر السابق</small></div></div>
        </section>

        <section class="kpi-grid" aria-label="مؤشرات النظام">
          <article v-for="kpi in kpis" :key="kpi.label" class="kpi-card" :class="kpi.tone"><div class="kpi-icon">{{ kpi.icon }}</div><div class="kpi-body"><span>{{ kpi.label }}</span><strong>{{ kpi.value }}</strong><small :class="kpi.trend > 0 ? 'up' : 'down'">{{ kpi.trend > 0 ? '↑' : '↓' }} {{ Math.abs(kpi.trend) }}% <em>عن الشهر السابق</em></small></div><div class="sparkline" aria-hidden="true"><i v-for="(height, index) in kpi.spark" :key="index" :style="{ height: `${height}%` }"></i></div></article>
        </section>

        <div class="section-heading"><div><h2>أداء القطاعات التشغيلية</h2><p>التوزيع الحالي للمحطات والصحة التشغيلية</p></div><NuxtLink class="link-button" to="/stations">عرض كل المحطات ←</NuxtLink></div>
        <section class="sector-grid"><article v-for="sector in sectors" :key="sector.name" class="sector-card" @click="openSector(sector.name)"><div class="sector-top"><span class="sector-icon">{{ sector.icon }}</span><span class="sector-status" :class="sector.statusClass">{{ sector.status }}</span></div><h3>قطاع {{ sector.name }}</h3><div class="sector-meta"><span>{{ sector.stations }} محطة</span><span>{{ sector.assets }} أصل</span></div><div class="metric-row"><span>الصحة التشغيلية</span><strong>{{ sector.health }}%</strong></div><div class="progress"><i :style="{ width: `${sector.health}%`, background: sector.color }"></i></div><div class="sector-bottom"><span>تكلفة الكهرباء <b>{{ sector.electricity }}</b></span><span class="sector-trend">↑ {{ sector.change }}%</span></div></article></section>

        <div class="content-grid two-columns">
          <section class="dashboard-card large-card"><div class="card-heading"><div><h2>حالة أوامر العمل</h2><p>آخر 6 أشهر — أوامر مفتوحة ومغلقة</p></div><NuxtLink class="link-button" to="/work-orders">التفاصيل ←</NuxtLink></div><div class="line-chart"><div class="chart-y"><span>160</span><span>120</span><span>80</span><span>40</span><span>0</span></div><div class="chart-main"><div class="grid-lines"><i v-for="n in 5" :key="n"></i></div><div class="chart-bars"><div v-for="bar in workChart" :key="bar.month" class="bar-group"><div class="bar-stack"><i class="bar-open" :style="{ height: `${bar.open / 160 * 100}%` }"></i><i class="bar-closed" :style="{ height: `${bar.closed / 160 * 100}%` }"></i></div><span>{{ bar.month }}</span></div></div></div></div><div class="chart-legend"><span><i class="legend-open"></i> مفتوحة</span><span><i class="legend-closed"></i> مغلقة</span><b>معدل الإغلاق 86%</b></div></section>
          <section class="dashboard-card large-card"><div class="card-heading"><div><h2>صحة الأصول</h2><p>توزيع الأصول حسب الحالة الحرجة</p></div><NuxtLink class="link-button" to="/assets">إدارة الأصول ←</NuxtLink></div><div class="asset-health"><div class="donut"><div><strong>1,248</strong><span>إجمالي أصل</span></div></div><div class="health-legend"><div v-for="item in healthItems" :key="item.label"><i :style="{ background: item.color }"></i><span>{{ item.label }}</span><b>{{ item.value }}</b></div></div></div><div class="health-footer"><span>الأصول الحرجة</span><strong>47</strong><small>تحتاج متابعة عاجلة</small></div></section>
        </div>

        <div class="content-grid three-columns">
          <section class="dashboard-card table-card"><div class="card-heading"><div><h2>أوامر العمل ذات الأولوية</h2><p>تحتاج إلى إجراء خلال 48 ساعة</p></div><NuxtLink class="link-button" to="/work-orders">كل الأوامر ←</NuxtLink></div><div class="work-list"><div v-for="order in priorityOrders" :key="order.id" class="work-row"><span class="priority-dot" :class="order.level"></span><div class="work-copy"><strong>{{ order.title }}</strong><small>{{ order.station }} · {{ order.id }}</small></div><span class="work-status" :class="order.statusClass">{{ order.status }}</span></div></div></section>
          <section class="dashboard-card cost-card"><div class="card-heading"><div><h2>التكاليف التشغيلية</h2><p>يونيو 2026 — الجنيه المصري</p></div><NuxtLink class="link-button" to="/costs">التفاصيل ←</NuxtLink></div><div class="cost-total"><strong>7.04M</strong><span>إجمالي التكلفة الفعلية</span><b>↓ 2.4%</b></div><div class="cost-bars"><div v-for="cost in costs" :key="cost.label"><span>{{ cost.label }}</span><i><em :style="{ width: `${cost.percent}%`, background: cost.color }"></em></i><b>{{ cost.value }}</b></div></div></section>
          <section class="dashboard-card activity-card"><div class="card-heading"><div><h2>آخر الأنشطة</h2><p>سجل الأحداث الحية للنظام</p></div><NuxtLink class="link-button" to="/reports">السجل الكامل ←</NuxtLink></div><div class="activity-list"><div v-for="activity in activities" :key="activity.time + activity.text"><span class="activity-icon">{{ activity.icon }}</span><div><strong>{{ activity.text }}</strong><small>{{ activity.time }}</small></div></div></div></section>
        </div>

        <section class="report-update"><div class="report-update-head"><strong>بيانات التقارير الموثقة</strong><span>يونيو 2026 / موازنة 2027</span></div><div class="report-update-grid"><span>بورسعيد — تكلفة فعلية:<b>2.077M ج.م</b></span><span>الإنتاج الشهري:<b>1,271,780 م³</b></span><span>متوسط التشغيل:<b>76.7%</b></span><span>موازنة 2027:<b>27.573M ج.م</b></span></div></section>
        <AiAssistant />
      </div>
    </Transition>
    <div v-if="toast" class="toast-message">✓ {{ toast }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'
import SplashScreen from '~/components/auth/SplashScreen.vue'
import RoleSelection from '~/components/auth/RoleSelection.vue'
import LoginScreen from '~/components/auth/LoginScreen.vue'
import AiAssistant from '~/components/AiAssistant.vue'

type Flow = 'splash' | 'role' | 'login' | 'dashboard'
type Role = { key: string; title: string; icon: string; description: string; email: string }

useHead({ title: 'EAM_CMMS_Pro — لوحة القيادة التنفيذية' })

const flow = ref<Flow>('splash')
const selectedRole = ref<Role | null>(null)
const toast = ref('')
const lastSync = ref('الآن')
let toastTimer: ReturnType<typeof setTimeout> | undefined

const kpis = [
  { label: 'إجمالي المحطات', value: '81', icon: '⛫', tone: '', trend: 3.2, spark: [35, 45, 42, 58, 52, 68, 75] },
  { label: 'الأصول المسجلة', value: '1,248', icon: '◈', tone: 'teal', trend: 6.4, spark: [45, 51, 55, 59, 65, 70, 78] },
  { label: 'أوامر العمل المفتوحة', value: '127', icon: '▣', tone: 'red', trend: -8.1, spark: [80, 70, 76, 62, 57, 49, 42] },
  { label: 'نسبة الإنجاز العام', value: '94.2%', icon: '✓', tone: 'green', trend: 4.8, spark: [60, 62, 66, 68, 73, 78, 86] }
]

const sectors = [
  { name: 'السويس', health: 88, stations: 11, assets: '362', electricity: '3.12M', change: 5.1, icon: '⚓', color: '#F07C2A', status: 'مستقر', statusClass: 'stable' },
  { name: 'الإسماعيلية', health: 84, stations: 64, assets: '714', electricity: '2.18M', change: 3.8, icon: '◉', color: '#00B4A6', status: 'تحت المتابعة', statusClass: 'watch' },
  { name: 'بورسعيد', health: 87, stations: 6, assets: '172', electricity: '1.74M', change: 4.2, icon: '▦', color: '#8A6EFF', status: 'مستقر', statusClass: 'stable' }
]

const workChart = [{ month: 'يناير', open: 104, closed: 88 }, { month: 'فبراير', open: 121, closed: 96 }, { month: 'مارس', open: 86, closed: 113 }, { month: 'أبريل', open: 132, closed: 104 }, { month: 'مايو', open: 112, closed: 125 }, { month: 'يونيو', open: 127, closed: 146 }]
const healthItems = [{ label: 'سليم', value: '64.8%', color: '#2ECC71' }, { label: 'جيد', value: '21.6%', color: '#00B4A6' }, { label: 'تحت المراقبة', value: '8.4%', color: '#F5A623' }, { label: 'حرج', value: '5.2%', color: '#E84545' }]
const priorityOrders = [{ id: 'WO-2026-0412', title: 'اهتزاز غير طبيعي في مضخة الرفع', station: 'أبو عارف الجديدة', level: 'critical', status: 'عاجل', statusClass: 'danger' }, { id: 'WO-2026-0408', title: 'استبدال مانع تسرب المحرك', station: 'عين غصين الكبرى', level: 'high', status: 'مجدول', statusClass: 'warning' }, { id: 'WO-2026-0399', title: 'فحص لوحة التحكم الرئيسية', station: 'جنيفة', level: 'medium', status: 'قيد التنفيذ', statusClass: 'info' }, { id: 'WO-2026-0392', title: 'تنظيف حوض الترويب', station: 'العمدة صالح', level: 'medium', status: 'مجدول', statusClass: 'warning' }]
const costs = [{ label: 'كهرباء', value: '4.92M', percent: 70, color: '#F07C2A' }, { label: 'كيماويات', value: '0.86M', percent: 39, color: '#00B4A6' }, { label: 'قطع غيار', value: '0.71M', percent: 31, color: '#8A6EFF' }, { label: 'تشغيل', value: '0.55M', percent: 25, color: '#D4AF37' }]
const activities = [{ icon: '✓', text: 'إغلاق أمر العمل WO-2026-0387', time: 'منذ 8 دقائق · مدير الصيانة' }, { icon: '⚠', text: 'انخفاض كفاءة محطة الضبعية إلى 70%', time: 'منذ 24 دقيقة · نظام المراقبة' }, { icon: '▤', text: 'استلام شحنة قطع غيار جديدة', time: 'منذ 41 دقيقة · المخازن' }, { icon: '↻', text: 'تشغيل خطة الصيانة الوقائية الشهرية', time: 'منذ ساعة · النظام الآلي' }]

function handleRoleSelect(role: Role) { selectedRole.value = role; flow.value = 'login' }
function submitLogin() { flow.value = 'dashboard'; showToast('تم تسجيل الدخول إلى النظام الموحد') }
function refreshDashboard() { lastSync.value = new Intl.DateTimeFormat('ar-EG', { hour: '2-digit', minute: '2-digit' }).format(new Date()); showToast('تم تحديث مؤشرات النظام') }
function openSector(name: string) { navigateTo(`/stations?sector=${encodeURIComponent(name)}`) }
function showToast(message: string) { toast.value = message; if (toastTimer) clearTimeout(toastTimer); toastTimer = setTimeout(() => { toast.value = '' }, 3000) }
onMounted(() => { if (process.client && sessionStorage.getItem('eam_logged_user')) flow.value = 'dashboard' })
onUnmounted(() => { if (toastTimer) clearTimeout(toastTimer) })
</script>

<style scoped>
.system-root{min-height:100%;background:var(--navy-deep)}.entry-layer{position:fixed;inset:0;z-index:1000}.dashboard-page{min-height:100%;padding-bottom:40px}.content-grid{display:grid;gap:12px;margin-bottom:12px}.two-columns{grid-template-columns:1.35fr 1fr}.three-columns{grid-template-columns:1.2fr 1fr 1fr}.dashboard-card{background:var(--card);border:1px solid var(--bdim);border-radius:10px;padding:15px;min-width:0}.large-card{min-height:265px}.table-card,.cost-card,.activity-card{min-height:275px}.card-heading{display:flex;align-items:flex-start;justify-content:space-between;gap:10px;margin-bottom:17px}.card-heading h2{font-size:14px}.card-heading p{font-size:9px;color:var(--text-dim);margin-top:2px}.line-chart{display:flex;height:160px;gap:10px}.chart-y{display:flex;flex-direction:column;justify-content:space-between;color:var(--text-muted);font:8px 'JetBrains Mono';padding-bottom:18px}.chart-main{flex:1;position:relative;padding-bottom:22px}.grid-lines{position:absolute;inset:0;display:flex;flex-direction:column;justify-content:space-between}.grid-lines i{border-top:1px dashed rgba(255,255,255,.07);width:100%}.chart-bars{height:100%;display:flex;align-items:flex-end;justify-content:space-around;position:relative;z-index:1}.bar-group{height:100%;display:flex;flex-direction:column;justify-content:flex-end;align-items:center;gap:6px;min-width:24px}.bar-group>span{font-size:8px;color:var(--text-muted);position:absolute;bottom:-18px}.bar-stack{height:calc(100% - 10px);display:flex;align-items:flex-end;gap:2px}.bar-stack i{width:8px;display:block;border-radius:3px 3px 0 0}.bar-open{background:linear-gradient(180deg,var(--orange),var(--orange-dim))}.bar-closed{background:linear-gradient(180deg,var(--teal),#007a72)}.chart-legend{display:flex;align-items:center;gap:14px;margin-top:12px;color:var(--text-dim);font-size:8px}.chart-legend span{display:flex;align-items:center;gap:5px}.chart-legend i{width:8px;height:8px;border-radius:2px;display:inline-block}.legend-open{background:var(--orange)}.legend-closed{background:var(--teal)}.chart-legend b{margin-right:auto;color:var(--green);font-weight:600}.asset-health{display:flex;align-items:center;justify-content:space-around;gap:12px}.donut{width:132px;height:132px;border-radius:50%;display:grid;place-items:center;background:conic-gradient(var(--green) 0 64.8%,var(--teal) 64.8% 86.4%,var(--yellow) 86.4% 94.8%,var(--red) 94.8% 100%);position:relative}.donut:after{content:'';position:absolute;inset:13px;border-radius:50%;background:var(--navy-mid)}.donut>div{position:relative;z-index:1;text-align:center}.donut strong,.donut span{display:block}.donut strong{font:900 18px 'JetBrains Mono'}.donut span{font-size:8px;color:var(--text-dim);margin-top:2px}.health-legend{flex:1}.health-legend>div{display:flex;align-items:center;gap:5px;font-size:8px;margin:7px 0;color:var(--text-dim)}.health-legend i{width:7px;height:7px;border-radius:2px}.health-legend b{margin-right:auto;font:600 9px 'JetBrains Mono';color:var(--text)}.health-footer{display:flex;align-items:center;border-top:1px solid var(--bdim);margin-top:14px;padding-top:10px;font-size:9px;color:var(--text-dim)}.health-footer strong{font:900 14px 'JetBrains Mono';margin:0 8px}.health-footer small{color:var(--green);font-size:8px}.work-list,.activity-list,.cost-bars{display:flex;flex-direction:column;gap:1px}.work-row{display:flex;align-items:center;gap:8px;padding:10px 0;border-bottom:1px solid var(--bdim)}.priority-dot{width:7px;height:7px;border-radius:50%;flex:0 0 7px;background:var(--yellow)}.priority-dot.critical{background:var(--red);box-shadow:0 0 8px rgba(232,69,69,.55)}.priority-dot.high{background:var(--orange)}.work-copy{min-width:0;flex:1}.work-copy strong,.work-copy small{display:block;white-space:nowrap;overflow:hidden;text-overflow:ellipsis}.work-copy strong{font-size:9px}.work-copy small{font-size:8px;color:var(--text-muted);margin-top:3px}.work-status{font-size:8px;padding:3px 6px;border-radius:4px}.work-status.danger{color:var(--red);background:rgba(232,69,69,.11)}.work-status.warning{color:var(--yellow);background:rgba(245,166,35,.11)}.work-status.info{color:var(--teal);background:rgba(0,180,166,.11)}.cost-total{display:flex;align-items:baseline;gap:8px;margin:4px 0 17px}.cost-total strong{font:900 22px 'JetBrains Mono'}.cost-total span{font-size:8px;color:var(--text-dim)}.cost-total b{margin-right:auto;color:var(--green);font:700 9px 'JetBrains Mono'}.cost-bars>div{display:grid;grid-template-columns:50px 1fr 45px;align-items:center;gap:7px;margin:12px 0;font-size:8px;color:var(--text-dim)}.cost-bars i{height:6px;background:rgba(255,255,255,.06);border-radius:5px;overflow:hidden}.cost-bars em{display:block;height:100%;border-radius:5px}.cost-bars b{text-align:left;font:700 8px 'JetBrains Mono';color:var(--text)}.activity-list>div{display:flex;gap:8px;align-items:flex-start;padding:9px 0;border-bottom:1px solid var(--bdim)}.activity-icon{width:22px;height:22px;border-radius:7px;background:rgba(0,180,166,.1);color:var(--teal);display:grid;place-items:center;font-size:11px;flex:0 0 22px}.activity-list strong,.activity-list small{display:block}.activity-list strong{font-size:9px}.activity-list small{font-size:8px;color:var(--text-muted);margin-top:3px}.toast-message{position:fixed;bottom:24px;right:50%;transform:translateX(50%);z-index:2000;background:var(--green);color:#061b12;padding:9px 18px;border-radius:22px;font-size:10px;font-weight:800;box-shadow:0 8px 28px rgba(0,0,0,.25)}@media(max-width:1100px){.kpi-grid{grid-template-columns:repeat(2,1fr)}.two-columns,.three-columns{grid-template-columns:1fr}.sector-grid{grid-template-columns:repeat(3,1fr)}}@media(max-width:650px){.page-content{padding:16px 13px 28px}.page-heading{display:block}.heading-actions{margin-top:13px}.kpi-grid,.sector-grid{grid-template-columns:1fr}.banner-score{display:none}.report-update-grid{grid-template-columns:repeat(2,1fr)!important}.asset-health{justify-content:space-between}.donut{width:110px;height:110px}.card-heading{margin-bottom:12px}}
</style>
