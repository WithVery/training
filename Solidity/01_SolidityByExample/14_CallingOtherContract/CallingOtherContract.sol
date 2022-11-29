// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract A {
    uint public num;
    address public whoset;

    function setNum(uint _val) public returns(uint) {
        whoset = msg.sender;
        num = _val;
        return num;
    }
}

contract B {
    uint public num;

    function setA(address _address, uint _num) public {
        num = A(_address).setNum(_num);
    }

    function setA1(A  _A, uint _num) public {
        num = _A.setNum(_num);
    }

}
