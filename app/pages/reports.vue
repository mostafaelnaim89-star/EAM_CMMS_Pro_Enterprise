<template>
  <div class="page-container">
    <div class="page-heading">
      <div>
        <div class="breadcrumb">التكاليف والتقارير <span>/</span> وحدة التقارير التنفيذية</div>
        <h1>وحدة التقارير والأدلة التنفيذية</h1>
        <p>توليد وتصدير التقارير الهندسية والمالية المعتمدة لقطاعات مدن القناة وفق معايير ISO 55000.</p>
      </div>
      <div class="heading-acts">
        <button class="secondary-button" type="button" @click="generatePDF">🖨️ طباعة التقرير PDF</button>
        <button class="primary-button" type="button" @click="exportExcel"><span>↓</span> تصدير Excel</button>
      </div>
    </div>

    <div class="reports-layout">
      <!-- Sidebar / Report Selector -->
      <aside class="reports-sidebar">
        <div class="sb-title">التقارير المتاحة</div>
        <div 
          v-for="rpt in reportTypes" 
          :key="rpt.id" 
          :class="['rpt-item', { active: currentReport === rpt.id }]"
          @click="currentReport = rpt.id"
        >
          <div class="rpt-icon" :style="{ background: rpt.bg, color: rpt.color }">{{ rpt.icon }}</div>
          <div class="rpt-info">
            <div class="rpt-name">{{ rpt.name }}</div>
            <div class="rpt-sub">{{ rpt.sub }}</div>
          </div>
        </div>
      </aside>

      <!-- Main Preview Area -->
      <main class="reports-preview-area">
        <div class="preview-toolbar">
          <span class="preview-label">معاينة التقرير المعتمد: <b>{{ activeReportName }}</b></span>
          <div class="preview-acts">
            <button class="btn-sm" @click="refreshReport">↻ تحديث البيانات</button>
          </div>
        </div>

        <div class="pdf-preview">
          <div class="pdf-header">
            <div class="pdf-logo-row">
              <div class="pdf-org">
                <strong>الشركة القابضة لمياه الشرب والصرف الصحى بمدن القناة</strong><br>
                قطاع التشغيل والصيانة — الإدارة العامة للأصول والصيانة
              </div>
              <div class="pdf-badge">ISO 55000 · EAM PRO</div>
            </div>
            <div class="pdf-title">
              <h2>{{ activeReportName }}</h2>
              <p>فترة التقرير: يونيو 2026 — الاعتماد المالي والفني</p>
            </div>
            <div class="pdf-meta">
              <div class="pdf-meta-item">القطاع المستهدف: <strong>كل القطاعات (الإسماعيلية، السويس، بورسعيد)</strong></div>
              <div class="pdf-meta-item">تاريخ الإصدار: <strong>12 أغسطس 2026</strong></div>
            </div>
          </div>

          <div class="pdf-kpi-row">
            <div class="pdf-kpi">
              <div class="pdf-kpi-val">81</div>
              <div class="pdf-kpi-lbl">إجمالي المحطات</div>
            </div>
            <div class="pdf-kpi">
              <div class="pdf-kpi-val">7.04M</div>
              <div class="pdf-kpi-lbl">التكلفة الفعلية (ج.م)</div>
            </div>
            <div class="pdf-kpi">
              <div class="pdf-kpi-val">94.2%</div>
              <div class="pdf-kpi-lbl">نسبة الكفاءة العامة</div>
            </div>
            <div class="pdf-kpi">
              <div class="pdf-kpi-val">127</div>
              <div class="pdf-kpi-lbl">أوامر العمل المغلقة</div>
            </div>
          </div>

          <div class="pdf-section">
            <div class="pdf-section-title">ملخص الأداء التشغيلي والمالي لقطاعات القناة</div>
            <table class="pdf-table">
              <thead>
                <tr>
                  <th>القطاع التشغيلي</th>
                  <th>عدد المحطات</th>
                  <th>الإنتاج الفعلي (م³)</th>
                  <th>التكلفة الفعلية (ج.م)</th>
                  <th>كفاءة التشغيل</th>
                  <th>الحالة</th>
                </tr>
              </thead>
              <tbody>
                <tr>
                  <td><strong>الإسماعيلية</strong></td>
                  <td>64</td>
                  <td>2,150,000</td>
                  <td>2.18M</td>
                  <td>84%</td>
                  <td><span class="bdg b-or">مستقر</span></td>
                </tr>
                <tr>
                  <td><strong>السويس</strong></td>
                  <td>11</td>
                  <td>3,420,000</td>
                  <td>3.12M</td>
                  <td>88%</td>
                  <td><span class="bdg b-gr">ممتاز</span></td>
                </tr>
                <tr>
                  <td><strong>بورسعيد</strong></td>
                  <td>6</td>
                  <td>1,271,780</td>
                  <td>2.077M</td>
                  <td>87%</td>
                  <td><span class="bdg b-te">مستقر</span></td>
                </tr>
              </tbody>
            </table>
          </div>

          <div class="pdf-sig">
            <div class="pdf-sig-item">
              <div class="pdf-sig-line">مدير عام التشغيل والصيانة</div>
            </div>
            <div class="pdf-sig-item">
              <div class="pdf-sig-line">رئيس قطاع الدعم الفني والأصول</div>
            </div>
            <div class="pdf-sig-item">
              <div class="pdf-sig-line">العضو المنتدب التنفيذي</div>
            </div>
          </div>

          <div class="pdf-footer">
            <span>نظام EAM_CMMS_Pro Enterprise الإصدار 3.0</span>
            <span>تم استخراج التقرير آلياً من قاعدة البيانات الموحدة</span>
          </div>
        </div>
      </main>
    </div>

    <div v-if="toast" class="toast-message">✓ {{ toast }}</div>
  </div>
