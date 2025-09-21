import ballerina/grpc;
import ballerina/protobuf;
import ballerina/time;

public const string CRS_DESC = "0A096372732E70726F746F12036372731A1F676F6F676C652F70726F746F6275662F74696D657374616D702E70726F746F22450A0F4F7065726174696F6E526573756C7412180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676522630A0455736572120E0A0269641801200128095202696412120A046E616D6518022001280952046E616D6512140A05656D61696C1803200128095205656D61696C12210A04726F6C6518042001280E320D2E6372732E55736572526F6C655204726F6C6522790A134372656174655573657273526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D657373616765122E0A0D637265617465645F757365727318032003280B32092E6372732E55736572520C63726561746564557365727322F4010A0343617212140A05706C6174651801200128095205706C61746512120A046D616B6518022001280952046D616B6512140A056D6F64656C18032001280952056D6F64656C12120A0479656172180420012805520479656172121F0A0B6461696C795F7072696365180520012801520A6461696C79507269636512180A076D696C6561676518062001280352076D696C6561676512260A0673746174757318072001280E320E2E6372732E436172537461747573520673746174757312140A05636F6C6F721808200128095205636F6C6F7212200A0B6465736372697074696F6E180920012809520B6465736372697074696F6E222B0A0D41646443617252657175657374121A0A0363617218012001280B32082E6372732E4361725203636172225A0A0E416464436172526573706F6E736512180A077375636365737318012001280852077375636365737312140A05706C6174651802200128095205706C61746512180A076D65737361676518032001280952076D657373616765224C0A105570646174654361725265717565737412140A05706C6174651801200128095205706C61746512220A077570646174656418022001280B32082E6372732E43617252077570646174656422630A11557064617465436172526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D657373616765121A0A0363617218032001280B32082E6372732E436172520363617222280A1052656D6F76654361725265717565737412140A05706C6174651801200128095205706C61746522650A1152656D6F7665436172526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D657373616765121C0A046361727318032003280B32082E6372732E436172520463617273224F0A184C697374417661696C61626C654361727352657175657374121F0A0B66696C7465725F74657874180120012809520A66696C7465725465787412120A047965617218022001280552047965617222280A105365617263684361725265717565737412140A05706C6174651801200128095205706C617465225F0A11536561726368436172526573706F6E736512140A05666F756E641801200128085205666F756E64121A0A0363617218022001280B32082E6372732E436172520363617212180A076D65737361676518032001280952076D6573736167652292010A08436172744974656D12140A05706C6174651801200128095205706C61746512390A0A73746172745F6461746518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520973746172744461746512350A08656E645F6461746518032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705207656E6444617465224E0A10416464546F436172745265717565737412170A07757365725F6964180120012809520675736572496412210A046974656D18022001280B320D2E6372732E436172744974656D52046974656D226A0A11416464546F43617274526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676512210A046974656D18032001280B320D2E6372732E436172744974656D52046974656D22DB010A0F5265736572766174696F6E4974656D12140A05706C6174651801200128095205706C61746512390A0A73746172745F6461746518022001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D70520973746172744461746512350A08656E645F6461746518032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705207656E6444617465121F0A0B6461696C795F7072696365180420012801520A6461696C795072696365121F0A0B746F74616C5F7072696365180520012801520A746F74616C507269636522ED010A0B5265736572766174696F6E12250A0E7265736572766174696F6E5F6964180120012809520D7265736572766174696F6E496412170A07757365725F6964180220012809520675736572496412390A0A637265617465645F617418032001280B321A2E676F6F676C652E70726F746F6275662E54696D657374616D705209637265617465644174122A0A056974656D7318042003280B32142E6372732E5265736572766174696F6E4974656D52056974656D73121F0A0B746F74616C5F7072696365180520012801520A746F74616C507269636512160A06737461747573180620012809520673746174757322320A17506C6163655265736572766174696F6E5265717565737412170A07757365725F696418012001280952067573657249642282010A18506C6163655265736572766174696F6E526573706F6E736512180A077375636365737318012001280852077375636365737312180A076D65737361676518022001280952076D65737361676512320A0B7265736572766174696F6E18032001280B32102E6372732E5265736572766174696F6E520B7265736572766174696F6E22320A174C6973745265736572766174696F6E735265717565737412170A07757365725F696418012001280952067573657249642A640A09436172537461747573121A0A164341525F5354415455535F554E5350454349464945441000120D0A09415641494C41424C451001120F0A0B554E415641494C41424C451002120F0A0B4D41494E54454E414E43451003120A0A0652454E54454410042A3E0A0855736572526F6C6512190A15555345525F524F4C455F554E5350454349464945441000120C0A08435553544F4D4552100112090A0541444D494E100232BB040A0943617252656E74616C12310A0641646443617212122E6372732E416464436172526571756573741A132E6372732E416464436172526573706F6E736512340A0B437265617465557365727312092E6372732E557365721A182E6372732E4372656174655573657273526573706F6E73652801123A0A0955706461746543617212152E6372732E557064617465436172526571756573741A162E6372732E557064617465436172526573706F6E7365123A0A0952656D6F766543617212152E6372732E52656D6F7665436172526571756573741A162E6372732E52656D6F7665436172526573706F6E7365123E0A114C697374417661696C61626C6543617273121D2E6372732E4C697374417661696C61626C6543617273526571756573741A082E6372732E4361723001123A0A0953656172636843617212152E6372732E536561726368436172526571756573741A162E6372732E536561726368436172526573706F6E7365123A0A09416464546F4361727412152E6372732E416464546F43617274526571756573741A162E6372732E416464546F43617274526573706F6E7365124F0A10506C6163655265736572766174696F6E121C2E6372732E506C6163655265736572766174696F6E526571756573741A1D2E6372732E506C6163655265736572766174696F6E526573706F6E736512440A104C6973745265736572766174696F6E73121C2E6372732E4C6973745265736572766174696F6E73526571756573741A102E6372732E5265736572766174696F6E3001620670726F746F33";

