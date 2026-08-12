<template>
  <div class="page-container">
    <header class="page-header">
      <div class="header-left">
        <h1>إدارة المحطات</h1>
        <p>عرض وتعديل بيانات المحطات، الطاقة التصميمية والفعلية، وكفاءة التشغيل.</p>
      </div>
      <button class="btn-primary" @click="openAddModal">
        <span>+</span> إضافة محطة جديدة
      </button>
    </header>

    <section class="stats-grid">
      <div class="stat-card">
        <div class="stat-icon">⛫</div>
        <div class="stat-info">
          <span>إجمالي المحطات</span>
          <strong>{{ stations.length }}</strong>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon success">✓</div>
        <div class="stat-info">
          <span>متوسط الكفاءة</span>
          <strong>{{ avgEfficiency }}%</strong>
        </div>
      </div>
      <div class="stat-card">
        <div class="stat-icon warning">⚡</div>
        <div class="stat-info">
          <span>إجمالي الطاقة الفعلية</span>
          <strong>{{ totalActualProd.toLocaleString() }} م³</strong>
        </div>
      </div>
    </section>

    <div class="table-container">
      <div class="table-actions">
        <div class="search-box">
          <span>⌕</span>
          <input v-model="searchQuery" type="text" placeholder="بحث باسم المحطة أو القطاع..." />
        </div>
        <div class="filter-box">
          <select v-model="filterSector">
            <option value="">كل القطاعات</option>
            <option>الإسماعيلية</option>
            <option>السويس</option>
            <option>بورسعيد</option>
          </select>
        </div>
      </div>

      <table class="data-table">
        <thead>
          <tr>
            <th>اسم المحطة</th>
            <th>القطاع</th>
            <th>النوع</th>
            <th>الطاقة التصميمية (م³/يوم)</th>
            <th>الطاقة الفعلية (م³/يوم)</th>
            <th>الكفاءة</th>
            <th class="tc">إجراءات</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="station in filteredStations" :key="station.id">
            <td><strong>{{ station.name }}</strong></td>
            <td>{{ station.sector }}</td>
            <td><span class="badge">{{ station.type }}</span></td>
            <td>{{ station.design_capacity.toLocaleString() }}</td>
            <td>{{ station.actual_capacity.toLocaleString() }}</td>
            <td>
              <div class="efficiency-wrap">
                <div class="progress-mini">
                  <div :style="{ width: station.efficiency + '%', backgroundColor: getEffColor(station.efficiency) }"></div>
                </div>
                <span>{{ station.efficiency }}%</span>
              </div>
            </td>
            <td class="tc">
              <div class="actions">
                <button class="btn-icon" @click="editStation(station)" title="تعديل">✏️</button>
                <button class="btn-icon danger" @click="deleteStation(station.id)" title="حذف">🗑️</button>
              </div>
            </td>
          </tr>
          <tr v-if="filteredStations.length === 0">
            <td colspan="7" class="empty-state">لا توجد محطات تطابق البحث</td>
          </tr>
        </tbody>
      </table>
    </div>

    <!-- Modal for Add/Edit -->
    <div v-if="showModal" class="modal-overlay" @click.self="closeModal">
      <div class="modal-content">
        <div class="modal-header">
          <h3>{{ isEditing ? 'تعديل بيانات المحطة' : 'إضافة محطة جديدة' }}</h3>
          <button class="close-btn" @click="closeModal">✕</button>
        </div>
        <form @submit.prevent="saveStation" class="modal-body">
          <div class="form-grid">
            <div class="form-group">
              <label>اسم المحطة <span class="req">*</span></label>
              <input v-model="form.name" type="text" required placeholder="مثال: محطة العمده صالح" />
            </div>
            <div class="form-group">
              <label>القطاع <span class="req">*</span></label>
              <select v-model="form.sector" required>
                <option value="">— اختر القطاع —</option>
                <option>الإسماعيلية</option>
                <option>السويس</option>
                <option>بورسعيد</option>
              </select>
            </div>
            <div class="form-group">
              <label>المنطقة</label>
              <input v-model="form.area" type="text" placeholder="المنطقة التابع لها" />
            </div>
            <div class="form-group">
              <label>النوع</label>
              <select v-model="form.type">
                <option>مياه</option>
                <option>صرف</option>
                <option>معالجة</option>
              </select>
            </div>
            <div class="form-group">
              <label>المأخذ</label>
              <input v-model="form.intake" type="text" placeholder="مصدر التغذية" />
            </div>
            <div class="form-group">
              <label>المصب</label>
              <input v-model="form.outlet" type="text" placeholder="جهة الصرف النهائي" />
            </div>
            <div class="form-group">
              <label>الطاقة التصميمية (م³/يوم)</label>
              <input v-model.number="form.design_capacity" type="number" step="0.01" />
            </div>
            <div class="form-group">
              <label>الطاقة الفعلية (م³/يوم)</label>
              <input v-model.number="form.actual_capacity" type="number" step="0.01" />
            </div>
            <div class="form-group">
              <label>كفاءة التشغيل (%)</label>
              <input v-model.number="form.efficiency" type="number" min="0" max="100" />
            </div>
          </div>
          <div class="form-group full-width">
            <label>ملاحظات التشغيل</label>
            <textarea v-model="form.notes" rows="3" placeholder="أي ملاحظات إضافية عن حالة المحطة..."></textarea>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn-secondary" @click="closeModal">إلغاء</button>
            <button type="submit" class="btn-primary">حفظ البيانات</button>
          </div>
        </form>
      </div>
    </div>

    <div v-if="toast" class="toast-message">✓ {{ toast }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed, onMounted, watch } from 'vue'

