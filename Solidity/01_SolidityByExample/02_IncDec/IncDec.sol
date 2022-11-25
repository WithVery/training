// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
    uint counter;

    function getCounter() external view returns(uint) {
        return counter;
    }

    function inc() public {
        counter += 1;
    }

    function dec() public {
        counter -= 1;
    }

    function incStep(uint _step) public {
        counter += _step;
    }

    function decStep(uint _step) public {
        counter -= _step;
    }

}