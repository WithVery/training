// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC721 {
    function safeTransferFrom(address from, address to, uint tokenId) external;
    function transferFrom(address, address, uint) external;
}

contract EnglishAuction {
    event Start();
    event Bid(address indexed sender, uint amount);
    event Withdraw(address indexed withdrawer, uint amount);
    event End(address indexed winner, uint amount);

    IERC721 public nft;
    uint public nftId;

    address payable public seller;
    uint public endsAt;
    bool public started;
    bool public ended;

    address public highestBidder;
    uint public highestBid;
    mapping(address => uint) public bids;

    constructor(address _nft, uint _tokenId, uint _initialPrice) {
        nft = IERC721(_nft);
        nftId = _tokenId;
        seller = payable(msg.sender);
        highestBid = _initialPrice;
    }

    function start() public {
        require(!started, "already started");
        require(msg.sender == seller, "not an owner");

        nft.transferFrom(msg.sender, address(this), nftId);
        started = true;
        endsAt = block.timestamp + 7 days;

        emit Start();
    }

    function bid() payable public {
        require(started, "not started");
        require(block.timestamp < endsAt, "ended");
        require(highestBid < msg.value, "value < bid");

        if(highestBidder != address(0)) {
            bids[highestBidder] += highestBid;
        }

        highestBidder = msg.sender;
        highestBid = msg.value;

        emit Bid(msg.sender, msg.value);
    }

    function withdraw() public {
        uint bal = bids[msg.sender];
        require(bal > 0, "didn't bid");

        bids[msg.sender] = 0;
        (bool ok, ) = payable(msg.sender).call{value:bal}("");

        require(ok, "withdraw failed");

        emit Withdraw(msg.sender, bal);
    }

    function end() public {
        require(started, "not started");
        require(endsAt < block.timestamp, "still active");
        require(!ended, "already ended");

        ended = true;
        if(highestBidder != address(0)) {
            nft.safeTransferFrom(address(this), highestBidder, nftId);
            (bool ok, ) = payable(seller).call{value:highestBid}("");
            require(ok, "failed to send top bid");
        }
        else {
            nft.safeTransferFrom(address(this), seller, nftId);
        }
        emit End(highestBidder, highestBid);
    }


}