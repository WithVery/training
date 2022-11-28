// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Reciever {

    event Log(string message);

    receive() external payable {
        emit Log("Recieved with recieve");
    }
    fallback() external payable{
        emit Log("Recieved with fallback");
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

contract Transferrer {

    constructor() payable {}

    function sendViaTransfer(address payable _to) public payable {
        _to.transfer(msg.value);
    }

    function sendViaSend(address payable _to) public payable {
        bool success = _to.send(msg.value);
        require(success, "Send failed");
    }

    function sendViaCall(address payable _to) public payable {
        (bool success, ) = _to.call{value:msg.value}("");
        require(success, "Call failed");
    }
}