public isolated client class CarRentalClient {
    *grpc:AbstractClientEndpoint;

    private final grpc:Client grpcClient;

    public isolated function init(string url, *grpc:ClientConfiguration config) returns grpc:Error? {
        self.grpcClient = check new (url, config);
        check self.grpcClient.initStub(self, CRS_DESC);
    }

    isolated remote function AddCar(AddCarRequest|ContextAddCarRequest req) returns AddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddCarResponse>result;
    }

    isolated remote function AddCarContext(AddCarRequest|ContextAddCarRequest req) returns ContextAddCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddCarRequest message;
        if req is ContextAddCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/AddCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddCarResponse>result, headers: respHeaders};
    }

    isolated remote function UpdateCar(UpdateCarRequest|ContextUpdateCarRequest req) returns UpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <UpdateCarResponse>result;
    }

    isolated remote function UpdateCarContext(UpdateCarRequest|ContextUpdateCarRequest req) returns ContextUpdateCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        UpdateCarRequest message;
        if req is ContextUpdateCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/UpdateCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <UpdateCarResponse>result, headers: respHeaders};
    }

    isolated remote function RemoveCar(RemoveCarRequest|ContextRemoveCarRequest req) returns RemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <RemoveCarResponse>result;
    }

    isolated remote function RemoveCarContext(RemoveCarRequest|ContextRemoveCarRequest req) returns ContextRemoveCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        RemoveCarRequest message;
        if req is ContextRemoveCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/RemoveCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <RemoveCarResponse>result, headers: respHeaders};
    }

    isolated remote function SearchCar(SearchCarRequest|ContextSearchCarRequest req) returns SearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <SearchCarResponse>result;
    }

    isolated remote function SearchCarContext(SearchCarRequest|ContextSearchCarRequest req) returns ContextSearchCarResponse|grpc:Error {
        map<string|string[]> headers = {};
        SearchCarRequest message;
        if req is ContextSearchCarRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/SearchCar", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <SearchCarResponse>result, headers: respHeaders};
    }

    isolated remote function AddToCart(AddToCartRequest|ContextAddToCartRequest req) returns AddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <AddToCartResponse>result;
    }

    isolated remote function AddToCartContext(AddToCartRequest|ContextAddToCartRequest req) returns ContextAddToCartResponse|grpc:Error {
        map<string|string[]> headers = {};
        AddToCartRequest message;
        if req is ContextAddToCartRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/AddToCart", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <AddToCartResponse>result, headers: respHeaders};
    }

    isolated remote function PlaceReservation(PlaceReservationRequest|ContextPlaceReservationRequest req) returns PlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, _] = payload;
        return <PlaceReservationResponse>result;
    }

    isolated remote function PlaceReservationContext(PlaceReservationRequest|ContextPlaceReservationRequest req) returns ContextPlaceReservationResponse|grpc:Error {
        map<string|string[]> headers = {};
        PlaceReservationRequest message;
        if req is ContextPlaceReservationRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeSimpleRPC("crs.CarRental/PlaceReservation", message, headers);
        [anydata, map<string|string[]>] [result, respHeaders] = payload;
        return {content: <PlaceReservationResponse>result, headers: respHeaders};
    }

    isolated remote function CreateUsers() returns CreateUsersStreamingClient|grpc:Error {
        grpc:StreamingClient sClient = check self.grpcClient->executeClientStreaming("crs.CarRental/CreateUsers");
        return new CreateUsersStreamingClient(sClient);
    }

    isolated remote function ListAvailableCars(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns stream<Car, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("crs.CarRental/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        CarStream outputStream = new CarStream(result);
        return new stream<Car, grpc:Error?>(outputStream);
    }

    isolated remote function ListAvailableCarsContext(ListAvailableCarsRequest|ContextListAvailableCarsRequest req) returns ContextCarStream|grpc:Error {
        map<string|string[]> headers = {};
        ListAvailableCarsRequest message;
        if req is ContextListAvailableCarsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("crs.CarRental/ListAvailableCars", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        CarStream outputStream = new CarStream(result);
        return {content: new stream<Car, grpc:Error?>(outputStream), headers: respHeaders};
    }

    isolated remote function ListReservations(ListReservationsRequest|ContextListReservationsRequest req) returns stream<Reservation, grpc:Error?>|grpc:Error {
        map<string|string[]> headers = {};
        ListReservationsRequest message;
        if req is ContextListReservationsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("crs.CarRental/ListReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, _] = payload;
        ReservationStream outputStream = new ReservationStream(result);
        return new stream<Reservation, grpc:Error?>(outputStream);
    }

    isolated remote function ListReservationsContext(ListReservationsRequest|ContextListReservationsRequest req) returns ContextReservationStream|grpc:Error {
        map<string|string[]> headers = {};
        ListReservationsRequest message;
        if req is ContextListReservationsRequest {
            message = req.content;
            headers = req.headers;
        } else {
            message = req;
        }
        var payload = check self.grpcClient->executeServerStreaming("crs.CarRental/ListReservations", message, headers);
        [stream<anydata, grpc:Error?>, map<string|string[]>] [result, respHeaders] = payload;
        ReservationStream outputStream = new ReservationStream(result);
        return {content: new stream<Reservation, grpc:Error?>(outputStream), headers: respHeaders};
    }
}

public isolated client class CreateUsersStreamingClient {
    private final grpc:StreamingClient sClient;

    isolated function init(grpc:StreamingClient sClient) {
        self.sClient = sClient;
    }

    isolated remote function sendUser(User message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function sendContextUser(ContextUser message) returns grpc:Error? {
        return self.sClient->send(message);
    }

    isolated remote function receiveCreateUsersResponse() returns CreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, _] = response;
            return <CreateUsersResponse>payload;
        }
    }

    isolated remote function receiveContextCreateUsersResponse() returns ContextCreateUsersResponse|grpc:Error? {
        var response = check self.sClient->receive();
        if response is () {
            return response;
        } else {
            [anydata, map<string|string[]>] [payload, headers] = response;
            return {content: <CreateUsersResponse>payload, headers: headers};
        }
    }

    isolated remote function sendError(grpc:Error response) returns grpc:Error? {
        return self.sClient->sendError(response);
    }

    isolated remote function complete() returns grpc:Error? {
        return self.sClient->complete();
    }
}

