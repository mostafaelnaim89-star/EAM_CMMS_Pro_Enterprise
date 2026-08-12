import { mondayIsConfigured } from '../../utils/monday'
import { obsidianIsConfigured } from '../../utils/obsidian'

export default defineEventHandler(() => {
  const obsidianConfigured = obsidianIsConfigured()

  return {
    monday: {
      configured: mondayIsConfigured(),
      detail: mondayIsConfigured() ? 'Token and board configured' : 'MONDAY_API_TOKEN and MONDAY_BOARD_ID are required'
    },
    obsidian: {
      configured: obsidianConfigured,
      detail: obsidianConfigured ? 'Local REST API bridge configured' : 'Optional Local REST API bridge is not configured'
    },
    replit: {
      configured: true,
      detail: 'Replit configuration files are present in the repository'
    }
  }
})
