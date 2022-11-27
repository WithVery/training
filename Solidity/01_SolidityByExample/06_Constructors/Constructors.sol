// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract X {
    string public nameX;
    constructor(string memory _name) {
        nameX = _name;
    }
}

contract Y {
    uint public immutable valY;
    constructor(uint _value) {
        valY = _value;
    }
}

contract A is X("string"), Y(100) {

}

contract B is X, Y {
    constructor(string memory _string, uint _val) X(_string) Y(_val) {

    }
}
