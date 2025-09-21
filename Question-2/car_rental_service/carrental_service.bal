import ballerina/grpc;
import ballerina/time;

final map<Cart> carts = {};
final map<Reservation[]> reservations = {};
final map<Car> inventory = {};
final map<User> users = {};

type Cart record 
{
    string userId;
    CartItem[] items;
};

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: CRS_DESC}
service "CarRental" on ep 
{
    remote function AddCar(AddCarRequest value) returns AddCarResponse|error 
    {
        if inventory.hasKey(value.car.plate) 
        {
            return {success: false, plate: value.car.plate, message: "Car already exists"};
        }
        
        Car carToAdd = value.car;
        if carToAdd.status == CAR_STATUS_UNSPECIFIED 
        {
            carToAdd.status = AVAILABLE;
        }
        
        inventory[value.car.plate] = carToAdd;
        return {success: true, plate: value.car.plate, message: "Car added successfully"};
    }

    remote function UpdateCar(UpdateCarRequest value) returns UpdateCarResponse|error 
    {
        if !inventory.hasKey(value.plate) 
        {
            return {success: false, message: "Car not found", car: value.updated};
        }
        inventory[value.plate] = value.updated;
        return {success: true, message: "Car updated", car: value.updated};
    }

    remote function RemoveCar(RemoveCarRequest req) returns RemoveCarResponse|error 
    {
        if !inventory.hasKey(req.plate) 
        {
            return {success: false, message: "Car not found", cars: []};
        }
        _ = inventory.remove(req.plate);
        Car[] carsList = [];
        foreach Car car in inventory 
        {
            carsList.push(car);
        }
        return {success: true, message: "Car removed", cars: carsList};
    }

    remote function SearchCar(SearchCarRequest value) returns SearchCarResponse|error 
    {
        if inventory.hasKey(value.plate) 
        {
            Car car = inventory.get(value.plate);
            return {found: true, car: car, message: "Car found"};
        }
        return {found: false, car: {}, message: "Car not found"};
    }

    remote function AddToCart(AddToCartRequest req) returns AddToCartResponse|error 
    {
        if req.item.start_date[0] >= req.item.end_date[0] 
        {
            return {success: false, message: "Invalid rental period", item: {}};
        }

        if !inventory.hasKey(req.item.plate) 
        {
            return {success: false, message: "Car not found", item: {}};
        }

        CartItem item = 
        {
            plate: req.item.plate,
            start_date: req.item.start_date,
            end_date: req.item.end_date
        };

        if carts.hasKey(req.user_id) 
        {
            Cart currentCart = carts.get(req.user_id);
            currentCart.items.push(item);
        }
        else 
        {
            carts[req.user_id] = {userId: req.user_id, items: [item]};
        }

        return {success: true, message: "Item added to cart", item: item};
    }

    remote function PlaceReservation(PlaceReservationRequest req) returns PlaceReservationResponse|error 
    {
        if !carts.hasKey(req.user_id) 
        {
            return {success: false, message: "Cart is empty", reservation: {}};
        }

        Cart cart = carts.get(req.user_id);
        ReservationItem[] reservationItems = [];

        foreach CartItem item in cart.items 
        {
            if item.start_date[0] >= item.end_date[0] 
            {
                continue;
            }

            boolean isConflict = false;
            if reservations.hasKey(req.user_id) 
            {
                Reservation[] userReservations = reservations.get(req.user_id);
                foreach Reservation existingReservation in userReservations 
                {
                    foreach ReservationItem existingItem in existingReservation.items 
                    {
                        if item.plate == existingItem.plate && 
                           ((item.start_date[0] >= existingItem.start_date[0] && item.start_date[0] <= existingItem.end_date[0]) ||
                            (item.end_date[0] >= existingItem.start_date[0] && item.end_date[0] <= existingItem.end_date[0]) ||
                            (item.start_date[0] <= existingItem.start_date[0] && item.end_date[0] >= existingItem.end_date[0])) 
                        {
                            isConflict = true;
                        }
                    }
                }
            }

            if isConflict || !inventory.hasKey(item.plate) 
            {
                continue;
            }

            Car car = inventory.get(item.plate);
            int days = <int>((item.end_date[0] - item.start_date[0]) / (24 * 60 * 60));
            float price = car.daily_price * days;

            ReservationItem resItem = 
            {
                plate: item.plate,
                start_date: item.start_date,
                end_date: item.end_date,
                daily_price: car.daily_price,
                total_price: price
            };
            reservationItems.push(resItem);
        }

        if reservationItems.length() > 0 
        {
            float totalPrice = 0.0;
            foreach ReservationItem item in reservationItems 
            {
                totalPrice = totalPrice + item.total_price;
            }

            Reservation res = 
            {
                reservation_id: string `RES-${req.user_id}-${time:utcNow()[0]}`,
                user_id: req.user_id,
                created_at: time:utcNow(),
                items: reservationItems,
                total_price: totalPrice,
                status: "CONFIRMED"
            };

            if reservations.hasKey(req.user_id) 
            {
                Reservation[] existingReservations = reservations.get(req.user_id);
                reservations[req.user_id] = [...existingReservations, res];
            }
            else 
            {
                reservations[req.user_id] = [res];
            }

            _ = carts.remove(req.user_id);
            return {success: true, message: "Reservation placed", reservation: res};
        }

        return {success: false, message: "No valid reservations", reservation: {}};
    }

    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns CreateUsersResponse|error 
    {
        User[] createdUsers = [];

        while true 
        {
            var user = clientStream.next();

            if user is record {| User value; |} 
            {
                users[user.value.id] = user.value;
                createdUsers.push(user.value);
            }
            else if user is grpc:Error 
            {
                return error("Error receiving user: " + user.message());
            }
            else 
            {
                break;
            }
        }

        return 
        {
            success: createdUsers.length() > 0,
            message: "Users created successfully",
            created_users: createdUsers
        };
    }

    remote function ListAvailableCars(ListAvailableCarsRequest req) returns stream<Car, error?>|error 
    {
        Car[] filteredCars = [];

        foreach Car car in inventory 
        {
            if car.status == AVAILABLE &&
               (req.filter_text == "" || car.make.includes(req.filter_text)) &&
               (req.year == 0 || car.year == req.year) 
            {
                filteredCars.push(car);
            }
        }

        return filteredCars.toStream();
    }

    remote function ListReservations(ListReservationsRequest req) returns stream<Reservation, error?>|error 
    {
        if reservations.hasKey(req.user_id) 
        {
            Reservation[] userReservations = reservations.get(req.user_id);
            return userReservations.toStream();
        }
        Reservation[] emptyArray = [];
        return emptyArray.toStream();
    }
}
