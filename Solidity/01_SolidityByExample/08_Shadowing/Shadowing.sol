// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract A {
    string public name = "A";
}

contract B is A {
    constructor() {
        name  = "B";
    }
}

contract C is B {
    constructor() {
        name = "C";
    }
}

// name = "C"
contract D is B, C {

}