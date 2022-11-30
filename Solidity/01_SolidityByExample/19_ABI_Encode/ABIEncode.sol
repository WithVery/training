// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC20 {
    function transfer(address, uint) external;
}

contract Token {
    function transfer(address, uint) external {}
}

contract AbiEncode {
    function test(address _contract, bytes calldata _data) external {
        (bool ok, ) = _contract.call(_data);
        require(ok, "call failed");
    }

    function encodeWithSignature(address _to, uint _amount) external pure returns(bytes memory) {
        return abi.encodeWithSignature("transfer(address,uint256)", _to, _amount);
    }

    function encodeWithSelector(address _to, uint _amount) external pure returns(bytes memory) {
        return abi.encodeWithSelector(IERC20.transfer.selector, _to, _amount);
    }

    function encodeCall(address _to, uint _amount) external pure returns (bytes memory) {
        return abi.encodeCall(IERC20.transfer, (_to, _amount));
    }

}
