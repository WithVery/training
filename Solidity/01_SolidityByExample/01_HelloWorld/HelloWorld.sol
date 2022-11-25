// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract HelloWorld {
    string public greet = "Hello World!";

    function greetMe() external view returns(string memory) {
        return greet;
    }
}
