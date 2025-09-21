# DSA-Project-1

This project contains two main assignments implemented in Ballerina.

## Question 1: Asset Management System (REST API)

A simple REST API for managing university assets, components, schedules, work orders, and tasks.

### How to Run

```bash
cd Question-1
bal run service.bal
```

The server runs on `http://localhost:7070`

### Assets

**Add Asset**
```bash
curl -X POST http://localhost:7070/Asset \
  -H "Content-Type: application/json" \
  -d '{
    "assetTag": "A001",
    "name": "Printer",
    "faculty": "Engineering",
    "department": "IT",
    "status": "Active",
    "acquiredDate": "2025-01-01",
    "componentIds": [],
    "scheduleId": [],
    "workOrdersId": []
  }'
```

**Update Asset**
```bash
curl -X PUT http://localhost:7070/Asset/A001 \
  -H "Content-Type: application/json" \
  -d '{
    "assetTag": "A001",
    "name": "Updated Printer",
    "faculty": "Engineering",
    "department": "IT",
    "status": "Active",
    "acquiredDate": "2025-01-01",
    "componentIds": [],
    "scheduleId": [],
    "workOrdersId": []
  }'
```

**Get Asset**
```bash
curl http://localhost:7070/Asset/A001
```

**Delete Asset**
```bash
curl -X DELETE http://localhost:7070/Asset/A001
```

**List All Assets**
```bash
curl http://localhost:7070/Asset
```

**List Assets by Faculty**
```bash
curl http://localhost:7070/Asset/faculty/Engineering
```

**List Overdue Assets**
```bash
curl http://localhost:7070/Asset/overdue
```

### Components

**Add Component**
```bash
curl -X POST http://localhost:7070/Component \
  -H "Content-Type: application/json" \
  -d '{
    "componentId": "C001",
    "part": "Toner",
    "description": "Black toner cartridge"
  }'
```

**Delete Component**
```bash
curl -X DELETE http://localhost:7070/Component/C001
```

**List Components**
```bash
curl http://localhost:7070/Component
```

### Schedules

**Add Schedule**
```bash
curl -X POST http://localhost:7070/Schedule \
  -H "Content-Type: application/json" \
  -d '{
    "scheduleId": "S001",
    "description": "Printer maintenance",
    "dueDate": "2025-02-01"
  }'
```

**Delete Schedule**
```bash
curl -X DELETE http://localhost:7070/Schedule/S001
```

**List Schedules**
```bash
curl http://localhost:7070/Schedule
```

### Work Orders

**Add Work Order**
```bash
curl -X POST http://localhost:7070/WorkOrder \
  -H "Content-Type: application/json" \
  -d '{
    "workOrdersId": "W001",
    "description": "Fix printer",
    "status": "Open",
    "assignedTo": "Tech1",
    "priority": "High",
    "createdDate": "2025-01-15",
    "dueDate": "2025-01-20",
    "taskIds": []
  }'
```

**Update Work Order**
```bash
curl -X PUT http://localhost:7070/WorkOrder/W001 \
  -H "Content-Type: application/json" \
  -d '{
    "workOrdersId": "W001",
    "description": "Fix printer urgent",
    "status": "In Progress",
    "assignedTo": "Tech2",
    "priority": "High",
    "createdDate": "2025-01-15",
    "dueDate": "2025-01-19",
    "taskIds": ["T001"]
  }'
```

**Delete Work Order**
```bash
curl -X DELETE http://localhost:7070/WorkOrder/W001
```

**List Work Orders**
```bash
curl http://localhost:7070/WorkOrder
```

### Tasks

**Add Task**
```bash
curl -X POST http://localhost:7070/Task \
  -H "Content-Type: application/json" \
  -d '{
    "tasksId": "T001",
    "description": "Replace toner",
    "status": "Open",
    "assignedTo": "Tech1",
    "priority": "Medium",
    "createdDate": "2025-01-15",
    "dueDate": "2025-01-18"
  }'
```

**Update Task**
```bash
curl -X PUT http://localhost:7070/Task/T001 \
  -H "Content-Type: application/json" \
  -d '{
    "tasksId": "T001",
    "description": "Replace toner cartridge",
    "status": "Completed",
    "assignedTo": "Tech1",
    "priority": "Medium",
    "createdDate": "2025-01-15",
    "dueDate": "2025-01-18"
  }'
```

**Delete Task**
```bash
curl -X DELETE http://localhost:7070/Task/T001
```

**List Tasks**
```bash
curl http://localhost:7070/Task
```

## Question 2: Car Rental System (gRPC)

A gRPC-based car rental system with client-server architecture supporting admin and customer operations.

### How to Run

**Start the Server:**
```bash
cd Question-2/car_rental_service
bal run
```

Server runs on `localhost:9090`

**Run the Client (in another terminal):**
```bash
cd Question-2/car_rental_client
bal run
```