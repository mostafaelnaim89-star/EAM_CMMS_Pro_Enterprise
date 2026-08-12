<template>
  <div class="ai-assistant-widget">
    <div v-if="!isOpen" class="ai-fab" @click="isOpen = true" title="مساعد EAM الذكي">
      💬
    </div>
    <div v-else class="ai-chat-box">
      <div class="ai-header">
        <div class="ai-title">🤖 مساعد EAM الذكي للتشغيل والصيانة</div>
        <button class="ai-close" @click="isOpen = false">✕</button>
      </div>
      <div class="ai-messages" ref="msgContainer">
        <div v-for="(m, i) in messages" :key="i" :class="['ai-msg', m.sender]">
          {{ m.text }}
        </div>
      </div>
      <div class="ai-input-area">
        <input 
          type="text" 
          v-model="inputQuery" 
          @keyup.enter="sendQuery" 
          placeholder="اسأل عن المحطات، التكاليف، أو الكود المصري..." 
        />
        <button @click="sendQuery">إرسال</button>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, nextTick } from 'vue'

const isOpen = ref(false)
const inputQuery = ref('')
const msgContainer = ref<HTMLElement | null>(null)

const messages = ref([
  { sender: 'bot', text: 'أهلاً بك! أنا مساعد EAM الذكي. يمكنك سؤالي عن تكاليف التشغيل، المحطات الـ 81، أو أدلة الصيانة والكود المصري.' }
])

const sendQuery = async () => {
  if (!inputQuery.value.trim()) return
  const q = inputQuery.value
  messages.value.push({ sender: 'user', text: q })
  inputQuery.value = ''
  
  await nextTick()
  if (msgContainer.value) msgContainer.value.scrollTop = msgContainer.value.scrollHeight

  setTimeout(() => {
    let reply = 'عذراً، لم أتمكن من مطابقة سؤالك بدقة. يمكنك السؤال عن: تكاليف بورسعيد (2.077 مليون جنيه)، موازنة 2027 (27.57 مليون جنيه)، الكود المصري للتشغيل والصيانة، أو صيانة طلمبات البوستر.'
    const lower = q.toLowerCase()
    if (lower.includes('بورسعيد') || lower.includes('تكلفة')) {
      reply = 'قطاع بورسعيد سجل تكلفة فعلية 2.077 مليون جنيه بإنتاج 1,271,780 متر مكعب لشهر يونيو/يوليو 2026، وموازنة 2027 المقدرة 27.573 مليون جنيه.'
    } else if (lower.includes('كود') || lower.includes('صيانة') || lower.includes('بوستر') || lower.includes('التل الكبير')) {
      reply = 'المكتبة الفنية تضم الكود المصري للتشغيل والصيانة، أدلة صيانة طلمبات البوستر، وصيانة المضخات والمحركات، بالإضافة لخطوات التشغيل القياسي (SOP) لمحطة التل الكبير.'
    } else if (lower.includes('محطة') || lower.includes('81')) {
      reply = 'النظام يدير 81 محطة موزعة على 3 قطاعات رئيسية: الإسماعيلية (71 محطة)، بورسعيد (6 محطات)، والسويس (4 محطات).'
    }
    messages.value.push({ sender: 'bot', text: reply })
    nextTick(() => {
      if (msgContainer.value) msgContainer.value.scrollTop = msgContainer.value.scrollHeight
    })
  }, 600)
}
</script>

<style scoped>
.ai-assistant-widget { position: fixed; bottom: 25px; left: 25px; z-index: 9999; font-family: 'Cairo', sans-serif; }
.ai-fab { width: 55px; height: 55px; border-radius: 50%; background: #F07C2A; color: white; display: grid; place-items: center; font-size: 24px; cursor: pointer; box-shadow: 0 10px 25px rgba(240,124,42,0.4); transition: 0.3s; }
.ai-fab:hover { transform: scale(1.1); }
.ai-chat-box { width: 340px; height: 420px; background: #0b192c; border: 1px solid rgba(240,124,42,0.4); border-radius: 16px; display: flex; flex-direction: column; box-shadow: 0 15px 40px rgba(0,0,0,0.5); overflow: hidden; }
.ai-header { background: linear-gradient(90deg, #040b16, #162a50); padding: 12px 16px; display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid rgba(255,255,255,0.1); }
.ai-title { font-size: 13px; font-weight: 700; color: #F07C2A; }
.ai-close { background: none; border: none; color: #fff; cursor: pointer; font-size: 16px; }
.ai-messages { flex: 1; padding: 12px; overflow-y: auto; display: flex; flex-direction: column; gap: 10px; font-size: 12px; }
.ai-msg { padding: 8px 12px; border-radius: 10px; max-width: 85%; line-height: 1.5; }
.ai-msg.bot { background: rgba(22,42,80,0.8); color: #DCE7F5; align-self: flex-start; border-right: 3px solid #00B4A6; }
.ai-msg.user { background: #F07C2A; color: white; align-self: flex-end; }
.ai-input-area { padding: 10px; background: #07101f; display: flex; gap: 8px; border-top: 1px solid rgba(255,255,255,0.05); }
.ai-input-area input { flex: 1; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); padding: 8px 12px; border-radius: 8px; color: white; font-size: 12px; }
.ai-input-area button { background: #F07C2A; border: none; color: white; padding: 8px 14px; border-radius: 8px; font-weight: 700; cursor: pointer; font-size: 12px; }
</style>