</template>

<script setup lang="ts">
import { ref, computed } from 'vue'

useHead({ title: 'EAM_CMMS_Pro — وحدة التقارير التنفيذية' })

const currentReport = ref('perf')
const toast = ref('')

const reportTypes = [
  { id: 'perf', name: 'تقرير الأداء التشغيلي العام', sub: 'المحطات والإنتاج والكفاءة', icon: '📊', bg: 'rgba(240,124,42,0.12)', color: '#F07C2A' },
  { id: 'cost', name: 'تقرير التكاليف والموازنة', sub: 'استهلاك الطاقة والكيماويات', icon: '◉', bg: 'rgba(0,180,166,0.12)', color: '#00B4A6' },
  { id: 'maint', name: 'تقرير الصيانة والأصول', sub: 'أوامر العمل وحالة المعدات', icon: '⚙️', bg: 'rgba(46,204,113,0.12)', color: '#2ECC71' },
  { id: 'iso', name: 'مراجعة معايير ISO 55000', sub: 'تدقيق إدارة الأصول المؤسسية', icon: '🛡️', bg: 'rgba(212,175,55,0.12)', color: '#D4AF37' }
]

const activeReportName = computed(() => {
  return reportTypes.find(r => r.id === currentReport.value)?.name || 'تقرير الأداء'
})

const refreshReport = () => { showToast('تم تحديث بيانات التقرير من الخادم السحابي') }
const generatePDF = () => { showToast('جاري تصدير التقرير بتنسيق PDF عالي الدقة...') }
const exportExcel = () => { showToast('جاري تصدير جداول البيانات بصيغة Excel...') }
const showToast = (msg: string) => { toast.value = msg; setTimeout(() => toast.value = '', 3000) }
</script>