interface Station {
  id: string
  name: string
  sector: string
  area: string
  type: string
  intake: string
  outlet: string
  design_capacity: number
  actual_capacity: number
  efficiency: number
  notes: string
}

const stations = ref<Station[]>([])
const showModal = ref(false)
const isEditing = ref(false)
const searchQuery = ref('')
const filterSector = ref('')
const toast = ref('')

const initialForm: Station = {
  id: '',
  name: '',
  sector: '',
  area: '',
  type: 'مياه',
  intake: '',
  outlet: '',
  design_capacity: 0,
  actual_capacity: 0,
  efficiency: 0,
  notes: ''
}

const form = ref<Station>({ ...initialForm })

// Load Data
onMounted(() => {
  const saved = localStorage.getItem('eam_stations_data')
  if (saved) {
    stations.value = JSON.parse(saved)
  } else {
    // Fallback to initial extracted data
    stations.value = [
      { id: '1', name: 'العمده صالح', sector: 'الإسماعيلية', area: 'منطقة الإسماعيلية', type: 'معالجة', intake: 'ترعة الإسماعيلية', outlet: 'شبكة التوزيع', design_capacity: 5000, actual_capacity: 2661, efficiency: 80, notes: '' },
      { id: '2', name: 'الضبعيه', sector: 'الإسماعيلية', area: 'منطقة الإسماعيلية', type: 'معالجة', intake: 'ترعة الإسماعيلية', outlet: 'شبكة التوزيع', design_capacity: 5000, actual_capacity: 2397, efficiency: 70, notes: '' },
      { id: '3', name: 'عين غصين الكبري', sector: 'الإسماعيلية', area: 'منطقة الإسماعيلية', type: 'معالجة', intake: 'ترعة الإسماعيلية', outlet: 'شبكة التوزيع', design_capacity: 8000, actual_capacity: 7965, efficiency: 95, notes: '' },
      { id: '4', name: 'أبو عارف الجديدة', sector: 'السويس', area: 'منطقة السويس', type: 'مياه', intake: 'ترعة السويس', outlet: 'شبكة التوزيع', design_capacity: 120000, actual_capacity: 95000, efficiency: 88, notes: '' },
      { id: '5', name: 'جنيفة', sector: 'السويس', area: 'منطقة السويس', type: 'مياه', intake: 'ترعة السويس', outlet: 'شبكة التوزيع', design_capacity: 45000, actual_capacity: 32000, efficiency: 75, notes: '' }
    ]
    saveToStorage()
  }
})

