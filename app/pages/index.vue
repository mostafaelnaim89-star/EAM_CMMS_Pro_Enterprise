<template>
  <div class="app-container">
    <!-- Auth Sequence Components -->
    <Transition name="screen-fade" mode="out-in">
      <AuthSplashScreen 
        v-if="flow === 'splash'" 
        @start="flow = 'role'" 
      />
      <AuthRoleSelection 
        v-else-if="flow === 'role'" 
        @select="handleRoleSelect" 
        @back="flow = 'splash'" 
      />
      <AuthLoginScreen 
        v-else-if="flow === 'login'" 
        :role-name="selectedRole?.title"
        :initial-email="selectedRole?.email"
        @login="submitLogin" 
        @change-role="flow = 'role'" 
      />
      
      <!-- Main Dashboard Content -->
      <section v-else-if="flow === 'dashboard'" class="dashboard-wrapper">
        <header class="top-header">
          <div class="org-name">
            <strong>الشركة القابضة لمياه الشرب والصرف الصحى بمدن القناة</strong>
            قطاع التشغيل والصيانة / لوحة القيادة التنفيذية
          </div>
          <div class="hdr-right">
            <div class="live-wrap">
              <div class="live-dot"></div>
              <span class="clock">{{ currentTime }}</span>
            </div>
            <div class="sys-badge">EAM PRO</div>
            <div class="user-pill">
              <div class="av">{{ selectedRole?.title?.charAt(0) || 'م' }}</div>
              <strong>{{ selectedRole?.title || 'مدير النظام' }}</strong>
            </div>
            <button class="logout-btn" @click="logout">⏻</button>
          </div>
        </header>

        <div class="app-body">
          <aside class="sidebar">
            <div class="sb-header">
              <div class="sb-search">
                <input type="search" placeholder="بحث سريع...">
              </div>
            </div>
            <nav class="nav-wrap">
              <div class="nav-group">الرئيسية</div>
              <div class="nav-item active"><span class="ni">⌂</span> لوحة القيادة</div>
              <div class="nav-group">التشغيل والصيانة</div>
              <div class="nav-item"><span class="ni">◈</span> الأصول والمعدات</div>
              <div class="nav-item"><span class="ni">▣</span> أوامر العمل</div>
              <div class="nav-item"><span class="ni">↻</span> الصيانة الوقائية</div>
            </nav>
          </aside>

          <main class="main-area">
            <div class="subbar">
              <div class="page-title">لوحة القيادة التنفيذية</div>
              <div class="breadcrumb">الرئيسية / <span>لوحة القيادة</span></div>
            </div>
            
            <div class="page-content">
              <div class="kpi-grid">
                <article v-for="kpi in kpis" :key="kpi.label" class="kpi-card">
                  <div class="kpi-icon">{{ kpi.icon }}</div>
                  <div class="kpi-body">
                    <span>{{ kpi.label }}</span>
                    <strong>{{ kpi.value }}</strong>
                  </div>
                </article>
              </div>

              <div class="dashboard-banner">
                <h2>أداء القطاعات التشغيلي</h2>
                <p>متابعة مباشرة لمحطات مدن القناة (السويس، الإسماعيلية، بورسعيد)</p>
              </div>

              <section class="report-update" aria-label="آخر تحديث للبيانات">
                <div class="report-update-head">
                  <strong>بيانات التقارير الموثقة</strong>
                  <span>يونيو 2026 / موازنة 2027</span>
                </div>
                <div class="report-update-grid">
                  <span>بورسعيد — تكلفة فعلية: <b>2.077M ج.م</b></span>
                  <span>الإنتاج الشهري: <b>1,271,780 م³</b></span>
                  <span>متوسط التشغيل: <b>76.7%</b></span>
                  <span>موازنة 2027: <b>27.573M ج.م</b></span>
                </div>
              </section>

              <div class="sector-grid">
                <div v-for="sector in sectors" :key="sector.name" class="sector-card">
                  <h3>قطاع {{ sector.name }}</h3>
                  <div class="sector-meta">
                    <span>محطات: {{ sector.stations }}</span>
                    <span>كهرباء: {{ sector.electricity }}</span>
                  </div>
                  <div class="metric">الصحة التشغيلية: {{ sector.health }}%</div>
                  <div class="progress-bar"><div :style="{ width: sector.health + '%' }"></div></div>
                </div>
              </div>
            </div>
          </main>
        </div>
      </section>
    </Transition>

    <div v-if="toast" class="toast-message">✓ {{ toast }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, onUnmounted } from 'vue'

type Flow = 'splash' | 'role' | 'login' | 'dashboard'
type Role = { key: string; title: string; icon: string; description: string; email: string }

useHead({ title: 'EAM_CMMS_Pro — لوحة القيادة' })

const flow = ref<Flow>('splash')
const selectedRole = ref<Role | null>(null)
const currentTime = ref('')
const toast = ref('')
let timer: any

const kpis = [
  { label: 'إجمالي المحطات', value: '81', icon: '📊' },
  { label: 'الأصول المسجلة', value: '1,248', icon: '⚙️' },
  { label: 'أوامر العمل', value: '127', icon: '▣' },
  { label: 'نسبة الإنجاز', value: '94.2%', icon: '✅' }
]

const sectors = [
  { name: 'السويس', health: 88, stations: 11, electricity: '3.12M EGP' },
  { name: 'الإسماعيلية', health: 84, stations: 64, electricity: '2.18M EGP' },
  { name: 'بورسعيد', health: 87, stations: 6, electricity: '1.74M EGP' }
]

