// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract Midifier {

    uint public x = 100;
    bool isActive;

    modifier NoReentracy() {
        require(!isActive, "No reentracy, please");
        isActive = true;
        _;
        isActive = false;
    }

    function tryToReenter(uint _i) public NoReentracy {
        x -= _i;
        if(_i > 1) {
            tryToReenter(_i - 1);
        }
    }

}