const saveToStorage = () => {
  localStorage.setItem('eam_stations_data', JSON.stringify(stations.value))
}

const filteredStations = computed(() => {
  return stations.value.filter(s => {
    const matchesSearch = s.name.includes(searchQuery.value) || s.sector.includes(searchQuery.value)
    const matchesSector = !filterSector.value || s.sector === filterSector.value
    return matchesSearch && matchesSector
  })
})

const avgEfficiency = computed(() => {
  if (stations.value.length === 0) return 0
  const sum = stations.value.reduce((acc, s) => acc + s.efficiency, 0)
  return Math.round(sum / stations.value.length)
})

const totalActualProd = computed(() => {
  return stations.value.reduce((acc, s) => acc + s.actual_capacity, 0)
})

const getEffColor = (val: number) => {
  if (val >= 90) return '#2ECC71'
  if (val >= 75) return '#F1C40F'
  return '#E74C3C'
}

const openAddModal = () => {
  isEditing.value = false
  form.value = { ...initialForm, id: Date.now().toString() }
  showModal.value = true
}

const editStation = (station: Station) => {
  isEditing.value = true
  form.value = { ...station }
  showModal.value = true
}

const closeModal = () => {
  showModal.value = false
}

const saveStation = () => {
  // Check for duplicate name (excluding self)
  const exists = stations.value.find(s => s.name === form.value.name && s.id !== form.value.id)
  if (exists) {
    alert('اسم المحطة موجود بالفعل، يرجى اختيار اسم فريد.')
    return
  }

  if (isEditing.value) {
    const idx = stations.value.findIndex(s => s.id === form.value.id)
    if (idx !== -1) stations.value[idx] = { ...form.value }
  } else {
    stations.value.push({ ...form.value })
  }
  
  saveToStorage()
  closeModal()
  showToast('تم حفظ بيانات المحطة بنجاح')
}

const deleteStation = (id: string) => {
  if (confirm('هل أنت متأكد من حذف هذه المحطة؟')) {
    stations.value = stations.value.filter(s => s.id !== id)
    saveToStorage()
    showToast('تم حذف المحطة')
  }
}

const showToast = (msg: string) => {
  toast.value = msg
  setTimeout(() => toast.value = '', 3000)
}
</script>

