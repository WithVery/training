// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract HashFunction {

    bytes32 public magicWord = keccak256(abi.encodePacked("Solidity"));

    function hash(string memory _text, uint _num, address _addr) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_text,_num,_addr));
    }

    function collision(string memory _text1, string memory _text2) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(_text1, _text2));
    }

    function guessTheWord(string memory _word) public view returns(bool) {
        return keccak256(abi.encodePacked(_word)) == magicWord;
    }

}