<style scoped>
.page-container { padding: 24px; font-family: 'Cairo', sans-serif; color: #E8EDF5; }
.page-heading { display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px; flex-wrap: wrap; gap: 15px; }
.page-heading h1 { font-size: 22px; font-weight: 900; color: #F07C2A; margin-top: 4px; }
.page-heading p { font-size: 11px; color: #7A8FAD; margin-top: 2px; }
.heading-acts { display: flex; gap: 10px; }

.reports-layout { display: grid; grid-template-columns: 280px 1fr; gap: 20px; align-items: flex-start; }
.reports-sidebar { background: rgba(22, 42, 80, 0.5); border: 1px solid rgba(255, 255, 255, 0.07); border-radius: 12px; padding: 12px; overflow: hidden; }
.sb-title { font-size: 10px; font-weight: 700; color: #7A8FAD; letter-spacing: 1.2px; padding: 10px 12px 6px; }
.rpt-item { display: flex; align-items: center; gap: 12px; padding: 12px; border-radius: 9px; cursor: pointer; transition: 0.2s; border-right: 3px solid transparent; margin-bottom: 4px; }
.rpt-item:hover { background: rgba(255, 255, 255, 0.03); }
.rpt-item.active { background: rgba(240, 124, 42, 0.1); border-right-color: #F07C2A; }
.rpt-icon { width: 36px; height: 36px; border-radius: 8px; display: grid; place-items: center; font-size: 16px; flex-shrink: 0; }
.rpt-info { min-width: 0; }
.rpt-name { font-size: 12px; font-weight: 700; color: #E8EDF5; }
.rpt-sub { font-size: 10px; color: #7A8FAD; margin-top: 2px; }

.reports-preview-area { background: rgba(22, 42, 80, 0.5); border: 1px solid rgba(255, 255, 255, 0.07); border-radius: 12px; overflow: hidden; }
.preview-toolbar { background: rgba(255, 255, 255, 0.03); border-bottom: 1px solid rgba(255, 255, 255, 0.07); padding: 12px 20px; display: flex; justify-content: space-between; align-items: center; }
.preview-label { font-size: 11px; color: #7A8FAD; }
.preview-label b { color: #F07C2A; }

.pdf-preview { background: #fff; color: #1a1a1a; padding: 32px; font-family: 'Cairo', sans-serif; direction: rtl; min-height: 600px; }
.pdf-header { border-bottom: 3px solid #0F1F3D; padding-bottom: 16px; margin-bottom: 20px; }
.pdf-logo-row { display: flex; justify-content: space-between; align-items: center; }
.pdf-org { font-size: 11px; line-height: 1.6; color: #333; }
.pdf-org strong { color: #0F1F3D; font-size: 13px; }
.pdf-badge { background: #0F1F3D; color: white; padding: 5px 14px; border-radius: 4px; font-size: 10px; font-weight: 700; font-family: 'JetBrains Mono', monospace; }
.pdf-title { text-align: center; margin-top: 14px; }
.pdf-title h2 { font-size: 16px; font-weight: 900; color: #0F1F3D; margin-bottom: 3px; }
.pdf-title p { font-size: 11px; color: #666; }
.pdf-meta { display: flex; gap: 24px; margin-top: 12px; padding: 8px 14px; background: #f4f6f9; border-radius: 6px; border-right: 3px solid #F07C2A; }
.pdf-meta-item { font-size: 10px; color: #555; }
.pdf-meta-item strong { color: #0F1F3D; }

.pdf-kpi-row { display: grid; grid-template-columns: repeat(4, 1fr); gap: 10px; margin-bottom: 20px; }
.pdf-kpi { background: #f0f4ff; border-radius: 8px; padding: 12px; text-align: center; border-top: 2px solid #F07C2A; }
.pdf-kpi-val { font: 900 18px 'JetBrains Mono', monospace; color: #0F1F3D; }
.pdf-kpi-lbl { font-size: 9px; color: #666; margin-top: 2px; }

.pdf-section { margin-bottom: 20px; }
.pdf-section-title { font-size: 12px; font-weight: 800; color: #0F1F3D; padding: 6px 12px; background: #f0f4ff; border-right: 3px solid #F07C2A; margin-bottom: 10px; border-radius: 0 4px 4px 0; }
.pdf-table { width: 100%; border-collapse: collapse; font-size: 11px; }
.pdf-table th { background: #0F1F3D; color: #fff; padding: 8px 12px; text-align: right; font-weight: 700; }
.pdf-table td { padding: 8px 12px; border-bottom: 1px solid #eee; vertical-align: middle; }
.pdf-table tr:nth-child(even) td { background: #f9fafb; }

.bdg { display: inline-flex; font-size: 10px; font-weight: 700; padding: 2px 8px; border-radius: 4px; }
.b-or { background: rgba(240,124,42,0.12); color: #C4601E; }
.b-gr { background: rgba(46,204,113,0.12); color: #1e8449; }
.b-te { background: rgba(0,180,166,0.12); color: #007a72; }

.pdf-sig { display: flex; gap: 30px; margin-top: 24px; padding-top: 16px; border-top: 1px dashed #ddd; }
.pdf-sig-item { flex: 1; text-align: center; }
.pdf-sig-line { border-top: 1px solid #444; margin-top: 28px; padding-top: 6px; font-size: 10px; color: #555; }

.pdf-footer { border-top: 1px solid #ddd; padding-top: 12px; margin-top: 20px; display: flex; justify-content: space-between; font-size: 9px; color: #888; font-family: 'JetBrains Mono', monospace; }

.primary-button, .secondary-button, .btn-sm { border-radius: 8px; padding: 8px 16px; font-family: 'Cairo', sans-serif; font-size: 11px; font-weight: 800; cursor: pointer; border: none; transition: 0.2s; }
.primary-button { background: linear-gradient(135deg, #F07C2A, #C4601E); color: white; box-shadow: 0 4px 14px rgba(240,124,42,0.25); }
.primary-button:hover { transform: translateY(-1px); }
.secondary-button { background: rgba(255,255,255,0.06); color: #E8EDF5; border: 1px solid rgba(255,255,255,0.08); }
.secondary-button:hover { border-color: #F07C2A; }
.btn-sm { background: rgba(240,124,42,0.12); color: #F07C2A; padding: 6px 12px; border-radius: 6px; }
.btn-sm:hover { background: #F07C2A; color: white; }

.toast-message { position: fixed; bottom: 25px; right: 50%; transform: translateX(50%); z-index: 9999; background: #2ECC71; color: #061b12; padding: 10px 20px; border-radius: 24px; font-size: 11px; font-weight: 800; box-shadow: 0 8px 25px rgba(0,0,0,0.3); }

@media (max-width: 900px) {
  .reports-layout { grid-template-columns: 1fr; }
  .pdf-kpi-row { grid-template-columns: repeat(2, 1fr); }
  .pdf-sig { flex-direction: column; gap: 15px; }
}
</style>
