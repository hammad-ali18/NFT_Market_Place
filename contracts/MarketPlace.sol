pragma solidity >=0.8.4;
// Marketplace contract for buying and selling products 
// and customers can make custom offers for every product
import "hardhat/console.sol";

contract MarketPlace{
    //struct for product details(ownership too)

    struct Product{
//struct can act as a Class for entering details
   
    address seller;
    string name;
    uint256 price;
    address currentBuyer;
    bool isSold;
    address[] offerors;
    }


mapping(address=>uint256) public balance;

// offers will be from the seller
mapping(address=> uint256) public offers;

    //making an state variable for Product
    Product[] public products;

//offer amount will be mounted on the address

 
// event for product added by the seller
event ProductAdded(uint256 indexed productId,address indexed seller);

//event for making an offer by the buyer
event OfferMade(uint256 indexed productId , address indexed seller, uint256 amount);

//event for  offer acceptance
event OfferAccepted(uint256 indexed productId, address indexed buyer , uint256 amount );

//event for offer rejectence

event OfferRejected(uint256 indexed productId, address indexed buyer);

//product will be added by the seller
function addProduct(string memory _name, uint256 _price) external{
require( _price >0, 'The price of the product is quite low');

//pushing on to the products array
products.push(Product(msg.sender,_name,_price, address(0),false, new address[](0))); //new address[](0) is the empty address

emit ProductAdded(products.length - 1,msg.sender);
}

//make an Offer from the buyer
function makeOffer(uint256 _productId, uint256 _amount) external{
    require(_productId <= products.length,"Product does not exists");
    // in the array of products[] the _productId is index
    //loading an instance
    Product storage product = products[_productId];
                     //false
  
    require(!product.isSold,"The Product is already sold"); //if not exists so the product is Sold 

    require(msg.sender != product.seller,"The buyer is the seller and cannot buy his own product");
    require(_amount > 0,'offer must be greater than 0');

 //when the buyer is verified

    // add the offerors array
   product.offerors.push(msg.sender);
    require(msg.sender != product.seller,"Offer is not from the valid buyer");
  offers[msg.sender] = _amount;
  emit OfferMade(_productId, msg.sender, _amount);
}


//validate the offer from the buyer
function acceptOffer(uint256 _productId, address _buyer) external{

require(_productId <= products.length, "Product donot exists");
Product storage product = products[_productId];

require(!product.isSold,"The Product is already sold");
require(msg.sender == product.seller,"Only seller can accept the offer");

//check the balance of the buyer is eligible to purchase
require(offers[_buyer] <= product.price,"The buyer is not eligble to buy the product");

product.isSold = true;
product.currentBuyer = _buyer;

emit OfferAccepted(_productId, _buyer,offers[_buyer]);

}

function rejectOffer(uint256 _productId, address _buyer) external{
    require(_productId < products.length,"Product donot exists");

    Product storage product = products[_productId];

    require(product.isSold,"The Product is already sold");
    require(msg.sender == product.seller,"Only seller an reject Offer");
    
    require(balance[_buyer] < product.price,"The buyer is eligible to buy");
    product.isSold =false;
    product.currentBuyer = address(0);

    delete product.offerors[product.offerors.length -1];

    emit OfferRejected(_productId, _buyer);
}   

function getTotalProducts() external view returns(uint256){
    return products.length;
}
function getProducts()external view returns(Product[] memory){
    return products;
}



}