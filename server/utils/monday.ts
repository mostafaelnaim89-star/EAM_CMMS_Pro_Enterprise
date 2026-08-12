export interface MondayWorkOrder {
  id?: string
  title: string
  status?: string
  priority?: string
  sector?: string
  station?: string
  assignedTo?: string
  dueDate?: string
  description?: string
}

interface MondayGraphqlResponse<T> {
  data?: T
  errors?: Array<{ message?: string }>
}

function mondayConfig() {
  const runtime = useRuntimeConfig()
  const token = runtime.mondayApiToken || process.env.MONDAY_API_TOKEN || process.env.MONDAY_API_KEY || ''
  const boardId = runtime.mondayBoardId || process.env.MONDAY_BOARD_ID || ''
  const groupId = runtime.mondayGroupId || process.env.MONDAY_GROUP_ID || ''
  return { token, boardId, groupId }
}

async function mondayGraphql<T>(query: string, variables: Record<string, unknown> = {}) {
  const { token } = mondayConfig()
  if (!token) throw createError({ statusCode: 503, statusMessage: 'Monday.com API token is not configured' })

  const response = await $fetch<MondayGraphqlResponse<T>>('https://api.monday.com/v2', {
    method: 'POST',
    headers: { Authorization: token, 'Content-Type': 'application/json' },
    body: { query, variables }
  })

  if (response.errors?.length) {
    throw createError({ statusCode: 502, statusMessage: response.errors.map(error => error.message || 'Monday GraphQL error').join('; ') })
  }
  return response.data as T
}

export function mondayIsConfigured() {
  const { token, boardId } = mondayConfig()
  return Boolean(token && boardId)
}

export async function healthCheckMonday() {
  const data = await mondayGraphql<{ me: { id: string; name: string; email?: string } }>(`query { me { id name email } }`)
  return data.me
}

export async function syncWorkOrder(workOrder: MondayWorkOrder) {
  const { boardId, groupId } = mondayConfig()
  if (!boardId) throw createError({ statusCode: 503, statusMessage: 'MONDAY_BOARD_ID is not configured' })

  const columnValues = {
    status: workOrder.status ? { label: workOrder.status } : undefined,
    priority: workOrder.priority ? { label: workOrder.priority } : undefined,
    text: [workOrder.sector, workOrder.station, workOrder.assignedTo].filter(Boolean).join(' · ') || undefined,
    date: workOrder.dueDate || undefined,
    long_text: workOrder.description || undefined
  }

  const query = `mutation CreateEamWorkOrder($boardId: ID!, $groupId: String, $itemName: String!, $columnValues: JSON) {
    create_item(board_id: $boardId, group_id: $groupId, item_name: $itemName, column_values: $columnValues) {
      id
      name
      url
    }
  }`

  const data = await mondayGraphql<{ create_item: { id: string; name: string; url: string } }>(query, {
    boardId,
    groupId: groupId || null,
    itemName: workOrder.title,
    columnValues: JSON.stringify(columnValues)
  })

  return data.create_item
}
