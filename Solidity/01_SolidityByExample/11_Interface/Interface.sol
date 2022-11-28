// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Counter {
    uint public count;
    function inc() public {
        count++;
    }

}

interface ICounter {
    function count() external view returns(uint);
    function inc() external;
}

contract Main  {
    ICounter counter;
    address addressCounter;

    constructor(address _address) {
        addressCounter = _address;
        counter = ICounter(_address);
    }

    function countA() public view returns(uint) {
        return counter.count();
    }

    function countB() public view returns(uint) {
        return ICounter(addressCounter).count();
    }

    function incA() public {
        counter.inc();
    }

    function incB() public {
        ICounter(addressCounter).inc();
    }


}


