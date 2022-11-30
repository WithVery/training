// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./Foo.sol";

import {Unauthorized, add as sum, Point} from "./Foo.sol";

contract Import {
    Foo public foo = new Foo();

    function checkFooName() public view returns(string memory) {
        return foo.name();
    }

    function checkAlias(uint _x, uint _y) public pure returns(uint) {
        return sum(_x, _y);
    }

}
