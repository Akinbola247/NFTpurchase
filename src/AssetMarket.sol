// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC721/IERC721.sol";
import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import "lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol";
contract Market {
     using SafeCast for int256;
struct ItemDetails{
    uint tokenID;
    address seller;
    bool status;
}

address owner;
IERC721 nftAddress;
IERC20 DaiContract;
AggregatorV3Interface internal ETHusdpriceFeed;
AggregatorV3Interface internal DAIusdpriceFeed;
mapping(uint => ItemDetails) itemInfo;


constructor(address _nftAddress){
    nftAddress = IERC721(_nftAddress);
    DaiContract= IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    owner = msg.sender;

    DAIusdpriceFeed = AggregatorV3Interface(0xAed0c38402a5d19df6E4c03F4E2DceD6e29c1ee9);
    ETHusdpriceFeed = AggregatorV3Interface(0x5f4eC3Df9cbd43714FE2740f5E3616155c5b8419);

}
function listItem(uint _tokenitemID) public {
    ItemDetails storage _a = itemInfo[_tokenitemID];
    _a.tokenID = _tokenitemID;
    _a.seller = msg.sender;
    _a.status = true;
}
function purchaseItem(uint _tokenID) public payable{
    uint balance = DaiContract.balanceOf(msg.sender);
    require(itemInfo[_tokenID].status == true, "not for sale");
    require(balance >= 3.5 ether);
    uint ethusdCurrentPrice = getETHUSDPrice();
    uint usdtusdCurrentPrice = getDAIUSDPrice();
    uint _amountINUSdt = (3.5 ether * ethusdCurrentPrice)/usdtusdCurrentPrice;
    DaiContract.transferFrom(msg.sender, address(this), _amountINUSdt);
    nftAddress.transferFrom(owner, msg.sender, _tokenID);
 }


function getDAIUSDPrice() public view returns (uint) {
        ( , int price, , , ) = DAIusdpriceFeed.latestRoundData();
        return price.toUint256();
    }
function getETHUSDPrice() public view returns (uint) {
        ( , int price, , , ) = ETHusdpriceFeed.latestRoundData();
        return price.toUint256();
    }

}


