<template>
  <div class="entry-screen role-screen">
    <div class="role-panel">
      <div class="water-logo-circle">🌊</div>
      <div class="sys-tag">EAM_CMMS_PRO</div>
      <h1>اختر دورك الوظيفي والصلاحية</h1>
      <p>حدد نوع حسابك للوصول إلى الواجهة المناسبة لمسؤولياتك داخل النظام.</p>
      
      <div class="role-grid">
        <button 
          v-for="role in roles" 
          :key="role.key" 
          class="role-card-btn" 
          @click="$emit('select', role)"
        >
          <div class="role-icon-box">{{ role.icon }}</div>
          <div class="role-info">
            <strong>{{ role.name }}</strong>
            <small>{{ role.description }}</small>
          </div>
          <div class="arrow">←</div>
        </button>
      </div>
      
      <button class="back-btn" @click="$emit('back')">← العودة لشاشة البداية</button>
    </div>
  </div>
</template>

<script setup>
defineEmits(['select', 'back']);

const roles = [
  { 
    key: 'system_admin', 
    name: 'مدير النظام', 
    email: 'mostafa@canal-water.eg', 
    icon: '🛡️', 
    description: 'صلاحيات كاملة وإدارة المستخدمين والإعدادات' 
  },
  { 
    key: 'sector_manager', 
    name: 'مدير القطاع', 
    email: 'mohamed@canal-water.eg', 
    icon: '🏢', 
    description: 'متابعة القطاع ومؤشرات الأداء والتكاليف' 
  },
  { 
    key: 'station_manager', 
    name: 'مدير المحطة', 
    email: 'ahmed@canal-water.eg', 
    icon: '🏭', 
    description: 'إدارة المحطة والإنتاج وأوامر العمل' 
  },
  { 
    key: 'maintenance_engineer', 
    name: 'مهندس صيانة', 
    email: 'sara@canal-water.eg', 
    icon: '⚙️', 
    description: 'الصيانة الوقائية والتصحيحية والأصول' 
  }
];
</script>

<style scoped>
.entry-screen {
  position: fixed;
  inset: 0;
  z-index: 9999;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 25px;
  background: radial-gradient(circle at 18% 15%, rgba(240, 124, 42, 0.12), transparent 30%),
    radial-gradient(circle at 80% 82%, rgba(0, 180, 166, 0.09), transparent 28%), #060e1a;
  overflow: auto;
  color: #E8EDF5;
}

.role-panel {
  position: relative;
  z-index: 1;
  text-align: center;
  width: min(480px, 100%);
  padding: 27px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 16px;
  background: rgba(18, 38, 74, 0.75);
  box-shadow: 0 22px 60px rgba(0, 0, 0, 0.45);
  backdrop-filter: blur(14px);
  animation: fadeIn 0.5s ease;
}

.water-logo-circle {
  width: 55px;
  height: 55px;
  border-radius: 50%;
  display: grid;
  place-items: center;
  background: linear-gradient(145deg, #fbd6b3, #F07C2A 50%, #96450e);
  border: 2px solid #a64e15;
  font-size: 25px;
  margin: 0 auto 12px;
  box-shadow: inset 0 4px 8px rgba(255, 255, 255, 0.25);
}

.sys-tag {
  font: 700 9px 'JetBrains Mono', monospace;
  color: #F07C2A;
  letter-spacing: 1px;
}

h1 {
  font-size: 18px;
  margin-top: 6px;
}

p {
  font-size: 10px;
  color: #8497b4;
  margin: 4px 0 17px;
}

.role-grid {
  display: flex;
  flex-direction: column;
  gap: 8px;
  margin-top: 15px;
}

.role-card-btn {
  display: flex;
  align-items: center;
  gap: 10px;
  width: 100%;
  text-align: right;
  padding: 10px 11px;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 9px;
  background: rgba(255, 255, 255, 0.035);
  color: #E8EDF5;
  transition: 0.18s;
  cursor: pointer;
  font-family: inherit;
}

.role-card-btn:hover {
  border-color: rgba(240, 124, 42, 0.25);
  background: rgba(240, 124, 42, 0.08);
  transform: translateY(-1px);
}

.role-icon-box {
  width: 33px;
  height: 33px;
  border-radius: 8px;
  display: grid;
  place-items: center;
  background: rgba(240, 124, 42, 0.13);
  font-size: 16px;
}

.role-info {
  flex: 1;
}

.role-info strong {
  display: block;
  font-size: 11px;
}

.role-info small {
  display: block;
  font-size: 8px;
  color: #8497b4;
  margin-top: 2px;
}

.arrow {
  color: #F07C2A;
}

.back-btn {
  background: none;
  border: none;
  color: #8497b4;
  font-size: 9px;
  margin-top: 15px;
  cursor: pointer;
  font-family: inherit;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(6px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