const handleRoleSelect = (role: Role) => {
  selectedRole.value = role
  flow.value = 'login'
}

const submitLogin = () => {
  flow.value = 'dashboard'
  showToast('تم تسجيل الدخول بنجاح')
}

const logout = () => {
  flow.value = 'splash'
  selectedRole.value = null
}

const showToast = (msg: string) => {
  toast.value = msg
  setTimeout(() => toast.value = '', 3000)
}

const updateTime = () => {
  currentTime.value = new Date().toLocaleTimeString('ar-EG', { hour12: true })
}

onMounted(() => {
  updateTime()
  timer = setInterval(updateTime, 1000)
})

onUnmounted(() => {
  clearInterval(timer)
})
</script>

<style scoped>
.app-container {
  height: 100vh;
  width: 100vw;
  background: #060e1a;
  overflow: hidden;
}

.dashboard-wrapper {
  height: 100%;
  display: flex;
  flex-direction: column;
}

.top-header {
  background: linear-gradient(90deg, #040b16, #0a1628);
  border-bottom: 2px solid #F07C2A;
  padding: 0 20px;
  height: 60px;
  display: flex;
  align-items: center;
  justify-content: space-between;
}

.org-name { font-size: 10px; color: #7A8FAD; }
.org-name strong { color: #F07C2A; font-size: 13px; display: block; }

.hdr-right { display: flex; align-items: center; gap: 20px; }
.clock { font-family: 'JetBrains Mono', monospace; color: #D4AF37; font-size: 13px; }

.user-pill {
  display: flex;
  align-items: center;
  gap: 10px;
  background: rgba(22, 42, 80, 0.6);
  padding: 5px 15px;
  border-radius: 25px;
  border: 1px solid rgba(255, 255, 255, 0.1);
}

.av {
  width: 28px;
  height: 28px;
  border-radius: 50%;
  background: #F07C2A;
  display: grid;
  place-items: center;
  font-weight: 900;
}

.logout-btn {
  background: none;
  border: none;
  color: #E84545;
  font-size: 20px;
  cursor: pointer;
}

.app-body { display: flex; flex: 1; overflow: hidden; }

.sidebar {
  width: 240px;
  background: #07101f;
  border-left: 1px solid rgba(255, 255, 255, 0.05);
}

.nav-item {
  padding: 12px 20px;
  color: #7A8FAD;
  cursor: pointer;
  display: flex;
  align-items: center;
  gap: 12px;
}
.nav-item.active { background: rgba(240, 124, 42, 0.1); color: #F07C2A; border-right: 4px solid #F07C2A; }

.main-area { flex: 1; display: flex; flex-direction: column; }
.subbar {
  height: 50px;
  padding: 0 25px;
  display: flex;
  align-items: center;
  justify-content: space-between;
  background: rgba(255, 255, 255, 0.02);
}

.page-content { padding: 25px; overflow-y: auto; }

.kpi-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 30px; }
.kpi-card {
  background: rgba(22, 42, 80, 0.4);
  padding: 20px;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  display: flex;
  align-items: center;
  gap: 15px;
}
.kpi-icon { font-size: 24px; }
.kpi-body strong { font-size: 24px; display: block; }

.sector-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
.sector-card {
  background: rgba(22, 42, 80, 0.4);
  padding: 20px;
  border-radius: 12px;
  border: 1px solid rgba(255, 255, 255, 0.05);
  transition: 0.3s;
}
.sector-card:hover { transform: translateY(-5px); border-color: #F07C2A; }
.sector-meta { display: flex; justify-content: space-between; font-size: 10px; color: #7A8FAD; margin: 8px 0; }
.metric { font-size: 12px; font-weight: 700; margin-top: 10px; }

.progress-bar {
  height: 8px;
  background: rgba(255, 255, 255, 0.1);
  border-radius: 4px;
  margin-top: 10px;
  overflow: hidden;
}
.progress-bar div { height: 100%; background: #F07C2A; border-radius: 4px; }

.toast-message {
  position: fixed;
  bottom: 30px;
  left: 50%;
  transform: translateX(-50%);
  background: #2ECC71;
  color: white;
  padding: 10px 25px;
  border-radius: 30px;
  box-shadow: 0 10px 30px rgba(0,0,0,0.3);
  z-index: 10000;
}

.screen-fade-enter-active, .screen-fade-leave-active { transition: all 0.5s ease; }
.screen-fade-enter-from { opacity: 0; transform: scale(1.05); }
.screen-fade-leave-to { opacity: 0; transform: scale(0.95); }

.report-update{margin:0 0 24px;padding:14px 16px;border:1px solid rgba(0,180,166,.24);border-right:3px solid #00B4A6;border-radius:12px;background:rgba(0,180,166,.06);color:#DCE7F5}.report-update-head{display:flex;align-items:center;justify-content:space-between;gap:10px;margin-bottom:10px}.report-update-head strong{color:#00D1BE;font-size:13px}.report-update-head span{font-size:10px;color:#7A8FAD}.report-update-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:8px}.report-update-grid span{font-size:10px;color:#9DB0C9}.report-update-grid b{display:block;color:#E8EDF5;font-size:13px;margin-top:3px}@media(max-width:800px){.report-update-grid{grid-template-columns:repeat(2,1fr)}}@media(max-width:500px){.report-update-grid{grid-template-columns:1fr}.report-update-head{display:block}.report-update-head span{display:block;margin-top:4px}}

</style>
