// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract CounterV1 {
    uint public count;
    function inc() external {
        count += 1;
    }
}

contract CounterV2 {
    uint public count;
    function inc() external {
        count += 1;
    }
    function dec() external {
        count -= 1;
    }
}

contract BuggyProxy {
    uint public count;
    address public implementation;
    address public admin;

    constructor() {
        admin = msg.sender;
    }

    function _delegate() private {
        (bool ok, ) = implementation.delegatecall(msg.data);
        require(ok, "delegatecall failed");
    }

    fallback() external payable {
        _delegate();
    }

    receive() external payable {
        _delegate();
    }

    function upgradeTo(address _new) external {
        require(msg.sender == admin, "not an admin");
        implementation = _new;
    }
}