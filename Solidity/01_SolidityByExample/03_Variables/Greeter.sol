// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Greeter {
    string public greeting = "Hi!";
    uint public lastTimeGreetedMoment;
    address public lastTimeGreetedAddress;

    function greetMe() external returns(string memory) {
        lastTimeGreetedMoment = block.timestamp;
        lastTimeGreetedAddress = msg.sender;
        return greeting;
    }

}