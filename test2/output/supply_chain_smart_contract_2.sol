pragma solidity ^0.8.0; import "@openzeppelin/contracts/math/SafeMath.sol"; contract SupplyChain { using SafeMath for uint256; // Define variables, enums and structs enum ProductState { Registered, Received, Verified } enum Actor { Supplier, Distributor, Retailer, Consumer, Auditor } struct Product { address supplier; Actor actor; string name; string description; uint quantity; uint latitude; uint longitude; uint expirationDate; uint256 productState; } mapping(string => Product) products; // Define functions /** * @dev Register a new product * @param productId The unique ID of the product * @param name The name of the product * @param description The description of the product * @param quantity The quantity of the product * @param latitude The latitude of the product * @param longitude The longitude of the product * @param expirationDate The expiration date of the product */ function register( string memory productId, string memory name, string memory description, uint quantity, uint latitude, uint longitude, uint expirationDate ) public { require( products[productId].productState != uint(ProductState.Registered), "Product is already registered" ); Product memory product = Product( msg.sender, Actor.Supplier, name, description, quantity, latitude, longitude, expirationDate, uint(ProductState.Registered) ); products[productId] = product; } /** * @dev Verify a product * @param productId The unique ID of the product * @param productState The new state of the product */ function verify(string memory productId, uint256 productState) public { require( products[productId].productState == uint(ProductState.Registered), "Product is not yet registered" ); require( products[productId].actor == Actor.Distributor || products[productId].actor == Actor.Retailer || products[productId].actor == Actor.Auditor, "User actor is not valid" ); products[productId].productState = productState; } /** * @dev Receive a product * @param productId The unique ID of the product */ function receive(string memory productId) public { require( products[productId].productState == uint(ProductState.Verified), "Product must be verified before being received" ); products[productId].productState = uint(ProductState.Received); products[productId].actor = Actor.Distributor; } /** * @dev Check the state of a product * @param user The address of the user calling the function * @param productId The unique ID of the product * @param productState The state to check * @return A bool representing whether the state is valid */ function check( address user, string memory productId, uint256 productState ) public view returns (bool) { require( products[productId].actor == Actor.Distributor || products[productId].actor == Actor.Retailer || products[productId].actor == Actor.Consumer || products[productId].actor == Actor.Auditor, "Actor is not valid" ); require( products[productId].supplier == user || products[productId].actor == Actor.Auditor || (products[productId].actor != Actor.Supplier && msg.sender == user), "User must be corresponding with actor" ); if (productState == 0) { return products[productId].productState == uint(ProductState.Received) || products[productId].productState == uint(ProductState.Verified); } else if (productState == 1) { return products[productId].productState == uint(ProductState.Verified); } else if (productState == 2) { return products[productId].productState == uint(ProductState.Received); } else { return false; } } /** * @dev Retrieve product information by productId * @param productId The unique ID of the product * @return Product information */ function getProductInfo(string memory productId) public view returns (Product memory) { return products[productId]; } /** * @dev Update product information * @param productId The unique ID of the product * @param name The updated name of the product * @param description The updated description of the product * @param quantity The updated quantity of the product * @param latitude The updated latitude of the product * @param longitude The updated longitude of the product * @param expirationDate The updated expiration date of the product */ function updateProductInfo( string memory productId, string memory name, string memory description, uint quantity, uint latitude, uint longitude, uint expirationDate ) public { require( products[productId].supplier == msg.sender, "Only the supplier can update the product information" ); products[productId].name = name; products[productId].description = description; products[productId].quantity = quantity; products[productId].latitude = latitude; products[productId].longitude = longitude; products[productId].expirationDate = expirationDate; } /** * @dev Delete a product from the mapping * @param productId The unique ID of the product */ function deleteProduct(string memory productId) public { require( products[productId].supplier == msg.sender, "Only the supplier can delete the product" ); delete products[productId]; } } 