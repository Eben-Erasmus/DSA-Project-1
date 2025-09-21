import ballerina/io;
import ballerina/time;

CarRentalClient ep = check new ("http://localhost:9090");

public function main() returns error? 
{
    io:println("Car Rental System Test");
    
    Car car1 = 
    {
        plate: "Rainer123",
        make: "Toyota",
        model: "Crolla",
        year: 2023,
        daily_price: 50.0,
        mileage: 15000,
        status: AVAILABLE,
        color: "White",
        description: "Family car"
    };
    
    Car car2 = 
    {
        plate: "Ethan456",
        make: "Honda",
        model: "Civic",
        year: 2022,
        daily_price: 45.0,
        mileage: 20000,
        status: AVAILABLE,
        color: "Blue",
        description: "Compact car"
    };

    AddCarResponse response1 = check ep->AddCar({car: car1});
    io:println("Add car result: ", response1);
    
    AddCarResponse response2 = check ep->AddCar({car: car2});
    io:println("Add car result: ", response2);

    car1.daily_price = 55.0;
    UpdateCarResponse updateResult = check ep->UpdateCar({plate: "ABC123", updated: car1});
    io:println("Update result: ", updateResult);

    SearchCarResponse searchResult = check ep->SearchCar({plate: "ABC123"});
    io:println("Search result: ", searchResult);

    stream<Car, error?> cars = check ep->ListAvailableCars({filter_text: "", year: 0});
    io:println("Available cars:");
    check cars.forEach(function(Car car) 
    {
        io:println(car.plate + " - " + car.make + " " + car.model);
    });

    time:Utc startDate = time:utcNow();
    time:Utc endDate = [startDate[0] + 604800, startDate[1]];
    
    CartItem item = 
    {
        plate: "ABC123",
        start_date: startDate,
        end_date: endDate
    };

    AddToCartResponse cartResult = check ep->AddToCart({user_id: "user1", item: item});
    io:println("Cart result: ", cartResult);

    PlaceReservationResponse reservationResult = check ep->PlaceReservation({user_id: "user1"});
    io:println("Reservation result: ", reservationResult);

    User user1 = {id: "admin1", name: "John", email: "john@test.com", role: ADMIN};
    User user2 = {id: "customer1", name: "Jane", email: "jane@test.com", role: CUSTOMER};
    
    CreateUsersStreamingClient userClient = check ep->CreateUsers();
    check userClient->sendUser(user1);
    check userClient->sendUser(user2);
    check userClient->complete();
    
    CreateUsersResponse? userResult = check userClient->receiveCreateUsersResponse();
    io:println("User creation result: ", userResult);

    RemoveCarResponse removeResult = check ep->RemoveCar({plate: "XYZ789"});
    io:println("Remove result: ", removeResult);
    
    io:println("Test completed");
}
