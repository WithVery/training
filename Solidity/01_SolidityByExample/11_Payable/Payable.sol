// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Payable {
    address payable public owner;

    constructor() payable {
        owner = payable(msg.sender);
    }

    function deposit() public payable {

    }

    function nonPayable() public {}

    function withdraw() public {
        (bool success, )  = owner.call{value: address(this).balance}("");
        require(success, "Withdraw failed");
    }

    function transfer(address payable _to, uint amount) public {
        require(amount <= address(this).balance, "too much, man");
        (bool success, ) = _to.call{value:amount}("");
        require(success, "Transfer failed");
    }
}