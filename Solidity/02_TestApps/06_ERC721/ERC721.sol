// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC165 {
    function supportsInterface(bytes4 interfaceId) external view returns(bool);
}

interface IERC721 is IERC165 {
    function balanceOf(address owner) external view returns(uint balance);
    function ownerOf(uint tokenId) external view returns(address);
    function safeTransferFrom(address from, address to, uint tokenId) external;
    function safeTransferFrom(address from, address to, uint tokenId, bytes calldata data) external;
    function transferFrom(address from, address to, uint tokenId) external;
    function approve(address to, uint toeknId) external;
    function getApproved(uint tokenId) external view returns(address operator);
    function setApprovalForAll(address operator, bool _approved) external;
    function isApprovedForAll(address owner, address operator) external view returns(bool);
}

interface IERC721Receiver {
    function onERC721Received(address operator, address from, uint tokenId, bytes calldata data) external returns(bytes4);
}

contract ERC721 is IERC721 {
    event Transfer(address indexed from, address indexed to, uint indexed toeknId);
    event Approval(address indexed owner, address indexed operator, uint indexed toeknId);
    event ApprovalForAll(address indexed owner, address indexed operator, bool _approved);

    mapping(uint => address) internal _ownerOf;
    mapping(address => uint) internal _balanceOf;
    mapping(uint=>address) internal _approvals;
    mapping(address=>mapping(address=>bool)) public isApprovedForAll;

    function supportsInterface(bytes4 interfaceId) external pure returns(bool) {
        return interfaceId == type(IERC721).interfaceId || interfaceId == type(IERC165).interfaceId;
    }

    function ownerOf(uint id) external view returns(address owner) {
        owner = _ownerOf[id];
        require(owner != address(0), "toekn does not exists");
    }

    function balanceOf(address owner) external view returns(uint) {
        require(owner != address(0), "zero owner");
        return _balanceOf[owner];
    }

    function setApprovalForAll(address operator, bool approved) external {
        require(operator!= address(0), "zero operator");
        isApprovedForAll[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function getApproved(uint tokenId) external view returns(address) {
        address owner = _ownerOf[tokenId];
        require(owner != address(0), "Token does not exists");
        return _approvals[tokenId];
    }

    function approve(address spender, uint id) external {
        address owner = _ownerOf[id];
        // either an owner of a token or an operator
        require(owner == msg.sender || isApprovedForAll[owner][msg.sender], "no rights");

        _approvals[id] = spender;
        emit Approval(owner, spender, id);
    }

    function _isOwnerOrOperator(address owner, address spender, uint id) internal view returns(bool) {
        return owner == spender || isApprovedForAll[owner][spender] || _approvals[id] == spender;
    }

    function transferFrom(address from, address to, uint id) public {
        require(from == _ownerOf[id], "not an owner");
        require(to != address(0), "0 address");
        require(_isOwnerOrOperator(from, msg.sender, id));

        _balanceOf[from]--;
        _balanceOf[to]++;
        _ownerOf[id] = to;

        delete _approvals[id];

        emit Transfer(from, to, id);
    }
    function _safeTransferFrom(address from, address to, uint id, bytes memory data) internal {
        transferFrom(from, to, id);
        require(to.code.length == 0 || IERC721Receiver(to).onERC721Received(msg.sender, from, id, data) == IERC721Receiver.onERC721Received.selector, "unsafe recipient");
    }

    function safeTransferFrom(address from, address to, uint id) external {
        _safeTransferFrom(from, to,  id, "");
    }

    function safeTransferFrom(address from, address to, uint id, bytes calldata data) external {
        _safeTransferFrom(from, to,  id, data);
    }

    function _mint(address to, uint id) internal {
        require(to != address(0), "invalid address");
        require(_ownerOf[id] == address(0), "already exists");

        _ownerOf[id] = to;
        _balanceOf[to] += 1;
        emit Transfer( address(0), to, id);        
    }

    function _burn(uint id) internal {
        address owner = _ownerOf[id];
        require(owner != address(0), "Doesn't exist");
        delete _ownerOf[id];
        delete _approvals[id];
        _balanceOf[owner] -= 1;
        emit Transfer(owner, address(0), id);        
    }
}

contract MyNFT is ERC721 {
    function mint(address to, uint id) external {
        _mint(to, id);
    }

    function burn(uint id) external {
        require(msg.sender == _ownerOf[id], "not an owner");
        _burn(id);
    }
}


