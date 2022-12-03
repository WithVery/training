// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Wallet {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    receive() external payable {}
    fallback() external payable {}

    function getBalance() external view returns(uint) {
        return address(this).balance;
    }

    function withdraw(uint _amount) external {
        require(msg.sender == owner, "Not an owner");
        (bool ok, ) = payable(msg.sender).call{value:_amount}("");
        require(ok, "Transfer failed");
    }


}

