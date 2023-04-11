pragma solidity ^0.8.0;

contract SupplyChain {

    // Define variables, enums and structs
    enum ProductState { Registered, Received, Verified}
    enum Actor { Supplier, Distributor, Retailer, Consumer, Auditor }
    struct Product {
        address supplier;
        Actor actor;
        string name;
        string description;
        uint quantity;
        uint latitude;
        uint longitude;
        uint expirationDate;
        uint256 productState;
    }
    mapping (string => Product) products;

    // Define functions
    function register(string memory productId, string memory name, string memory description, uint quantity, uint latitude, uint longitude, uint expirationDate) public {
        // check if product is already registered
        require(products[productId].productState == uint(ProductState.Registered), "Product is already registered");

        // register product
        Product memory product = Product(msg.sender, Actor.Supplier, name, description, quantity, latitude, longitude, expirationDate, uint(ProductState.Registered));
        products[productId] = product;
    }

    function verify(string memory productId, uint256 productState) public {
        // check if product is already registered
        require(products[productId].productState == uint(ProductState.Registered), "Product is not yet registered");

        // check if user actor is valid
        require(products[productId].actor == Actor.Distributor || products[productId].actor == Actor.Retailer || products[productId].actor == Actor.Auditor, "User actor is not valid");

        // update product state
        products[productId].productState = productState;
    }

    function receive(string memory productId) public {
        // check if product is already verified
        require(products[productId].productState == uint(ProductState.Verified), "Product must be verified before being received");

        // update product state
        products[productId].productState = uint(ProductState.Received);

        // set actor to distributor
        products[productId].actor = Actor.Distributor;
    }

    function check(address user, string memory productId, uint256 productState) public view returns (bool) {
        // check if user actor is valid
        require(products[productId].actor == Actor.Distributor || products[productId].actor == Actor.Retailer || products[productId].actor == Actor.Consumer || products[productId].actor == Actor.Auditor, "Actor is not valid");

        // check if user is corresponding with actor
        require(products[productId].supplier == user || products[productId].actor == Actor.Auditor || (products[productId].actor != Actor.Supplier && msg.sender == user), "User must be corresponding with actor");

        // check if product state is valid
        if (productState == 0) {
            return products[productId].productState == uint(ProductState.Received) || products[productId].productState == uint(ProductState.Verified);
        }
        else if (productState == 1) {
            return products[productId].productState == uint(ProductState.Verified);
        }
        else if (productState == 2) {
            return products[productId].productState == uint(ProductState.Received);
        }
        else {
            return false;
        }
    }
}