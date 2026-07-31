// ==========================================
// EAM_CMMS_Pro Supabase Client & Operations Code
// Run this in your frontend/backend code to interact with the database.
// ==========================================

import { createClient } from '@supabase/supabase-js'

// Initialize Supabase Client (Replace with your actual Supabase URL and Anon Key)
const SUPABASE_URL = 'YOUR_SUPABASE_URL'
const SUPABASE_ANON_KEY = 'YOUR_SUPABASE_ANON_KEY'

export const supabase = createClient(SUPABASE_URL, SUPABASE_ANON_KEY)

// 1. Function to insert a new water station
export async function addStation(stationData: {
  station_name: string
  sector: string
  design_capacity_m3_day: number
  actual_capacity_m3_day?: number
  evaluation_percentage?: number
  notes?: string
}) {
  const { data, error } = await supabase
    .from('stations')
    .insert([stationData])
    .select()

  if (error) {
    console.error('Error inserting station:', error.message)
    return null
  }
  return data
}

// 2. Function to log monthly operation and maintenance costs
export async function addMonthlyCost(costData: {
  station_id: number
  month_year: string
  actual_capacity_m3_month: number
  electricity_bill_egp: number
  electricity_cost_per_m3_pt: number
  alum_liquid_ton: number
  alum_solid_ton: number
  total_alum_cost_egp: number
  chlorine_gas_ton: number
  chlorine_liquid_ton: number
  total_chlorine_cost_egp: number
  maintenance_cost_egp: number
  total_operation_cost_egp: number
  total_op_and_maint_cost_egp: number
}) {
  const { data, error } = await supabase
    .from('monthly_operation_costs')
    .insert([costData])
    .select()

  if (error) {
    console.error('Error inserting monthly cost:', error.message)
    return null
  }
  return data
}

// 3. Function to fetch all stations with their sectors
export async function fetchStations() {
  const { data, error } = await supabase
    .from('stations')
    .select('*')

  if (error) {
    console.error('Error fetching stations:', error.message)
    return []
  }
  return data
}

