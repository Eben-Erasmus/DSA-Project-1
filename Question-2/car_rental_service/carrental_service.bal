import ballerina/grpc;

final map<Cart> carts = {};
final map<Reservation[]> reservations = {};

type Cart record {
    string userId;
    CartItem[] items;
};

type Car record {
    string plate;
    string make;
    string model;
    decimal dailyRate;
};

listener grpc:Listener ep = new (9090);

@grpc:Descriptor {value: CRS_DESC}
service "CarRental" on ep {

    remote function AddCar(AddCarRequest value) returns AddCarResponse|error {
    }

    remote function UpdateCar(UpdateCarRequest value) returns UpdateCarResponse|error {
    }

    remote function RemoveCar(RemoveCarRequest value) returns RemoveCarResponse|error {
    }

    remote function SearchCar(SearchCarRequest value) returns SearchCarResponse|error {
    }

    remote function AddToCart(AddToCartRequest req) returns AddToCartResponse|error {
        // Validate dates
        time:Civil start = check time:parseCivil(req.startDate, "yyyy-MM-dd");
        time:Civil end = check time:parseCivil(req.endDate, "yyyy-MM-dd");
        if time:utcFromCivil(start).unixTime >= time:utcFromCivil(end).unixTime {
            return {message: "Invalid rental period: start date must be before end date", item: ()};
        }

        // Check inventory
        if !inventory.hasKey(req.plate) {
            return {message: string `Car with plate ${req.plate} not found in inventory.`, item: ()};
        }

        CartItem item = {
            plate: req.plate,
            startDate: req.startDate,
            endDate: req.endDate
        };

        if carts.hasKey(req.userId) {
            Cart currentCart = carts[req.userId];
            currentCart.items.push(item);
        } else {
            carts[req.userId] = {userId: req.userId, items: [item]};
        }
        return {message: "Item added to cart", item: item};
    }

    remote function PlaceReservation(PlaceReservationRequest req) returns PlaceReservationResponse|error {
        if !carts.hasKey(req.userId) {
            return {message: "Cart is empty."};
        }

        Cart cart = carts[req.userId];
        Reservation[] confirmed = [];

        foreach CartItem item in cart.items {
            time:Civil start = check time:parseCivil(item.startDate, "yyyy-MM-dd");
            time:Civil end = check time:parseCivil(item.endDate, "yyyy-MM-dd");

            if time:utcFromCivil(start).unixTime >= time:utcFromCivil(end).unixTime {
                continue;
            }

            boolean conflict = false;
            if reservations.hasKey(req.userId) {
                foreach Reservation existingReservation in reservations[req.userId] {
                    foreach ReservationItem existingItem in existingReservation.items {
                        int existingStartUnixTime = existingItem.start_date[0];
                        int existingEndUnixTime = existingItem.end_date[0];
                        if item.plate == existingItem.plate && (
                            (time:utcFromCivil(start).unixTime >= existingStartUnixTime && time:utcFromCivil(start).unixTime <= existingEndUnixTime) ||
                            (time:utcFromCivil(end).unixTime >= existingStartUnixTime && time:utcFromCivil(end).unixTime <= existingEndUnixTime) ||
                            (time:utcFromCivil(start).unixTime <= existingStartUnixTime && time:utcFromCivil(end).unixTime >= existingEndUnixTime)
                        ) {
                            conflict = true;
                        }
                    }
                }
            }

            if conflict || !inventory.hasKey(item.plate) {
                continue;
            }

            Car car = inventory[item.plate];
            int days = <int>((time:utcFromCivil(end).unixTime - time:utcFromCivil(start).unixTime) / (24 * 60 * 60));
            float price = <float>car.dailyRate * days;

            // This creates the ReservationItem first.
            ReservationItem resItem = {
                plate: item.plate,
                start_date: check time:utcFromCivil(start),
                end_date: check time:utcFromCivil(end),
                daily_price: <float>car.dailyRate,
                total_price: price
            };

            // Then, this creates a complete Reservation record that wraps the item.
            Reservation res = {
                reservation_id: string `RES-${req.userId}-${time:utcNow().unixTime}`,
                user_id: req.userId,
                created_at: time:utcNow(),
                items: [resItem],
                total_price: price,
                status: "CONFIRMED"
            };
            confirmed.push(res);
        }

        if confirmed.length() > 0 {
            reservations[req.userId] = reservations.hasKey(req.userId) ? [...reservations[req.userId], ...confirmed] : confirmed;
        }

        carts.remove(req.userId);

        return {
            message: confirmed.length() > 0 ? "Reservation(s) placed." : "No valid reservations.",
            confirmed: confirmed
        };
    }

    remote function CreateUsers(stream<User, grpc:Error?> clientStream) returns CreateUsersResponse|error {
    }

    remote function ListAvailableCars(ListAvailableCarsRequest value) returns stream<Car, error?>|error {
    }

    remote function ListReservations(ListReservationsRequest value) returns stream<Reservation, error?>|error {
    }
}
