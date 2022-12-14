// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC721 {
    function transferFrom(address, address, uint) external;
}

contract DutchAuction {
    uint private constant DURATION = 7 days;
    IERC721 public immutable nft;
    uint public immutable nftId;

    address payable public immutable seller;
    uint public immutable startingPrice;
    uint public immutable startAt;
    uint public immutable expiresAt;
    uint public immutable discountRate;


    constructor(uint _startingPrice, uint _discountRate, address _nft, uint _tokenId) {
        seller = payable(msg.sender);
        startingPrice = _startingPrice;
        startAt = block.timestamp;
        expiresAt = startAt + DURATION;
        discountRate = _discountRate;

        require(_startingPrice >= _discountRate * DURATION, "starting price < min");


        nft = IERC721(_nft);
        nftId = _tokenId;

    }

    function getPrice() public view returns(uint) {
        //require(startAt <= block.timestamp, "");
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() payable public {
        require(block.timestamp < expiresAt, "expired");
        uint price = getPrice();

        require(price <= msg.value, "not enough money");
        nft.transferFrom(seller, msg.sender, nftId);

        uint refund = msg.value - price;
        if(refund > 0) {
            (bool ok, ) = payable(msg.sender).call{value:refund}("");
            require(ok, "failed to send a refund");
        }
        selfdestruct(seller);
    }

}