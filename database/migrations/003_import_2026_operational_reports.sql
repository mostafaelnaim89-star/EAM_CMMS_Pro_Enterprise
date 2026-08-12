-- 003_import_2026_operational_reports.sql (Comprehensive)
-- بيانات تقارير التكاليف والتشغيل وموازنات 2026/2027 لقطاعي بورسعيد والإسماعيلية
BEGIN;

CREATE TABLE IF NOT EXISTS data_import_batches (
    id BIGSERIAL PRIMARY KEY,
    batch_key VARCHAR(120) UNIQUE NOT NULL,
    source_files TEXT[] NOT NULL,
    notes TEXT,
    imported_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS station_cost_reports (
    id BIGSERIAL PRIMARY KEY,
    sector_code VARCHAR(10),
    station_id INT REFERENCES stations(id),
    source_station_name VARCHAR(200) NOT NULL,
    report_month DATE NOT NULL,
    design_capacity_m3_day NUMERIC(15,2),
    actual_capacity_m3_day NUMERIC(15,2),
    raw_water_m3 NUMERIC(15,2),
    production_m3 NUMERIC(15,2),
    efficiency_pct NUMERIC(6,3),
    electricity_egp NUMERIC(15,2),
    chemicals_egp NUMERIC(15,2),
    maintenance_egp NUMERIC(15,2),
    labor_egp NUMERIC(15,2),
    fuel_egp NUMERIC(15,2),
    source_total_operating_egp NUMERIC(15,2),
    source_file VARCHAR(255) NOT NULL,
    notes TEXT,
    imported_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(source_file, source_station_name, report_month)
);

CREATE TABLE IF NOT EXISTS annual_budgets (
    id BIGSERIAL PRIMARY KEY,
    sector_code VARCHAR(10) NOT NULL,
    station_id INT REFERENCES stations(id),
    budget_year INT NOT NULL,
    budget_month INT NOT NULL CHECK (budget_month BETWEEN 1 AND 12),
    budget_egp NUMERIC(15,2) NOT NULL,
    budget_level VARCHAR(20) NOT NULL CHECK (budget_level IN ('محطة','قطاع')),
    source_file VARCHAR(255) NOT NULL,
    imported_at TIMESTAMP DEFAULT NOW(),
    UNIQUE(sector_code, station_id, budget_year, budget_month, budget_level, source_file)
);
CREATE UNIQUE INDEX IF NOT EXISTS ux_annual_budgets_sector_level
    ON annual_budgets (sector_code, budget_year, budget_month, budget_level, source_file)
    WHERE station_id IS NULL;

INSERT INTO data_import_batches (batch_key, source_files, notes) VALUES ('2026-08-12-comprehensive-import', ARRAY['PortSaid_Annual_Budget_2026.xlsx','Ismailia_Annual_Budget_2026.xlsx'], 'استيراد شامل لموازنات وتكاليف قطاعي بورسعيد والإسماعيلية لعامي 2026 و2027.') ON CONFLICT (batch_key) DO NOTHING;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('PORT', 'محطة الإصلاح', '2026-06-01', 4800, 60980, 0.85, 59960, 11532.35, 17617.17, 89109.52, 'PortSaid_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع بورسعيد')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('PORT', 'محطة الصدق', '2026-06-01', 12000, 145500, 0.55, 130375, 26904.11, 15299.34, 172578.45, 'PortSaid_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع بورسعيد')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('PORT', 'محطة بحر البقر القديمة', '2026-06-01', 4800, 80400, 0.7, 159690, 14866.63, 14450.72, 189007.35, 'PortSaid_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع بورسعيد')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('PORT', 'محطة بحر البقر الجديدة', '2026-06-01', 14400, 239400, 0.85, 251010, 44267.8, 21841.5, 317119.3, 'PortSaid_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع بورسعيد')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('PORT', 'محطة الكاب', '2026-06-01', 8400, 153000, 0.75, 366100, 28293.67, 22191.64, 416585.31, 'PortSaid_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع بورسعيد')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('PORT', 'محطة الكاب المرشحة الحمارين', '2026-06-01', 26000, 592500, 0.9, 745345, 101530.77, 45463.61, 892339.38, 'PortSaid_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع بورسعيد')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'العمده صالح', '2026-06-01', 5000, 79830, 0.8, NULL, 19275.0, NULL, 19275, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'الضبعية', '2026-06-01', 5000, 71910, 0.7, NULL, 15963.0, 2900, 18863, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'عين غصين 1', '2026-06-01', 2000, NULL, 0.5, NULL, 0.0, NULL, NULL, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'عين غصين 2', '2026-06-01', 2000, 49530, 0.7, NULL, 13404.24, NULL, 13404.24, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'عين غصين الكبرى', '2026-06-01', 8000, 238950, 0.95, NULL, 36591.0, NULL, 36591, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'الكيلو 11', '2026-06-01', 5000, 118860, 0.95, NULL, 21095.0, NULL, 21095, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'المحطة المدمجة بالفردان', '2026-06-01', 2000, 59880, 0.95, NULL, 12170.0, NULL, 12170, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'الكيلو 7', '2026-06-01', 2000, 49140, 0.7, NULL, 12790.2, 6712, 19502.2, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO station_cost_reports (sector_code, source_station_name, report_month, design_capacity_m3_day, production_m3, efficiency_pct, electricity_egp, chemicals_egp, fuel_egp, source_total_operating_egp, source_file, notes)
VALUES ('ISM', 'نفيشة RO', '2026-06-01', 2000, 33000, 0.85, NULL, 1842.0, NULL, 1842, 'Ismailia_Annual_Budget_2026.xlsx', 'بيان يونيو 2026 الفعلي لقطاع الإسماعيلية')
ON CONFLICT (source_file, source_station_name, report_month) DO UPDATE SET production_m3=EXCLUDED.production_m3, source_total_operating_egp=EXCLUDED.source_total_operating_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 1, 86258, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 2, 88218, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 3, 93119, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 4, 98020, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 5, 105862, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 6, 112724, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 7, 117625, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 8, 115664, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 9, 102921, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 10, 93119, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 11, 86258, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الإصلاح' LIMIT 1), 2027, 12, 83317, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 1, 167056, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 2, 170853, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 3, 180344, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 4, 189836, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 5, 205023, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 6, 218312, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 7, 227804, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 8, 224007, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 9, 199328, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 10, 180344, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 11, 167056, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الصدق' LIMIT 1), 2027, 12, 161361, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 1, 182959, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 2, 187117, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 3, 197513, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 4, 207908, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 5, 224541, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 6, 239094, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 7, 249490, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 8, 245332, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 9, 218303, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 10, 197513, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 11, 182959, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر القديمة' LIMIT 1), 2027, 12, 176722, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 1, 306971, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 2, 313948, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 3, 331390, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 4, 348831, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 5, 376738, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 6, 401156, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 7, 418597, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 8, 411621, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 9, 366273, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 10, 331390, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 11, 306971, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة بحر البقر الجديدة' LIMIT 1), 2027, 12, 296507, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 1, 403255, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 2, 412419, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 3, 435332, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 4, 458244, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 5, 494903, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 6, 526980, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 7, 549893, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 8, 540728, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 9, 481156, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 10, 435332, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 11, 403255, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب' LIMIT 1), 2027, 12, 389507, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 1, 863785, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 2, 883416, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 3, 932495, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 4, 981573, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 5, 1060099, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 6, 1128809, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 7, 1177888, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 8, 1158257, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 9, 1030652, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 10, 932495, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 11, 863785, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('PORT', (SELECT id FROM stations WHERE name='محطة الكاب المرشحة الحمارين' LIMIT 1), 2027, 12, 834337, 'محطة', 'PortSaid_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 1, 18658, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 2, 19082, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 3, 20142, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 4, 21203, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 5, 22899, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 6, 24383, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 7, 25443, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 8, 25019, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 9, 22263, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 10, 20142, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 11, 18658, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='العمده صالح' LIMIT 1), 2027, 12, 18022, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 1, 18259, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 2, 18674, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 3, 19712, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 4, 20749, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 5, 22409, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 6, 23862, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 7, 24899, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 8, 24484, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 9, 21787, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 10, 19712, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 11, 18259, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الضبعية' LIMIT 1), 2027, 12, 17637, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 1, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 2, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 3, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 4, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 5, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 6, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 7, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 8, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 9, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 10, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 11, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 1' LIMIT 1), 2027, 12, 0, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 1, 12975, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 2, 13270, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 3, 14007, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 4, 14745, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 5, 15924, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 6, 16956, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 7, 17694, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 8, 17399, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 9, 15482, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 10, 14007, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 11, 12975, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين 2' LIMIT 1), 2027, 12, 12533, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 1, 35420, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 2, 36225, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 3, 38238, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 4, 40250, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 5, 43470, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 6, 46288, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 7, 48300, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 8, 47495, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 9, 42263, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 10, 38238, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 11, 35420, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='عين غصين الكبرى' LIMIT 1), 2027, 12, 34213, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 1, 20420, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 2, 20884, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 3, 22044, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 4, 23205, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 5, 25061, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 6, 26685, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 7, 27845, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 8, 27381, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 9, 24365, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 10, 22044, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 11, 20420, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 11' LIMIT 1), 2027, 12, 19724, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 1, 11781, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 2, 12048, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 3, 12718, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 4, 13387, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 5, 14458, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 6, 15395, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 7, 16064, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 8, 15797, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 9, 14056, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 10, 12718, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 11, 11781, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='المحطة المدمجة بالفردان' LIMIT 1), 2027, 12, 11379, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 1, 18878, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 2, 19307, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 3, 20380, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 4, 21452, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 5, 23169, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 6, 24670, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 7, 25743, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 8, 25314, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 9, 22525, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 10, 20380, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 11, 18878, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='الكيلو 7' LIMIT 1), 2027, 12, 18235, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 1, 1783, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 2, 1824, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 3, 1925, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 4, 2026, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 5, 2188, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 6, 2330, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 7, 2431, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 8, 2391, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 9, 2128, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 10, 1925, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 11, 1783, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
INSERT INTO annual_budgets (sector_code, station_id, budget_year, budget_month, budget_egp, budget_level, source_file)
VALUES ('ISM', (SELECT id FROM stations WHERE name='نفيشة RO' LIMIT 1), 2027, 12, 1722, 'محطة', 'Ismailia_Annual_Budget_2026.xlsx')
ON CONFLICT (sector_code, station_id, budget_year, budget_month, budget_level, source_file) DO UPDATE SET budget_egp=EXCLUDED.budget_egp;
COMMIT;