// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;


contract Storages {

    struct AStruct {
        uint field1;
        uint field2;
    }

    mapping(uint => AStruct) myStructs;

    function f() public {
        _f(myStructs[0]);
        AStruct memory struct1 = AStruct(0, 1);
        myStructs[1] = struct1;
    }

    function _f(AStruct storage _struct) internal {

    }
}