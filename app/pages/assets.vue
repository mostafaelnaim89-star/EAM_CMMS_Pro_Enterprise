<template>
  <div class="page-container">
    <div class="page-heading">
      <div>
        <div class="breadcrumb">التشغيل والصيانة <span>/</span> الأصول والمعدات</div>
        <h1>إدارة الأصول والمعدات</h1>
        <p>التتبع الشامل للأصول الحيوية، الحالة الفنية، الصحة التشغيلية، ومؤشرات الموثوقية بقطاعات مدن القناة.</p>
      </div>
      <div class="heading-actions">
        <button class="secondary-button" type="button" @click="exportAssets">↓ تصدير التقارير</button>
        <button class="primary-button" type="button" @click="openAddModal"><span>+</span> تسجيل أصل جديد</button>
      </div>
    </div>

    <section class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">◈</div>
        <div class="stat-body"><span>إجمالي الأصول</span><strong>1,248</strong><small class="up">↑ 12 جديدة هذا الشهر</small></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon success">✓</div>
        <div class="stat-body"><span>الأصول بحالة ممتازة</span><strong>1,102</strong><small class="up">88.3% من الإجمالي</small></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon warning">⚠</div>
        <div class="stat-body"><span>تحت المراقبة والصيانة</span><strong>99</strong><small class="warning-text">تتطلب جدولة وقائية</small></div>
      </div>
      <div class="stat-card">
        <div class="stat-icon danger">⚡</div>
        <div class="stat-body"><span>أصول حرجة</span><strong>47</strong><small class="down">عطل محتمل خلال 48 ساعة</small></div>
      </div>
    </section>

    <div class="filters-bar">
      <div class="search-box">
        <span>⌕</span>
        <input v-model="searchQuery" type="text" placeholder="بحث برمز الأصل، الاسم، أو المحطة التابع لها..." />
      </div>
      <div class="filter-group">
        <select v-model="filterSector">
          <option value="">كل القطاعات</option>
          <option>السويس</option>
          <option>الإسماعيلية</option>
          <option>بورسعيد</option>
        </select>
        <select v-model="filterStatus">
          <option value="">كل الحالات الفنية</option>
          <option value="ok">ممتاز / مستقر</option>
          <option value="warn">يحتاج صيانة</option>
          <option value="crit">حرج جداً</option>
        </select>
      </div>
    </div>

    <div class="assets-grid">
      <div v-for="asset in filteredAssets" :key="asset.id" class="asset-card" :class="asset.status">
        <div class="ac-header">
          <div class="ac-icon" :style="{ background: asset.iconBg, color: asset.iconColor }">{{ asset.icon }}</div>
          <div class="ac-meta">
            <span class="ac-id">{{ asset.id }}</span>
            <span class="ac-status-badge" :class="asset.status">{{ asset.statusText }}</span>
          </div>
        </div>
        <div class="ac-body">
          <h3>{{ asset.name }}</h3>
          <p>{{ asset.station }} · قطاع {{ asset.sector }}</p>
          <div class="ac-metrics">
            <div><span>ساعات التشغيل</span><strong>{{ asset.runningHours.toLocaleString() }} س</strong></div>
            <div><span>كفاءة الأداء</span><strong>{{ asset.efficiency }}%</strong></div>
          </div>
        </div>
        <div class="ac-footer">
          <div class="health-bar-wrap">
            <div class="health-bar-bg">
              <div class="health-bar" :style="{ width: asset.efficiency + '%', background: getHealthColor(asset.efficiency) }"></div>
            </div>
          </div>
          <button class="btn-sm" @click="viewAssetDetails(asset)">التفاصيل</button>
        </div>
      </div>
    </div>

    <!-- Add/Edit Modal -->
    <div v-if="showModal" class="modal-overlay" @click.self="showModal = false">
      <div class="modal-content">
        <div class="modal-header">
          <h3>تسجيل أصل تشغيلي جديد</h3>
          <button class="close-btn" @click="showModal = false">✕</button>
        </div>
        <form @submit.prevent="saveAsset" class="modal-body">
          <div class="form-grid">
            <div class="form-group">
              <label>رمز الأصل (ID)</label>
              <input v-model="form.id" required placeholder="مثال: AST-PMP-804" />
            </div>
            <div class="form-group">
              <label>اسم المعدة أو الأصل</label>
              <input v-model="form.name" required placeholder="مثال: مضخة طرد رئيسية #3" />
            </div>
            <div class="form-group">
              <label>القطاع</label>
              <select v-model="form.sector" required>
                <option value="">— اختر القطاع —</option>
                <option>الإسماعيلية</option>
                <option>السويس</option>
                <option>بورسعيد</option>
              </select>
            </div>
            <div class="form-group">
              <label>المحطة التابع لها</label>
              <input v-model="form.station" required placeholder="مثال: محطة أبو عارف" />
            </div>
            <div class="form-group">
              <label>ساعات التشغيل (ساعة)</label>
              <input v-model.number="form.runningHours" type="number" />
            </div>
            <div class="form-group">
              <label>كفاءة الأداء (%)</label>
              <input v-model.number="form.efficiency" type="number" min="0" max="100" />
            </div>
          </div>
          <div class="modal-footer">
            <button type="button" class="secondary-button" @click="showModal = false">إلغاء</button>
            <button type="submit" class="primary-button">حفظ وإضافة</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="toast" class="toast-message">✓ {{ toast }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

useHead({ title: 'EAM_CMMS_Pro — إدارة الأصول والمعدات' })

interface Asset {
  id: string
  name: string
  station: string
  sector: string
  status: 'ok' | 'warn' | 'crit'
  statusText: string
  runningHours: number
  efficiency: number
  icon: string
  iconBg: string
  iconColor: string
}

const searchQuery = ref('')
const filterSector = ref('')
const filterStatus = ref('')
const showModal = ref(false)
const toast = ref('')

const form = ref({
  id: 'AST-' + Math.floor(Math.random() * 9000 + 1000),
  name: '',
  station: '',
  sector: 'الإسماعيلية',
  runningHours: 4200,
  efficiency: 92
})

const assets = ref<Asset[]>([
  { id: 'AST-PMP-104', name: 'مضخة طرد رئيسية #1', station: 'أبو عارف الجديدة', sector: 'السويس', status: 'ok', statusText: 'ممتاز', runningHours: 8420, efficiency: 94, icon: '⚡', iconBg: 'rgba(46,204,113,0.12)', iconColor: '#2ECC71' },
  { id: 'AST-PMP-105', name: 'مضخة الرفع العالي #2', station: 'جنيفة', sector: 'السويس', status: 'warn', statusText: 'يحتاج صيانة', runningHours: 12150, efficiency: 78, icon: '⚙️', iconBg: 'rgba(245,166,35,0.12)', iconColor: '#F5A623' },
  { id: 'AST-TRB-301', name: 'محول كهرباء 11 ك.ف', station: 'العمده صالح', sector: 'الإسماعيلية', status: 'ok', statusText: 'مستقر', runningHours: 15400, efficiency: 96, icon: '⚡', iconBg: 'rgba(0,180,166,0.12)', iconColor: '#00B4A6' },
  { id: 'AST-VLV-402', name: 'صمام تحكم هيدروليكي', station: 'عين غصين الكبرى', sector: 'الإسماعيلية', status: 'crit', statusText: 'حرج جداً', runningHours: 19800, efficiency: 62, icon: '⚠', iconBg: 'rgba(232,69,69,0.12)', iconColor: '#E84545' },
  { id: 'AST-FIL-501', name: 'مرشح رملي سريع #3', station: 'محطة بورسعيد الكبرى', sector: 'بورسعيد', status: 'ok', statusText: 'ممتاز', runningHours: 6200, efficiency: 91, icon: '◈', iconBg: 'rgba(240,124,42,0.12)', iconColor: '#F07C2A' }
])

const filteredAssets = computed(() => {
  return assets.value.filter(a => {
    const matchSearch = a.name.includes(searchQuery.value) || a.id.includes(searchQuery.value) || a.station.includes(searchQuery.value)
    const matchSector = !filterSector.value || a.sector === filterSector.value
    const matchStatus = !filterStatus.value || a.status === filterStatus.value
    return matchSearch && matchSector && matchStatus
  })
})

const getHealthColor = (eff: number) => {
  if (eff >= 90) return '#2ECC71'
  if (eff >= 75) return '#F5A623'
  return '#E84545'
}

const openAddModal = () => { showModal.value = true }
const saveAsset = () => {
  assets.value.unshift({
    id: form.value.id,
    name: form.value.name,
    station: form.value.station,
    sector: form.value.sector,
    status: form.value.efficiency >= 90 ? 'ok' : form.value.efficiency >= 75 ? 'warn' : 'crit',
    statusText: form.value.efficiency >= 90 ? 'ممتاز' : form.value.efficiency >= 75 ? 'يحتاج صيانة' : 'حرج',
    runningHours: form.value.runningHours,
    efficiency: form.value.efficiency,
    icon: '◈',
    iconBg: 'rgba(240,124,42,0.12)',
    iconColor: '#F07C2A'
  })
  showModal.value = false
  showToast('تم تسجيل الأصل بنجاح وتحديث قاعدة البيانات')
}

const viewAssetDetails = (asset: Asset) => {
  alert(`تفاصيل الأصل:\nالرمز: ${asset.id}\nالمعدة: ${asset.name}\nالمحطة: ${asset.station}\nساعات التشغيل: ${asset.runningHours} ساعة\nالكفاءة: ${asset.efficiency}%`)
}

const exportAssets = () => { showToast('جاري تصدير تقرير الأصول بصيغة Excel/PDF...') }
const showToast = (msg: string) => { toast.value = msg; setTimeout(() => toast.value = '', 3000) }
</script>

<style scoped>
.page-container { padding: 24px; font-family: 'Cairo', sans-serif; color: #E8EDF5; }
.page-heading { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; flex-wrap: wrap; gap: 15px; }
.page-heading h1 { font-size: 22px; font-weight: 900; color: #F07C2A; margin-top: 4px; }
.page-heading p { font-size: 11px; color: #7A8FAD; margin-top: 2px; }
.heading-actions { display: flex; gap: 10px; }

.stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 15px; margin-bottom: 24px; }
.stat-card { background: rgba(22, 42, 80, 0.5); border: 1px solid rgba(255, 255, 255, 0.07); border-radius: 12px; padding: 16px; display: flex; align-items: center; gap: 14px; }
.stat-icon { width: 42px; height: 42px; border-radius: 10px; background: rgba(240, 124, 42, 0.12); color: #F07C2A; display: grid; place-items: center; font-size: 20px; flex-shrink: 0; }
.stat-icon.success { background: rgba(46, 204, 113, 0.12); color: #2ECC71; }
.stat-icon.warning { background: rgba(245, 166, 35, 0.12); color: #F5A623; }
.stat-icon.danger { background: rgba(232, 69, 69, 0.12); color: #E84545; }
.stat-body span { display: block; font-size: 10px; color: #7A8FAD; }
.stat-body strong { display: block; font: 900 20px 'JetBrains Mono', monospace; margin: 2px 0; }
.stat-body small { font-size: 9px; font-weight: 700; }
.stat-body small.up { color: #2ECC71; }
.stat-body small.down { color: #E84545; }
.stat-body small.warning-text { color: #F5A623; }

.filters-bar { background: rgba(22, 42, 80, 0.5); border: 1px solid rgba(255, 255, 255, 0.07); border-radius: 10px; padding: 12px 16px; display: flex; gap: 15px; margin-bottom: 20px; flex-wrap: wrap; }
.search-box { flex: 1; min-width: 220px; position: relative; }
.search-box span { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #7A8FAD; }
.search-box input { width: 100%; background: rgba(255, 255, 255, 0.04); border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 7px; padding: 8px 34px 8px 12px; color: #fff; font-size: 12px; outline: none; }
.search-box input:focus { border-color: #F07C2A; }
.filter-group { display: flex; gap: 10px; }
.filter-group select { background: rgba(255, 255, 255, 0.04); border: 1px solid rgba(255, 255, 255, 0.08); border-radius: 7px; color: #E8EDF5; padding: 8px 12px; font-size: 12px; outline: none; }
.filter-group option { background: #162A50; }

.assets-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 30px; }
.asset-card { background: rgba(22, 42, 80, 0.5); border: 1px solid rgba(255, 255, 255, 0.07); border-radius: 12px; padding: 18px; position: relative; overflow: hidden; transition: 0.2s; }
.asset-card:hover { transform: translateY(-3px); border-color: rgba(240, 124, 42, 0.3); }
.asset-card::before { content: ''; position: absolute; top: 0; right: 0; width: 4px; height: 100%; }
.asset-card.ok::before { background: #2ECC71; }
.asset-card.warn::before { background: #F5A623; }
.asset-card.crit::before { background: #E84545; }

.ac-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px; }
.ac-icon { width: 38px; height: 38px; border-radius: 9px; display: grid; place-items: center; font-size: 17px; }
.ac-meta { text-align: left; }
.ac-id { font: 700 9px 'JetBrains Mono', monospace; color: #7A8FAD; display: block; }
.ac-status-badge { font-size: 9px; font-weight: 700; padding: 2px 7px; border-radius: 4px; display: inline-block; margin-top: 3px; }
.ac-status-badge.ok { background: rgba(46,204,113,0.12); color: #2ECC71; }
.ac-status-badge.warn { background: rgba(245,166,35,0.12); color: #F5A623; }
.ac-status-badge.crit { background: rgba(232,69,69,0.12); color: #E84545; }

.ac-body h3 { font-size: 14px; font-weight: 800; margin-bottom: 3px; }
.ac-body p { font-size: 11px; color: #7A8FAD; margin-bottom: 14px; }
.ac-metrics { display: grid; grid-template-columns: 1fr 1fr; gap: 8px; margin-bottom: 14px; background: rgba(255,255,255,0.03); padding: 8px 10px; border-radius: 8px; }
.ac-metrics span { display: block; font-size: 9px; color: #7A8FAD; }
.ac-metrics strong { font: 700 12px 'JetBrains Mono', monospace; }

.ac-footer { display: flex; align-items: center; gap: 12px; }
.health-bar-wrap { flex: 1; }
.health-bar-bg { background: rgba(255,255,255,0.08); height: 6px; border-radius: 3px; overflow: hidden; }
.health-bar { height: 100%; border-radius: 3px; transition: width 0.4s; }

.primary-button, .secondary-button, .btn-sm { border-radius: 8px; padding: 8px 16px; font-family: 'Cairo', sans-serif; font-size: 11px; font-weight: 800; cursor: pointer; border: none; transition: 0.2s; }
.primary-button { background: linear-gradient(135deg, #F07C2A, #C4601E); color: white; box-shadow: 0 4px 14px rgba(240,124,42,0.25); }
.primary-button:hover { transform: translateY(-1px); }
.secondary-button { background: rgba(255,255,255,0.06); color: #E8EDF5; border: 1px solid rgba(255,255,255,0.08); }
.secondary-button:hover { border-color: #F07C2A; }
.btn-sm { background: rgba(240,124,42,0.12); color: #F07C2A; padding: 6px 12px; }
.btn-sm:hover { background: #F07C2A; color: white; }

.modal-overlay { position: fixed; inset: 0; background: rgba(0, 0, 0, 0.8); display: grid; place-items: center; z-index: 2000; padding: 20px; }
.modal-content { background: #0c1b35; border: 1px solid rgba(240, 124, 42, 0.3); border-radius: 14px; width: min(520px, 100%); overflow: hidden; box-shadow: 0 20px 50px rgba(0,0,0,0.6); }
.modal-header { padding: 16px 20px; background: rgba(255,255,255,0.03); border-bottom: 1px solid rgba(255,255,255,0.08); display: flex; justify-content: space-between; align-items: center; }
.modal-header h3 { font-size: 14px; font-weight: 800; color: #F07C2A; }
.close-btn { background: none; border: none; color: #7A8FAD; cursor: pointer; font-size: 16px; }
.modal-body { padding: 20px; }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
.form-group { margin-bottom: 12px; }
.form-group label { display: block; font-size: 10px; font-weight: 700; color: #7A8FAD; margin-bottom: 5px; }
.form-group input, .form-group select { width: 100%; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); border-radius: 7px; padding: 8px 11px; color: #fff; font-size: 12px; outline: none; }
.form-group input:focus, .form-group select:focus { border-color: #F07C2A; }
.form-group option { background: #162A50; }
.modal-footer { padding: 14px 20px; background: rgba(255,255,255,0.03); border-top: 1px solid rgba(255,255,255,0.08); display: flex; justify-content: flex-end; gap: 10px; }

.toast-message { position: fixed; bottom: 25px; right: 50%; transform: translateX(50%); z-index: 9999; background: #2ECC71; color: #061b12; padding: 10px 20px; border-radius: 24px; font-size: 11px; font-weight: 800; box-shadow: 0 8px 25px rgba(0,0,0,0.3); }

@media (max-width: 900px) {
  .stats-grid, .assets-grid, .form-grid { grid-template-columns: 1fr; }
}
</style>
