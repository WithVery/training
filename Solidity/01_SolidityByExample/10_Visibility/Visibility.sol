// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract A {
    function privFunc() private {

    }

    function intFunc() internal pure virtual returns (string memory) {
        return "intFunc()";
    }

    function testIntFunc() public pure virtual returns (string memory) {
        return intFunc();
    }

}

contract B is A {
    // gives an error
    // function privFunc() private override {
    // }

    // works totally fine
    function testIntFunc() public pure override returns (string memory) {
       return intFunc();
    }    
}


