// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract Foo {
    address public owner;

    constructor(address _owner) payable {
        require(_owner!= address(0), "invalid address");
        assert(_owner != 0x0000000000000000000000000000000000000001);
        owner = _owner;
    }

    function aFunc(uint _x) public pure returns(string memory) {
        require(_x != 0, "require failed");
        return "aFunc was called";
    }
}

contract Bar {
    event Log(string message);
    event LogBytes(bytes data);

    Foo public foo;
    constructor() {
        foo = new Foo(msg.sender);
    }

    function tryCatchAsExternalCall(uint _i) public {
        try foo.aFunc(_i) returns (string memory result) {
            emit Log(result);
        }
        catch {
            emit Log("external call failed");
        }
    }

    function tryCatchOnCunstruction(address _owner) public {
        try new Foo(_owner) returns(Foo foo1) {
            emit Log("foo1 created");
        }
        catch Error(string memory message) {
            emit Log(message);
        }
        catch (bytes memory reason) {
            emit LogBytes(reason);
        }
    }
}
