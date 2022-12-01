// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract AbiDecode {
    struct MyStruct {
        string name;
        uint[2] nums;
    }

    function encode(uint _x, address _addr, uint[] calldata _arr, MyStruct calldata _myStruct) external pure returns(bytes memory) {
        return abi.encode(_x, _addr, _arr, _myStruct);
    }

    function decode(bytes calldata _bytes) external pure returns(uint _x, address _addr, uint[] memory _arr, MyStruct memory  _myStruct) {
        (_x, _addr, _arr, _myStruct) = abi.decode(_bytes, (uint, address, uint[], MyStruct));
    }
}
