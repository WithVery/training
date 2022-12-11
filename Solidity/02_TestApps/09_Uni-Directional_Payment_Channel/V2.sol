// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v4.5/contracts/utils/cryptography/ECDSA.sol";

contract StringVerifier {
    event Hash(bytes32 indexed hash);

    event SenderAddress(address indexed adds);
    using ECDSA for bytes32;
    function verifyMessage(string memory message, bytes memory signature) public returns(bool) {

        //hash the plain text message
        bytes32 messagehash =  keccak256(bytes(message));
        emit Hash(messagehash);
        //hash the prefix and messagehash together   
        bytes32 messagehash2 = keccak256(abi.encodePacked("x19Ethereum Signed Messsage:\\n32", messagehash));
        //extract the signing contract address
        address signeraddress = ECDSA.recover( messagehash2, signature);
        emit SenderAddress(signeraddress);
        if (msg.sender==signeraddress) {
            //The message is authentic
            return true;
        } else {
            //msg.sender didnt sign this message.
            return false;
        }
    }

function recover1(uint256 amount, uint8 v, bytes32 r, bytes32 s) pure external returns(address signer){

        bytes32 hash =  keccak256(abi.encodePacked(amount));
        bytes32 signedHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32",hash));
        signer = ecrecover(signedHash, v, r, s);

}    
}    