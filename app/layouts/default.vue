<template>
  <div class="app-shell">
    <aside class="sidebar" :class="{ open: mobileMenuOpen }">
      <div class="sidebar-brand">
        <div class="brand-mark">🌊</div>
        <div>
          <strong>EAM_CMMS_Pro</strong>
          <span>نظام إدارة الأصول والصيانة</span>
        </div>
      </div>

      <div class="sidebar-search">
        <span>⌕</span>
        <input v-model="search" type="search" placeholder="بحث سريع..." aria-label="بحث سريع" />
      </div>

      <div class="sector-switcher">
        <span class="section-label">القطاع المحدد</span>
        <select v-model="selectedSector" aria-label="اختيار القطاع">
          <option>كل القطاعات</option>
          <option>السويس</option>
          <option>الإسماعيلية</option>
          <option>بورسعيد</option>
        </select>
      </div>

      <nav class="nav-wrap" aria-label="القائمة الرئيسية">
        <div class="nav-section-title">الرئيسية</div>
        <NuxtLink class="nav-item active" to="/">
          <span class="nav-icon">⌂</span><span>لوحة القيادة</span><em>عرض</em>
        </NuxtLink>

        <div class="nav-section-title">التشغيل والصيانة</div>
        <NuxtLink class="nav-item" to="/stations"><span class="nav-icon">⛫</span><span>إدارة المحطات</span><b>81</b></NuxtLink>
        <NuxtLink class="nav-item" to="/assets"><span class="nav-icon">◈</span><span>الأصول والمعدات</span><b>80+</b></NuxtLink>
        <NuxtLink class="nav-item" to="/work-orders"><span class="nav-icon">▣</span><span>أوامر العمل</span><b class="danger">12</b></NuxtLink>
        <NuxtLink class="nav-item" to="/preventive-maintenance"><span class="nav-icon">↻</span><span>الصيانة الوقائية</span><b class="success">94%</b></NuxtLink>
        <NuxtLink class="nav-item" to="/inventory"><span class="nav-icon">▤</span><span>المخزون وقطع الغيار</span><b class="warning">7</b></NuxtLink>

        <div class="nav-section-title">التكاليف والتقارير</div>
        <NuxtLink class="nav-item" to="/costs"><span class="nav-icon">◉</span><span>التكاليف التشغيلية</span></NuxtLink>
        <NuxtLink class="nav-item" to="/reports"><span class="nav-icon">▥</span><span>التقارير التنفيذية</span></NuxtLink>
        <NuxtLink class="nav-item" to="/water-quality"><span class="nav-icon">♒</span><span>جودة المياه</span></NuxtLink>

        <div class="nav-section-title">الإدارة</div>
        <NuxtLink class="nav-item" to="/users"><span class="nav-icon">♙</span><span>المستخدمون والصلاحيات</span></NuxtLink>
        <NuxtLink class="nav-item" to="/settings"><span class="nav-icon">⚙</span><span>إعدادات النظام</span></NuxtLink>
      </nav>

      <div class="sidebar-footer">
        <div class="system-status"><span class="status-dot"></span><span>النظام يعمل محلياً</span><small>v3.0.0</small></div>
        <div class="sidebar-footer-note">ISO 55000 · ISO 14224 · CMMS · EAM</div>
      </div>
    </aside>

    <div v-if="mobileMenuOpen" class="sidebar-overlay" @click="mobileMenuOpen = false"></div>

    <main class="main-area">
      <header class="top-header">
        <button class="menu-button" type="button" aria-label="فتح القائمة" @click="mobileMenuOpen = !mobileMenuOpen">☰</button>
        <div class="header-identity">
          <div class="eyebrow">الشركة القابضة لمياه الشرب والصرف الصحى بمدن القناة</div>
          <div class="header-title">قطاع التشغيل والصيانة <span>/</span> لوحة القيادة التنفيذية</div>
        </div>
        <div class="header-actions">
          <div class="live-indicator"><span></span> مباشر</div>
          <div class="clock">{{ currentTime }}</div>
          <div class="header-divider"></div>
          <button class="icon-button" type="button" aria-label="الإشعارات">♢<i>4</i></button>
          <div class="user-pill">
            <div class="avatar">م</div>
            <div><strong>{{ userName }}</strong><small>{{ userRole }}</small></div>
          </div>
          <button class="logout-button" type="button" title="تسجيل الخروج" @click="handleLogout">⏻</button>
        </div>
      </header>

      <div class="route-content">
        <slot />
      </div>
    </main>
  </div>
</template>

<script setup lang="ts">
useHead({ title: 'EAM_CMMS_Pro — نظام إدارة الأصول والصيانة' })

const mobileMenuOpen = ref(false)
const search = ref('')
const selectedSector = ref('كل القطاعات')
const currentTime = ref('09:42:18')
const userName = ref('مصطفى أحمد')
const userRole = ref('مدير النظام')
let timer: ReturnType<typeof setInterval> | undefined

onMounted(() => {
  timer = setInterval(() => {
    currentTime.value = new Intl.DateTimeFormat('ar-EG', { hour: '2-digit', minute: '2-digit', second: '2-digit' }).format(new Date())
  }, 1000)
})

onBeforeUnmount(() => {
  if (timer) clearInterval(timer)
})

function handleLogout() {
  if (process.client) sessionStorage.removeItem('eam_logged_user')
  navigateTo('/')
}
</script>

<style scoped>
.route-content {
  flex: 1;
  min-height: 0;
  overflow: auto;
  background: radial-gradient(circle at 8% 10%, rgba(0, 180, 166, .05), transparent 32%), var(--navy-deep);
}
.route-content::-webkit-scrollbar { width: 4px; }
.route-content::-webkit-scrollbar-thumb { background: rgba(240,124,42,.25); border-radius: 4px; }
@media (max-width: 900px) {
  .menu-button { display: inline-grid; place-items: center; }
  .sidebar { position: fixed; right: 0; top: 0; bottom: 0; transform: translateX(105%); transition: transform .2s ease; box-shadow: -18px 0 45px rgba(0,0,0,.35); }
  .sidebar.open { transform: translateX(0); }
  .sidebar-overlay { display: block; position: fixed; inset: 0; background: rgba(0,0,0,.55); z-index: 40; }
  .header-actions { gap: 8px; }
  .header-identity { overflow: hidden; }
  .eyebrow, .header-title { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
}
@media (max-width: 560px) {
  .clock, .header-divider, .icon-button { display: none; }
  .user-pill small { display: none; }
  .header-title { font-size: 9px; }
}
</style>
