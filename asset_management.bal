import ballerina/http;
import ballerina/time;

// Asset record definition
public type Asset record {
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

public type Schedule record {
    string description;
    string dueDate; // format: YYYY-MM-DD
};

// In-memory database
default map<Asset> assetDB = {};

service /assets on new http:Listener(8080) {

    // Create Asset
    resource function post create(http:Caller caller, http:Request req) returns error? {
        Asset newAsset = check req.getJsonPayload().cloneWithType(Asset);
        if assetDB.hasKey(newAsset.assetTag) {
            check caller->respond({ message: "Asset already exists." }, status = 409);
            return;
        }
        assetDB[newAsset.assetTag] = newAsset;
        check caller->respond({ message: "Asset created successfully." });
    }

    // View All Assets
    resource function get list(http:Caller caller, http:Request req) returns error? {
        Asset[] allAssets = [];
        foreach var [_, asset] in assetDB.entries() {
            allAssets.push(asset);
        }
        check caller->respond(allAssets);
    }

    // Get Asset by Tag
    resource function get byId(http:Caller caller, http:Request req, string assetTag) returns error? {
        if assetDB.hasKey(assetTag) {
            check caller->respond(assetDB[assetTag]);
        } else {
            check caller->respond({ message: "Asset not found." }, status = 404);
        }
    }

    // Update Asset
    resource function put update(http:Caller caller, http:Request req, string assetTag) returns error? {
        if !assetDB.hasKey(assetTag) {
            check caller->respond({ message: "Asset not found." }, status = 404);
            return;
        }
        Asset updatedAsset = check req.getJsonPayload().cloneWithType(Asset);
        assetDB[assetTag] = updatedAsset;
        check caller->respond({ message: "Asset updated successfully." });
    }

    // Delete Asset
    resource function delete remove(http:Caller caller, http:Request req, string assetTag) returns error? {
        if assetDB.hasKey(assetTag) {
            assetDB.remove(assetTag);
            check caller->respond({ message: "Asset removed successfully." });
        } else {
            check caller->respond({ message: "Asset not found." }, status = 404);
        }
    }

}