public class CarStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Car value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Car value;|} nextRecord = {value: <Car>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public class ReservationStream {
    private stream<anydata, grpc:Error?> anydataStream;

    public isolated function init(stream<anydata, grpc:Error?> anydataStream) {
        self.anydataStream = anydataStream;
    }

    public isolated function next() returns record {|Reservation value;|}|grpc:Error? {
        var streamValue = self.anydataStream.next();
        if streamValue is () {
            return streamValue;
        } else if streamValue is grpc:Error {
            return streamValue;
        } else {
            record {|Reservation value;|} nextRecord = {value: <Reservation>streamValue.value};
            return nextRecord;
        }
    }

    public isolated function close() returns grpc:Error? {
        return self.anydataStream.close();
    }
}

public type ContextUserStream record {|
    stream<User, error?> content;
    map<string|string[]> headers;
|};

public type ContextReservationStream record {|
    stream<Reservation, error?> content;
    map<string|string[]> headers;
|};

public type ContextCarStream record {|
    stream<Car, error?> content;
    map<string|string[]> headers;
|};

public type ContextListReservationsRequest record {|
    ListReservationsRequest content;
    map<string|string[]> headers;
|};

public type ContextUser record {|
    User content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationResponse record {|
    PlaceReservationResponse content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarRequest record {|
    RemoveCarRequest content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarRequest record {|
    UpdateCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarResponse record {|
    AddCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartResponse record {|
    AddToCartResponse content;
    map<string|string[]> headers;
|};

public type ContextUpdateCarResponse record {|
    UpdateCarResponse content;
    map<string|string[]> headers;
|};

public type ContextAddToCartRequest record {|
    AddToCartRequest content;
    map<string|string[]> headers;
|};

public type ContextListAvailableCarsRequest record {|
    ListAvailableCarsRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarRequest record {|
    SearchCarRequest content;
    map<string|string[]> headers;
|};

public type ContextAddCarRequest record {|
    AddCarRequest content;
    map<string|string[]> headers;
|};

public type ContextRemoveCarResponse record {|
    RemoveCarResponse content;
    map<string|string[]> headers;
|};

public type ContextReservation record {|
    Reservation content;
    map<string|string[]> headers;
|};

public type ContextCar record {|
    Car content;
    map<string|string[]> headers;
|};

public type ContextPlaceReservationRequest record {|
    PlaceReservationRequest content;
    map<string|string[]> headers;
|};

public type ContextSearchCarResponse record {|
    SearchCarResponse content;
    map<string|string[]> headers;
|};

public type ContextCreateUsersResponse record {|
    CreateUsersResponse content;
    map<string|string[]> headers;
|};

@protobuf:Descriptor {value: CRS_DESC}
public type ListReservationsRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type User record {|
    string id = "";
    string name = "";
    string email = "";
    UserRole role = USER_ROLE_UNSPECIFIED;
|};

@protobuf:Descriptor {value: CRS_DESC}
public type PlaceReservationResponse record {|
    boolean success = false;
    string message = "";
    Reservation reservation = {};
|};

@protobuf:Descriptor {value: CRS_DESC}
public type RemoveCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type UpdateCarRequest record {|
    string plate = "";
    Car updated = {};
|};

@protobuf:Descriptor {value: CRS_DESC}
public type AddCarResponse record {|
    boolean success = false;
    string plate = "";
    string message = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type AddToCartResponse record {|
    boolean success = false;
    string message = "";
    CartItem item = {};
|};

@protobuf:Descriptor {value: CRS_DESC}
public type UpdateCarResponse record {|
    boolean success = false;
    string message = "";
    Car car = {};
|};

@protobuf:Descriptor {value: CRS_DESC}
public type OperationResult record {|
    boolean success = false;
    string message = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type CartItem record {|
    string plate = "";
    time:Utc start_date = [0, 0.0d];
    time:Utc end_date = [0, 0.0d];
|};

@protobuf:Descriptor {value: CRS_DESC}
public type AddToCartRequest record {|
    string user_id = "";
    CartItem item = {};
|};

@protobuf:Descriptor {value: CRS_DESC}
public type ListAvailableCarsRequest record {|
    string filter_text = "";
    int year = 0;
|};

@protobuf:Descriptor {value: CRS_DESC}
public type SearchCarRequest record {|
    string plate = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type AddCarRequest record {|
    Car car = {};
|};

@protobuf:Descriptor {value: CRS_DESC}
public type RemoveCarResponse record {|
    boolean success = false;
    string message = "";
    Car[] cars = [];
|};

@protobuf:Descriptor {value: CRS_DESC}
public type Reservation record {|
    string reservation_id = "";
    string user_id = "";
    time:Utc created_at = [0, 0.0d];
    ReservationItem[] items = [];
    float total_price = 0.0;
    string status = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type ReservationItem record {|
    string plate = "";
    time:Utc start_date = [0, 0.0d];
    time:Utc end_date = [0, 0.0d];
    float daily_price = 0.0;
    float total_price = 0.0;
|};

@protobuf:Descriptor {value: CRS_DESC}
public type Car record {|
    string plate = "";
    string make = "";
    string model = "";
    int year = 0;
    float daily_price = 0.0;
    int mileage = 0;
    CarStatus status = CAR_STATUS_UNSPECIFIED;
    string color = "";
    string description = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type PlaceReservationRequest record {|
    string user_id = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type SearchCarResponse record {|
    boolean found = false;
    Car car = {};
    string message = "";
|};

@protobuf:Descriptor {value: CRS_DESC}
public type CreateUsersResponse record {|
    boolean success = false;
    string message = "";
    User[] created_users = [];
|};

public enum CarStatus {
    CAR_STATUS_UNSPECIFIED, AVAILABLE, UNAVAILABLE, MAINTENANCE, RENTED
}

public enum UserRole {
    USER_ROLE_UNSPECIFIED, CUSTOMER, ADMIN
}