<style scoped>
.page-container { padding: 25px; font-family: 'Cairo', sans-serif; color: #E8EDF5; }
.page-header { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 30px; }
.page-header h1 { font-size: 24px; font-weight: 900; color: #F07C2A; margin-bottom: 5px; }
.page-header p { font-size: 13px; color: #7A8FAD; }

.stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
.stat-card { background: rgba(22, 42, 80, 0.4); padding: 20px; border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.05); display: flex; align-items: center; gap: 15px; }
.stat-icon { width: 40px; height: 40px; border-radius: 10px; background: rgba(240, 124, 42, 0.1); color: #F07C2A; display: grid; place-items: center; font-size: 20px; }
.stat-icon.success { background: rgba(46, 204, 113, 0.1); color: #2ECC71; }
.stat-icon.warning { background: rgba(241, 196, 15, 0.1); color: #F1C40F; }
.stat-info span { display: block; font-size: 11px; color: #7A8FAD; }
.stat-info strong { font-size: 20px; font-weight: 900; }

.table-container { background: rgba(22, 42, 80, 0.4); border-radius: 12px; border: 1px solid rgba(255, 255, 255, 0.05); overflow: hidden; }
.table-actions { padding: 15px 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); display: flex; justify-content: space-between; align-items: center; gap: 20px; }
.search-box { flex: 1; position: relative; }
.search-box span { position: absolute; right: 12px; top: 50%; transform: translateY(-50%); color: #7A8FAD; }
.search-box input { width: 100%; background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); padding: 8px 35px 8px 12px; border-radius: 8px; color: white; font-size: 13px; outline: none; }
.filter-box select { background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); padding: 8px 12px; border-radius: 8px; color: white; font-size: 13px; }

.data-table { width: 100%; border-collapse: collapse; text-align: right; }
.data-table th { padding: 12px 20px; font-size: 12px; color: #7A8FAD; background: rgba(255, 255, 255, 0.02); }
.data-table td { padding: 15px 20px; font-size: 13px; border-bottom: 1px solid rgba(255, 255, 255, 0.05); }
.tc { text-align: center; }
.badge { background: rgba(240, 124, 42, 0.1); color: #F07C2A; padding: 2px 8px; border-radius: 4px; font-size: 11px; }
.efficiency-wrap { display: flex; align-items: center; gap: 10px; }
.progress-mini { width: 60px; height: 6px; background: rgba(255, 255, 255, 0.1); border-radius: 3px; overflow: hidden; }
.progress-mini div { height: 100%; border-radius: 3px; }

.actions { display: flex; gap: 8px; justify-content: center; }
.btn-icon { background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); border-radius: 6px; padding: 5px; cursor: pointer; transition: 0.2s; }
.btn-icon:hover { background: rgba(240, 124, 42, 0.2); border-color: #F07C2A; }
.btn-icon.danger:hover { background: rgba(231, 76, 60, 0.2); border-color: #E74C3C; }

.btn-primary { background: #F07C2A; color: white; border: none; padding: 10px 20px; border-radius: 8px; font-weight: 700; cursor: pointer; display: flex; align-items: center; gap: 8px; transition: 0.3s; }
.btn-primary:hover { background: #C4601E; transform: translateY(-2px); }

.modal-overlay { position: fixed; inset: 0; background: rgba(0, 0, 0, 0.8); display: grid; place-items: center; z-index: 1000; padding: 20px; }
.modal-content { background: #0b192c; border: 1px solid rgba(240, 124, 42, 0.3); border-radius: 16px; width: 100%; max-width: 700px; max-height: 90vh; overflow-y: auto; }
.modal-header { padding: 20px; border-bottom: 1px solid rgba(255, 255, 255, 0.1); display: flex; justify-content: space-between; align-items: center; }
.modal-header h3 { color: #F07C2A; font-weight: 900; }
.close-btn { background: none; border: none; color: white; font-size: 20px; cursor: pointer; }

.modal-body { padding: 25px; }
.form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
.form-group { display: flex; flex-direction: column; gap: 8px; }
.form-group.full-width { grid-column: span 2; margin-top: 10px; }
.form-group label { font-size: 12px; font-weight: 700; color: #7A8FAD; }
.form-group input, .form-group select, .form-group textarea { background: rgba(255, 255, 255, 0.05); border: 1px solid rgba(255, 255, 255, 0.1); padding: 10px 12px; border-radius: 8px; color: white; font-size: 13px; outline: none; }
.form-group input:focus, .form-group select:focus { border-color: #F07C2A; }
.req { color: #E74C3C; }

.modal-footer { margin-top: 30px; display: flex; justify-content: flex-end; gap: 15px; }
.btn-secondary { background: rgba(255, 255, 255, 0.05); color: #7A8FAD; border: 1px solid rgba(255, 255, 255, 0.1); padding: 10px 25px; border-radius: 8px; cursor: pointer; }

.toast-message { position: fixed; bottom: 30px; left: 50%; transform: translateX(-50%); background: #2ECC71; color: white; padding: 10px 25px; border-radius: 30px; box-shadow: 0 10px 30px rgba(0,0,0,0.3); z-index: 10000; }
.empty-state { text-align: center; padding: 40px; color: #7A8FAD; font-style: italic; }
</style>
