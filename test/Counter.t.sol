// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;
import "lib/forge-std/src/Test.sol";
import "../src/AssetMarket.sol";
import "../src/KZN.sol";
import "../lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract AssetMarket is Test {
    Market public market;
    NFT public nft;
    IERC20 public daiContract;
function setUp() public {
    vm.startPrank(0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb);
    uint mainnet = vm.createFork("https://eth-mainnet.g.alchemy.com/v2/xypdsCZYrlk6oNi93UmpUzKE9kmxHy2n", 16890887);
    vm.selectFork(mainnet);
    nft = new NFT();
    market = new Market(address(nft));
    daiContract = IERC20(0x6B175474E89094C44Da98b954EedeAC495271d0F);
    vm.stopPrank();
}

function testMint() public {
    vm.startPrank(0xBB9F947cB5b21292DE59EFB0b1e158e90859dddb);
    nft.safeMint("https://ipfs.filebase.io/ipfs/QmYqEcCNJiP7pP2nzSsvyv7Ji1tNpv6omWMJ4Nph22dmfn", address(market));
    vm.stopPrank();
}
function testPurchaseItem() public {
    testMint(); 
    vm.startPrank(0x748dE14197922c4Ae258c7939C7739f3ff1db573);
    daiContract.approve(address(market), 35000000000000000000000000000000000000000000000000000);
    market.purchaseItem(0);
    uint balance = daiContract.balanceOf(address(market));
}

}
