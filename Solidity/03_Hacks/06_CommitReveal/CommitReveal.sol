// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/Strings.sol";


contract SecuredFindThisHash {
    struct Commit {
        bytes32 solutionHash;
        uint commitTime;
        bool revealed;
    }

    // The hash that is needed to be solved
    bytes32 public hash = 0x564ccaf7594d66b1eaaea24fe01f0585bf52ee70852af4eac0cc4b04711cd0e2;

    address public winner;
    uint public reward;
    bool public ended;

    mapping(address => Commit) commits;
    modifier gameIsActive {
        require(!ended, "It's gone");
        _;
    }

    constructor() payable {
        reward = msg.value;
    }

    function commitSolution(bytes32 _solutionHash) public gameIsActive {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime == 0, "Already committed");
        commit.solutionHash = _solutionHash;
        commit.commitTime = block.timestamp;
        commit.revealed = false;
    }

    function getMySolution() public view gameIsActive returns(bytes32, uint, bool) {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime != 0, "Not committed yet");
        return (commit.solutionHash, commit.commitTime, commit.revealed);
    }

    function revealSolution(string memory _solution, string memory _secret) public gameIsActive {
        Commit storage commit = commits[msg.sender];
        require(commit.commitTime != 0, "Not committes");
        require(!commit.revealed, "Already revealed");

        bytes32 myHash = keccak256(abi.encodePacked(Strings.toHexString(uint(uint160(msg.sender))), _solution, _secret));
        require(commit.solutionHash == myHash, "Hashes mismatch");

        require(keccak256(abi.encodePacked(_solution)) == hash, "Invalid solution");

        winner = msg.sender;
        ended = true;

        (bool ok, ) = msg.sender.call{value:reward}("");
        require(ok, "failed to send reward");
    }

}