import ballerina/http;

public type Asset readonly & record {
    string assetTag;
    string name;
    string faculty;
    string department;
    string status;
    string acquiredDate;
    map<string> components;
    map<Schedule> schedules;
    map<string> workOrders;
};

public type Schedule readonly & record {
    string description;
    string dueDate;
    string sceduleId;
};

public type components readonly & record {
    string description;
    string part;
    string componentId;
};




table<components> key(componentId) componentsDB = table [];
table<Schedule> key(sceduleId) sceduleDB = table [];




service /components on new http:Listener(7070) {

    resource function post addComponent(@http:Payload components newComponent) returns http:Response {
        if componentsDB.hasKey(newComponent.componentId) {
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

    resource function get listComponents() returns components[] {
        return componentsDB.toArray();
    }

    resource function delete removeComponent/[string componentId]() returns http:Response {
        if componentsDB.hasKey(componentId) {
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




    resource function post addSchedule(@http:Payload Schedule newSchedule) returns http:Response {
        if sceduleDB.hasKey(newSchedule.sceduleId) {
            http:Response resp = new();
            resp.statusCode = http:STATUS_CONFLICT;
            resp.setPayload({ message: "Schedule already exists." });
            return resp;
        }

        sceduleDB.add(newSchedule);

        http:Response resp = new();
        resp.statusCode = http:STATUS_CREATED;
        resp.setPayload({ message: "Schedule added successfully." });
        return resp;
    }

    resource function get listSchedules() returns Schedule[] {
        return sceduleDB.toArray();
    }

    resource function delete removeSchedule/[string sceduleId]() returns http:Response {
        if sceduleDB.hasKey(sceduleId)) {
            _ = sceduleDB.remove(sceduleId);

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
}
