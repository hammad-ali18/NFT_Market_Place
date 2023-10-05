pragma solidity >=0.8.4;
// Marketplace contract for buying and selling products 
// and customers can make custom offers for every product
import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
//This the Market place where the owner has the ownership of having the nft and the ownership is than transfered to the buyer
contract NFTMarketPlace{

using Counters for Counters.Counter;
Counters.Counter public nftId;

//struct will define each nft
ERC721 public erc721;
 struct NFTs{
    uint256 id;
    string name;
    address owner;
    uint256 price;
    address buyer;
    bool isSold;
    address[] offerors;
}

mapping(address=>uint256)public offers;
mapping(address=> uint256) public balance;
//making an array for the nft
NFTs[] public nfts;

address public owner;



event NFTAdded(uint256 indexed nftId,string indexed name, address indexed owner);

event OfferMade(uint256 indexed nftId,address indexed buyer,uint256 indexed price);
 
event OfferAccepted(uint256 indexed nftId, address indexed newOwner, uint256 indexed price);

event OfferRejected(uint256 indexed nftId, string indexed name);
             //marketplace name
// constructor(){
// owner = msg.sender;
// }

function addNFT(string memory _name, uint256 _price) external {
    require(_price>0,"Price should be greater than 0");
    nftId.increment(); // increment by 1
    uint256 currentNftId  = nftId.current();
 
nfts.push(NFTs(currentNftId,_name,msg.sender,_price,address(0),false,new address[](0)));


emit NFTAdded(currentNftId,_name, msg.sender);

}
//offer from the buyer
function makeOffer(uint256  _nftId,uint256  _price) external{
require(_nftId <= nfts.length,"The nft is not available to make an offer");


NFTs storage nft = nfts[_nftId];

require(!nft.isSold,'The NFT is already sold');
require(_price >0 ,"The Nft is eligible to sale");

nft.offerors.push(msg.sender); //offerors address[] is updated
require(msg.sender != nft.owner,'the owner of nft cannot make an offer');
offers[msg.sender] = _price; // the offer price is mapped
emit OfferMade(_nftId,msg.sender, _price);
}

//Owner will accept the offer
function acceptOffer(uint256 _nftId,address  _buyer) external{
require(_nftId <= nfts.length,'The nft is not available to be accepted');
require(msg.sender != _buyer,"Buyer cannot make the offer");
NFTs storage nft = nfts[_nftId];

require(msg.sender == nft.owner,"This is the real owner of the nft" );
require(!nft.isSold,"The NFT is already sold");
require(offers[_buyer] <= nft.price,"The buyer has no enough amount to buy Nft");


nft.isSold =true;
nft.owner = _buyer;


emit OfferAccepted(nft.id, _buyer,offers[_buyer]);

}
//Owner will reject offer
function rejectOffer(uint256 _nftId, address  _buyer) external{
    require(_nftId <= nfts.length,"The nft is not available to be rejected");

    require(msg.sender != _buyer,"Buyer cannot accept the offer");

  NFTs storage nft = nfts[_nftId];
  require(msg.sender == nft.owner,"This is not the actual owner of nft");
  require(!nft.isSold,"The NFT is already sold");

  nft.buyer = address(0);

  delete nft.offerors[nft.offerors.length -1];

emit OfferRejected(nft.id, nft.name);
}

function getOffer() external view returns(uint256){
    return offers[msg.sender];
}

function getTotalNFTs() external view returns(uint256){
    return nfts.length;
}
function getNFT()external view returns(NFTs[] memory){
    return nfts;
}
function getOwner(uint256 _nftId) external view returns(NFTs[] memory){
    // NFTs[] storage nft = nfts[_nftId];
    return nfts;
}



}