<template>
  <div class="entry-screen splash-screen">
    <div class="splash-panel">
      <div class="splash-logo-glow">
        <div class="water-logo-circle">🌊</div>
      </div>
      <div class="company-line main">الشركة القابضة لمياه الشرب والصرف الصحى</div>
      <div class="company-line">الشركة القابضة لمياه الشرب والصرف الصحى بمدن القناة</div>
      <div class="company-line muted">قطاع التشغيل والصيانة — إدارة التكاليف</div>
      <div class="splash-system-name">EAM_CMMS_Pro</div>
      <div class="splash-description">نظام إدارة الأصول والتشغيل والصيانة المتكامل</div>
      <div class="splash-rule"></div>
      <div class="splash-stats">
        <div><strong>81</strong><span>محطة</span></div>
        <i></i>
        <div><strong>3</strong><span>قطاعات</span></div>
        <i></i>
        <div><strong>15+</strong><span>وحدة</span></div>
      </div>
      <button class="play-button-large" @click="$emit('start')">
        <span>▶</span><b></b><b></b>
      </button>
      <div class="company-line" style="margin-top:10px">اضغط لبدء الدخول واختيار الدور</div>
      <div class="compliance-badges">
        <span>ISO 55000</span>
        <span>ISO 14224</span>
        <span>CMMS</span>
        <span>EAM Pro</span>
      </div>
      <div class="company-line muted" style="margin-top:10px; font-family:monospace">
        Offline Ready · v3.0.0
      </div>
    </div>
  </div>
</template>

<script setup>
defineEmits(['start']);
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

.entry-screen::before {
  content: '';
  position: absolute;
  inset: 0;
  background-image: linear-gradient(rgba(255, 255, 255, 0.025) 1px, transparent 1px),
    linear-gradient(90deg, rgba(255, 255, 255, 0.025) 1px, transparent 1px);
  background-size: 46px 46px;
  mask-image: linear-gradient(to bottom, rgba(0, 0, 0, 0.8), transparent 85%);
}

.splash-panel {
  position: relative;
  z-index: 1;
  text-align: center;
  width: min(620px, 100%);
  animation: fadeIn 0.5s ease;
}

.splash-logo-glow {
  width: 90px;
  height: 90px;
  border-radius: 50%;
  display: grid;
  place-items: center;
  margin: 0 auto 17px;
  background: radial-gradient(circle, rgba(240, 124, 42, 0.5), rgba(240, 124, 42, 0.08) 56%, transparent 70%);
  filter: drop-shadow(0 0 22px rgba(240, 124, 42, 0.45));
}

.water-logo-circle {
  width: 68px;
  height: 68px;
  border-radius: 50%;
  display: grid;
  place-items: center;
  background: linear-gradient(145deg, #fbd6b3, #F07C2A 50%, #96450e);
  border: 2px solid #a64e15;
  font-size: 31px;
  box-shadow: inset 0 4px 8px rgba(255, 255, 255, 0.25);
}

.company-line {
  font-size: 11px;
  color: #8497b4;
  margin-top: 3px;
}

.company-line.main {
  font-size: 14px;
  font-weight: 800;
  color: #D4AF37;
}

.company-line.muted {
  color: #3d5272;
  font-size: 10px;
}

.splash-system-name {
  font-size: 29px;
  font-weight: 900;
  letter-spacing: 1px;
  margin-top: 22px;
}

.splash-description {
  color: #F07C2A;
  font-size: 12px;
  font-weight: 700;
  margin-top: 3px;
}

.splash-rule {
  width: 220px;
  height: 2px;
  margin: 18px auto;
  background: linear-gradient(90deg, transparent, #F07C2A, transparent);
}

.splash-stats {
  display: flex;
  align-items: center;
  justify-content: center;
  gap: 28px;
  margin: 0 auto 28px;
}

.splash-stats strong {
  display: block;
  font: 900 23px 'JetBrains Mono', monospace;
  color: #F07C2A;
}

.splash-stats span {
  display: block;
  font-size: 9px;
  color: #8497b4;
}

.splash-stats i {
  width: 1px;
  height: 36px;
  background: rgba(255, 255, 255, 0.08);
}

.play-button-large {
  width: 82px;
  height: 82px;
  border-radius: 50%;
  position: relative;
  display: grid;
  place-items: center;
  margin: 0 auto 15px;
  background: linear-gradient(135deg, #F07C2A, #C4601E);
  color: white;
  box-shadow: 0 0 0 rgba(240, 124, 42, 0.4);
  animation: splashPulse 2s infinite;
  transition: 0.2s;
  cursor: pointer;
  border: none;
}

.play-button-large:hover {
  transform: scale(1.08);
}

.play-button-large span {
  font-size: 25px;
  transform: translateX(-1px);
}

.play-button-large b {
  position: absolute;
  border: 1px solid rgba(240, 124, 42, 0.4);
  border-radius: 50%;
  inset: -12px;
  animation: ripple 2s infinite;
}

.play-button-large b + b {
  inset: -24px;
  border-color: rgba(240, 124, 42, 0.2);
  animation-delay: 0.55s;
}

.compliance-badges {
  display: flex;
  justify-content: center;
  gap: 6px;
  flex-wrap: wrap;
  margin-top: 16px;
}

.compliance-badges span {
  font: 600 8px 'JetBrains Mono', monospace;
  letter-spacing: 0.3px;
  color: #F07C2A;
  border: 1px solid rgba(240, 124, 42, 0.25);
  background: rgba(240, 124, 42, 0.08);
  border-radius: 5px;
  padding: 4px 8px;
}

@keyframes splashPulse {
  0%, 100% { box-shadow: 0 0 0 0 rgba(240, 124, 42, 0.55); }
  70% { box-shadow: 0 0 0 20px rgba(240, 124, 42, 0); }
}

@keyframes ripple {
  0% { transform: scale(0.8); opacity: 0.8; }
  100% { transform: scale(1.5); opacity: 0; }
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(6px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
