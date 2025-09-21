import ballerina/grpc;

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: CRS_DESC}
service "CarRental" on ep {

    remote function AddCar(AddCarRequest value) returns AddCarResponse|error {
    }

    remote function UpdateCar(UpdateCarRequest value) returns UpdateCarResponse|error {


    }

   remote function RemoveCar(RemoveCarRequest value) returns RemoveCarResponse|error {

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
    }

    remote function SearchCar(SearchCarRequest value) returns SearchCarResponse|error {
    }

    remote function AddToCart(AddToCartRequest value) returns AddToCartResponse|error {
    }

    remote function PlaceReservation(PlaceReservationRequest value) returns PlaceReservationResponse|error {
    }

    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns CreateUsersResponse|error {
    }

    remote function ListAvailableCars(ListAvailableCarsRequest value) returns stream<Car, error?>|error {
    }

    remote function ListReservations(ListReservationsRequest value) returns stream<Reservation, error?>|error {
    }
}
