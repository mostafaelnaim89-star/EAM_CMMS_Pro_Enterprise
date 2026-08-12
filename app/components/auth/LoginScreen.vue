<template>
  <div class="entry-screen login-screen">
    <div class="login-panel">
      <button class="change-role-btn" @click="$emit('change-role')">← تغيير الدور</button>
      <div class="water-logo-circle">🌊</div>
      <div class="role-name-tag">{{ roleName }}</div>
      <h1>تسجيل الدخول إلى النظام</h1>
      <p>EAM_CMMS_Pro — منصة إدارة الأصول والصيانة المتكاملة</p>
      
      <form class="login-form-box" @submit.prevent="handleSubmit">
        <div class="form-group">
          <label>البريد الإلكتروني</label>
          <input 
            type="email" 
            v-model="form.email" 
            required 
            placeholder="name@canal-water.eg"
          >
        </div>
        <div class="form-group">
          <label>كلمة المرور</label>
          <input 
            type="password" 
            v-model="form.password" 
            required 
            placeholder="••••••••"
          >
        </div>
        <button type="submit" class="submit-btn">
          دخول إلى لوحة القيادة ←
        </button>
      </form>
      <div class="hint">للتجربة المحلية: استخدم أي بريد وكلمة مرور.</div>
    </div>
  </div>
</template>

<script setup>
import { reactive } from 'vue';

const props = defineProps({
  roleName: { type: String, default: 'تسجيل الدخول' },
  initialEmail: { type: String, default: '' }
});

const emit = defineEmits(['login', 'change-role']);

const form = reactive({
  email: props.initialEmail,
  password: '••••••••'
});

const handleSubmit = () => {
  emit('login', { ...form });
};
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

.login-panel {
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

.change-role-btn {
  background: none;
  border: none;
  color: #8497b4;
  font-size: 9px;
  display: block;
  margin: 0 0 8px auto;
  cursor: pointer;
  font-family: inherit;
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

.role-name-tag {
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

.login-form-box {
  margin-top: 19px;
  text-align: right;
}

.form-group {
  margin-bottom: 12px;
}

.form-group label {
  display: block;
  color: #8497b4;
  font-size: 10px;
  font-weight: 700;
  margin-bottom: 5px;
}

.form-group input {
  display: block;
  width: 100%;
  border: 1px solid rgba(255, 255, 255, 0.08);
  border-radius: 7px;
  background: rgba(255, 255, 255, 0.05);
  color: #E8EDF5;
  outline: 0;
  padding: 9px 11px;
  font-size: 11px;
  direction: rtl;
  font-family: inherit;
}

.form-group input:focus {
  border-color: #F07C2A;
}

.submit-btn {
  width: 100%;
  justify-content: center;
  padding: 10px;
  margin-top: 5px;
  background: linear-gradient(135deg, #F07C2A, #C4601E);
  color: #fff;
  border: none;
  border-radius: 7px;
  font-family: inherit;
  font-size: 12px;
  font-weight: 700;
  cursor: pointer;
  box-shadow: 0 3px 10px rgba(240, 124, 42, 0.28);
  transition: 0.17s;
}

.submit-btn:hover {
  transform: translateY(-1px);
  box-shadow: 0 5px 16px rgba(240, 124, 42, 0.4);
}

.hint {
  color: #3d5272;
  font-size: 8px;
  margin-top: 13px;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(6px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
