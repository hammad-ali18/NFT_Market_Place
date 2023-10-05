const { waffle,ethers } = require("hardhat");
const provider = waffle.provider;
const web3 = require("web3");

describe("NFT: ", ()=>{
let market;
const[owner, accountOne] = provider.getWallets();
before(async()=>{
  
  const NFTMarketPlace = await ethers.getContractFactory("NFTMarketPlace")
  const nftmarketplace = await NFTMarketPlace.deploy();
   market = nftmarketplace;
   console.log(nftmarketplace.address);
   
  })
  it("Testing Nft functionality: ", async()=>{
    let addNft = await market.connect(owner).addNFT("MonkeyChamp",web3.utils.toWei("4"))
    console.log(addNft)
    let getNft = await market.getNFT();
    console.log("NFT name: ",getNft[0][1])
    let getTotalNft =await market.getTotalNFTs();
    console.log(getTotalNft.toString());
    let nftid = parseInt(getTotalNft) -1;
    let nftOwnerBeforeAccept = await market.getOwner(nftid);
    console.log("Nft Owner before Accept: ",nftOwnerBeforeAccept[0][2]);
    
    let makeOffer = await market.connect(accountOne).makeOffer(nftid,web3.utils.toWei("3"));
    let getOffer = await market.connect(accountOne).getOffer();

console.log("Offer from the Buyer: ",getOffer.toString());

let acceptOffer = await market.connect(owner).acceptOffer(nftid, accountOne.address);
let nftOwnerAfterAccept = await market.getOwner(nftid);

console.log("New Nft owner : ",nftOwnerAfterAccept[0][2]);
  })
})