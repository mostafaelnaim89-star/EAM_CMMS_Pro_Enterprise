<template>
  <div class="app-body" style="font-family: Arial, sans-serif; background-color: #0d1b2a; color: #fff; min-height: 100vh; padding: 20px; direction: rtl;">
    <!-- الشريط العلوي -->
    <header class="top-header" style="background: #1b263b; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-bottom: 2px solid #3b82f6;">
      <div class="org-name" style="font-size: 14px; line-height: 1.6;">
        <strong style="display: block; font-size: 16px; color: #60a5fa;">الشركة القابضة لمياه الشرب والصرف الصحى بمدن القناة</strong>
        Hydro-ops — إدارة الأصول وصيانة المحطات
      </div>
    </header>

    <!-- المحتوى الرئيسي للوحة القيادة والمحطات -->
    <main class="main-content">
      <!-- المؤشرات الحية -->
      <div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-bottom: 20px;">
        <div style="background: #1b263b; padding: 15px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.07);">
          <div style="font-size: 24px; font-weight: bold; color: #34d399;">{{ stats.totalAssets }}</div>
          <div style="font-size: 12px; color: #94a3b8; margin-top: 5px;">إجمالي الأصول والمحطات</div>
        </div>
        <div style="background: #1b263b; padding: 15px; border-radius: 8px; border: 1px solid rgba(255,255,255,0.07);">
          <div style="font-size: 24px; font-weight: bold; color: #f87171;">{{ stats.pendingWorkOrders }}</div>
          <div style="font-size: 12px; color: #94a3b8; margin-top: 5px;">أوامر الشغل المعلقة</div>
        </div>
      </div>

      <!-- نموذج إضافة محطة جديدة متصل بقاعدة البيانات -->
      <div style="background: #1b263b; padding: 20px; border-radius: 10px; border: 1px solid rgba(255,255,255,0.07);">
        <h3 style="margin-bottom: 15px; font-size: 15px; color: #60a5fa;">إضافة محطة جديدة إلى النظام</h3>
        <form @submit.prevent="addNewStation">
          <div style="margin-bottom: 12px;">
            <input v-model="newStation.name" placeholder="اسم المحطة (مثال: محطة مياه القنطرة)" required style="width: 100%; padding: 10px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: #fff; border-radius: 6px; box-sizing: border-box;" />
          </div>
          <div style="margin-bottom: 12px;">
            <input v-model="newStation.code" placeholder="كود المحطة (مثال: ST-ISMAILIA-01)" required style="width: 100%; padding: 10px; background: rgba(255,255,255,0.05); border: 1px solid rgba(255,255,255,0.1); color: #fff; border-radius: 6px; box-sizing: border-box;" />
          </div>
          <button type="submit" style="background: #059669; color: #fff; border: none; padding: 10px 20px; border-radius: 6px; font-weight: bold; cursor: pointer; width: 100%;">حفظ وإضافة المحطة</button>
        </form>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { supabase } from '~/supabaseClient'

const stats = ref({
  totalAssets: 0,
  pendingWorkOrders: 0
})

const newStation = ref({
  name: '',
  code: ''
})

// جلب المؤشرات الحية من Supabase
const fetchStats = async () => {
  try {
    const { count: assetsCount } = await supabase.from('assets').select('*', { count: 'exact', head: true })
    const { count: woCount } = await supabase.from('work_orders').select('*', { count: 'exact', head: true }).eq('status', 'pending')
    
    stats.value.totalAssets = assetsCount || 0
    stats.value.pendingWorkOrders = woCount || 0
  } catch (err) {
    console.error("خطأ في جلب البيانات:", err)
  }
}

// إدخال بيانات محطة جديدة
const addNewStation = async () => {
  const { error } = await supabase.from('stations').insert([
    { station_name: newStation.value.name, station_code: newStation.value.code }
  ])
  
  if (error) {
    alert("حدث خطأ أثناء الإضافة: " + error.message)
  } else {
    alert("تمت إضافة المحطة بنجاح!")
    newStation.value.name = ''
    newStation.value.code = ''
    fetchStats()
  }
}

onMounted(() => {
  fetchStats()
})
</script>

