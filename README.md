# DSA-Project-1

Question 1 in "Question-1" folder.

🔹 Assets
Add Asset

POST /Asset

Create a new asset.

Payload Example:

{
  "assetTag": "A001",
  "name": "Printer",
  "faculty": "Engineering",
  "department": "IT",
  "status": "Active",
  "acquiredDate": "2025-01-01",
  "componentIds": [],
  "scheduleId": [],
  "workOrdersId": []
}


cURL:

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

Update Asset

PUT /Asset/{assetTag}

Payload Example:

{
  "assetTag": "A001",
  "name": "Printer v2",
  "faculty": "Engineering",
  "department": "IT",
  "status": "Inactive",
  "acquiredDate": "2025-01-01",
  "componentIds": ["C001"],
  "scheduleId": [],
  "workOrdersId": []
}


cURL:

curl -X PUT http://localhost:7070/Asset/A001 \
  -H "Content-Type: application/json" \
  -d '{
    "assetTag": "A001",
    "name": "Printer v2",
    "faculty": "Engineering",
    "department": "IT",
    "status": "Inactive",
    "acquiredDate": "2025-01-01",
    "componentIds": ["C001"],
    "scheduleId": [],
    "workOrdersId": []
  }'

Get Asset by Tag

GET /Asset/{assetTag}

cURL:

curl http://localhost:7070/Asset/A001

Delete Asset

DELETE /Asset/{assetTag}

cURL:

curl -X DELETE http://localhost:7070/Asset/A001

List All Assets

GET /Asset

cURL:

curl http://localhost:7070/Asset

🔹 Components
Add Component

POST /Component

Payload Example:

{
  "componentId": "C001",
  "part": "Toner",
  "description": "Black toner cartridge"
}


cURL:

curl -X POST http://localhost:7070/Component \
  -H "Content-Type: application/json" \
  -d '{
    "componentId": "C001",
    "part": "Toner",
    "description": "Black toner cartridge"
  }'

Delete Component

DELETE /Component/{componentId}

cURL:

curl -X DELETE http://localhost:7070/Component/C001

List Components

GET /Component

cURL:

curl http://localhost:7070/Component

🔹 Schedules
Add Schedule

POST /Schedule

Payload Example:

{
  "scheduleId": "S001",
  "description": "Printer maintenance",
  "dueDate": "2025-02-01"
}


cURL:

curl -X POST http://localhost:7070/Schedule \
  -H "Content-Type: application/json" \
  -d '{
    "scheduleId": "S001",
    "description": "Printer maintenance",
    "dueDate": "2025-02-01"
  }'

Delete Schedule

DELETE /Schedule/{scheduleId}

cURL:

curl -X DELETE http://localhost:7070/Schedule/S001

List Schedules

GET /Schedule

cURL:

curl http://localhost:7070/Schedule

🔹 WorkOrders
Add WorkOrder

POST /WorkOrder

Payload Example:

{
  "workOrdersId": "W001",
  "description": "Fix printer",
  "status": "Open",
  "assignedTo": "Technician1",
  "priority": "High",
  "createdDate": "2025-01-15",
  "dueDate": "2025-01-20",
  "taskIds": []
}


cURL:

curl -X POST http://localhost:7070/WorkOrder \
  -H "Content-Type: application/json" \
  -d '{
    "workOrdersId": "W001",
    "description": "Fix printer",
    "status": "Open",
    "assignedTo": "Technician1",
    "priority": "High",
    "createdDate": "2025-01-15",
    "dueDate": "2025-01-20",
    "taskIds": []
  }'

Update WorkOrder

PUT /WorkOrder/{workOrdersId}

cURL:

curl -X PUT http://localhost:7070/WorkOrder/W001 \
  -H "Content-Type: application/json" \
  -d '{
    "workOrdersId": "W001",
    "description": "Fix printer (urgent)",
    "status": "In Progress",
    "assignedTo": "Technician2",
    "priority": "High",
    "createdDate": "2025-01-15",
    "dueDate": "2025-01-19",
    "taskIds": ["T001"]
  }'

Delete WorkOrder

DELETE /WorkOrder/{workOrdersId}

cURL:

curl -X DELETE http://localhost:7070/WorkOrder/W001

List WorkOrders

GET /WorkOrder

cURL:

curl http://localhost:7070/WorkOrder