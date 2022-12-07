// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Storage {
    struct MyStruct {
        uint value;
    }

    // struct stored at slot 0
    MyStruct public s0 = MyStruct(123);
    // struct stored at slot 1
    MyStruct public s1 = MyStruct(456);
    // struct stored at slot 2
    MyStruct public s2 = MyStruct(789);

    function _get(uint i) internal pure returns(MyStruct storage s) {
        assembly {
            s.slot := i
        }
    }

    function get(uint i) external view returns(uint) {
        return _get(i).value;
    }

    function set(uint i, uint x)  external {
        _get(i).value = x;
    }

}
