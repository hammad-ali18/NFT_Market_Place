const { expect } = require("chai");
const { poll } = require("ethers/lib/utils");
const { waffle,ethers } = require("hardhat");
const { userInfo } = require("os");
const provider = waffle.provider;
const web3 = require("web3");



describe('Greeter', () =>{

    const [owner, accountOne] = provider.getWallets();
let market

    before( async () =>{
        Greeter = await ethers.getContractFactory("Greeter");
        greeter = await Greeter.deploy("Hello World");

  const MarketPlace = await ethers.getContractFactory("MarketPlace");
  const marketplace = await MarketPlace.deploy();
  market = marketplace;
  console.log("Market Place address: ",marketplace.address)
})


it('Testing the Market Place from sellers side', async () =>{
    let productId =1;

    let addProduct = await market.connect(owner).addProduct("Pepsi 250ml",web3.utils.toWei("2"));
    let getProducts = await market.getProducts();
    
console.log("The Product which is available is: ", getProducts[0][1])

let getlength = await market.getTotalProducts();
console.log(getlength.toString());


                                                    //product id is 0
 let makeOffer = await market.connect(accountOne).makeOffer(productId,web3.utils.toWei("1"));
// console.log(makeOffer)

let acceptOffer = await market.connect(owner).acceptOffer(productId,accountOne.address);
console.log(acceptOffer);
       
// let rejectoffer = await market.connect(owner).rejectOffer(0,accountOne.address);
// console.log(rejectoffer)
console.log("Return True if isSold: ",getProducts[0].isSold);

    })

   
})