import ballerina/http;

public type Asset readonly & record 
{
    string assetTag;
    string name;
    string faculty;
    string department;
    string status;
    string acquiredDate;
    string[] componentIds;
    string[] scheduleId;
    string[] workOrdersId;
};

public type Component readonly & record 
{
    string componentId;
    string part;
    string description;
};

public type Schedule readonly & record 
{
    string scheduleId;
    string description;
    string dueDate;
};

public type WorkOrder readonly & record 
{
    string workOrdersId;
    string description;
    string status;
    string assignedTo;
    string priority;
    string createdDate;
    string dueDate;
    string[] taskIds; 
};

public type Task readonly & record 
{
    string tasksId;
    string description;
    string status;
    string assignedTo;
    string priority;
    string createdDate;
    string dueDate;
};

table<Asset> key(assetTag) assetDB = table [];
table<Component> key(componentId) componentsDB = table [];
table<Schedule> key(scheduleId) scheduleDB = table [];
table<WorkOrder> key(workOrdersId) WorkOrdersDB = table [];
table<Task> key(tasksId) TasksDB = table [];


service / on new http:Listener(7070) 
{
    //ADD ASSET
    resource function post Asset(@http:Payload Asset newAsset) returns http:Response
    {
        if assetDB.hasKey(newAsset.assetTag) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_CONFLICT;
            resp.setPayload({ message: "Asset already exists." });
            return resp;
        }
    
        assetDB.add(newAsset);

        http:Response resp = new();
        resp.statusCode = http:STATUS_CREATED;
        resp.setPayload({ message: "Success" });
        return resp;
    }

    //UPDATE ASSET
    resource function put Asset/[string assetTag](@http:Payload Asset updatedAsset) returns http:Response 
    {
        if !assetDB.hasKey(updatedAsset.assetTag) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_NOT_FOUND;
            resp.setPayload({ message: "Asset not found." });
            return resp;
        }

        _ = assetDB.remove(assetTag);
        assetDB.add(updatedAsset);

        http:Response resp = new();
        resp.statusCode = http:STATUS_OK;
        resp.setPayload({ message: "Asset updated successfully." });
        return resp;
    }

    //SEARCH ASSET
    resource function get Asset/[string assetTag]() returns Asset|error? 
    {
        Asset? asset = assetDB[assetTag];
        if asset is () 
        {
            return error("Asset not found.");
        }

        return asset;
    }

    //DELETE ASSET
    resource function delete Asset/[string assetTag]() returns http:Response 
    {
        if assetDB.hasKey(assetTag) 
        {
            _ = assetDB.remove(assetTag);
            
            http:Response resp = new();
            resp.statusCode = http:STATUS_OK;
            resp.setPayload({ message: "Asset removed successfully." });
            return resp;
        } 
        
        http:Response resp = new();
        resp.statusCode = http:STATUS_NOT_FOUND;
        resp.setPayload({ message: "Asset not found." });
        return resp;
    }

    //LIST ASSET
    resource function get Asset() returns Asset[] 
    {
        return assetDB.toArray();
    }

    //VIEW ASSETS BY FACULTY CODE HERE

    //CHECK FOR OVERDUE ITEMS CODE HERE

    //ADD COMPONENT
    resource function post Component(@http:Payload Component newComponent) returns http:Response 
    {
        if componentsDB.hasKey(newComponent.componentId) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_CONFLICT;
            resp.setPayload({ message: "Component already exists." });
            return resp;
        }

        componentsDB.add(newComponent);

        http:Response resp = new();
        resp.statusCode = http:STATUS_CREATED;
        resp.setPayload({ message: "Component added successfully." });
        return resp;
    }

    //DELETE COMPONENT
    resource function delete Component/[string componentId]() returns http:Response 
    {
        if componentsDB.hasKey(componentId)
        {
            _ = componentsDB.remove(componentId);

            http:Response resp = new();
            resp.statusCode = http:STATUS_OK;
            resp.setPayload({ message: "Component removed successfully." });
            return resp;
        }

        http:Response resp = new();
        resp.statusCode = http:STATUS_NOT_FOUND;
        resp.setPayload({ message: "Component not found." });
        return resp;
    }

    //LIST COMPONENT
    resource function get Component() returns Component[] 
    {
        return componentsDB.toArray();
    }

    //ADD SCHEDULE
    resource function post Schedule(@http:Payload Schedule newSchedule) returns http:Response 
    {
        if scheduleDB.hasKey(newSchedule.scheduleId) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_CONFLICT;
            resp.setPayload({ message: "Schedule already exists." });
            return resp;
        }

        scheduleDB.add(newSchedule);

        http:Response resp = new();
        resp.statusCode = http:STATUS_CREATED;
        resp.setPayload({ message: "Schedule added successfully." });
        return resp;
    }

    //DELETE SCHEDULE
    resource function delete Schedule/[string scheduleId]() returns http:Response 
    {
        if scheduleDB.hasKey(scheduleId)
        {
            _ = scheduleDB.remove(scheduleId);

            http:Response resp = new();
            resp.statusCode = http:STATUS_OK;
            resp.setPayload({ message: "Schedule removed successfully." });
            return resp;
        }

        http:Response resp = new();
        resp.statusCode = http:STATUS_NOT_FOUND;
        resp.setPayload({ message: "Schedule not found." });
        return resp;
    }

    //LIST SCHEDULE
        resource function get Schedule() returns Schedule[] 
    {
        return scheduleDB.toArray();
    }

    //ADD WORKORDER
    resource function post WorkOrder(@http:Payload WorkOrder newWorkOrder) returns http:Response
    {
        if WorkOrdersDB.hasKey(newWorkOrder.workOrdersId) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_CONFLICT;
            resp.setPayload({ message: "WorkOrder already exists." });
            return resp;
        }

        WorkOrdersDB.add(newWorkOrder);

        http:Response resp = new();
        resp.statusCode = http:STATUS_CREATED;
        resp.setPayload({ message: "Success" });
        return resp;
    }

    //UPDATE WORKORDER
    resource function put WorkOrder/[string workOrdersId](@http:Payload WorkOrder updatedWorkOrder) returns http:Response 
    {
        if !WorkOrdersDB.hasKey(updatedWorkOrder.workOrdersId) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_NOT_FOUND;
            resp.setPayload({ message: "WorkOrder not found." });
            return resp;
        }

        _ = WorkOrdersDB.remove(workOrdersId);
        WorkOrdersDB.add(updatedWorkOrder);

        http:Response resp = new();
        resp.statusCode = http:STATUS_OK;
        resp.setPayload({ message: "WorkOrder updated successfully." });
        return resp;
    }

    //DELETE WORKORDER
    resource function delete WorkOrder/[string workOrdersId]() returns http:Response 
    {
        if WorkOrdersDB.hasKey(workOrdersId) 
        {
            _ = WorkOrdersDB.remove(workOrdersId);

            http:Response resp = new();
            resp.statusCode = http:STATUS_OK;
            resp.setPayload({ message: "WorkOrder removed successfully." });
            return resp;
        } 
        
        http:Response resp = new();
        resp.statusCode = http:STATUS_NOT_FOUND;
        resp.setPayload({ message: "WorkOrder not found." });
        return resp;
    }

    //LIST WORKORDER
        resource function get WorkOrder() returns WorkOrder[] 
    {
       return WorkOrdersDB.toArray();
    }

   //ADD TASK
 resource function post Task(@http:Payload Task newTask) returns http:Response
    {
        if TasksDB.hasKey(newTask.tasksIds) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_CONFLICT;
            resp.setPayload({ message: "Task already exists." });
            return resp;
        }

        TasksDB.add(newTask);

        http:Response resp = new();
        resp.statusCode = http:STATUS_CREATED;
        resp.setPayload({ message: "Success" });
        return resp;
    }

    //UPDATE TASK
    resource function put Task/[string tasksId](@http:Payload Task updatedTask) returns http:Response 
    {
        if !TasksDB.hasKey(updatedTask.tasksIds) 
        {
            http:Response resp = new();
            resp.statusCode = http:STATUS_NOT_FOUND;
            resp.setPayload({ message: "Task not found." });
            return resp;
        }

        _ = TasksDB.remove(tasksId);
        TasksDB.add(updatedTask);

        http:Response resp = new();
        resp.statusCode = http:STATUS_OK;
        resp.setPayload({ message: "Task updated successfully." });
        return resp;
    }
    
    //DELETE TASK
resource function delete Task/[string tasksId]() returns http:Response 
    {
        if TasksDB.hasKey(tasksId) 
        {
            _ = TasksDB.remove(tasksId);

            http:Response resp = new();
            resp.statusCode = http:STATUS_OK;
            resp.setPayload({ message: "Task removed successfully." });
            return resp;
        } 
        
        http:Response resp = new();
        resp.statusCode = http:STATUS_NOT_FOUND;
        resp.setPayload({ message: "Task not found." });
        return resp;
    }

    //LIST TASK
        resource function get Task() returns Task[] 
    {
       return TasksDB.toArray();
    }
}
