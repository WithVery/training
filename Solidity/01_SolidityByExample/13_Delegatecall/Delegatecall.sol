// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract A {

    uint public num;
    address public sender;

    function setParams(uint _val) public {
        sender = msg.sender;
        num = _val;
    }
}

contract B {
    uint public num;
    address public sender;

    function setFromB(uint _num) public {
        sender = address(this);
        num = _num;
    }

    function setFromA(address _addressA, uint _num) public {
        (bool success, bytes memory response) = _addressA.delegatecall(abi.encodeWithSignature("setParams(uint256)", _num));
    }

}
