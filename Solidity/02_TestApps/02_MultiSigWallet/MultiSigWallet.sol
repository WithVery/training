// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

contract MultiSigWallet {
    event Deposit(address indexed sender, uint amount, uint balance);
    event SubmitTransaction(address indexed owner, uint indexed txIndex, address indexed to, uint value, bytes data);

    event ConfirmTransaction(address indexed owner, uint indexed txIndex);
    event RevokeTransaction(address indexed owner, uint indexed txIndex);
    event ExecuteTransaction(address indexed owner, uint indexed txIndex);

    address[] public owners;
    mapping(address =>bool) public isOwner;
    uint public  numConfirmationsRequired;

    struct Transaction {
        address to;
        uint value;
        bytes data;
        bool executed;
        uint numConfirmations;
    }

    Transaction[] public transactions;
    mapping(uint => mapping(address => bool)) isConfirmed;


    constructor(address[] memory _owners, uint _numConfirmationsRequired) payable {
        require(_owners.length > 0, "No owners");
        require(_numConfirmationsRequired > 0 && _numConfirmationsRequired <= _owners.length, "# of confirmation inconsistent");

        for(uint i = 0; i < _owners.length; i++) {
            address owner = _owners[i];

            require(owner != address(0), "Invalid address");
            require(!isOwner[owner], "Unique owners only");

            isOwner[owner] = true;
            owners.push(owner);
        }
        numConfirmationsRequired = _numConfirmationsRequired;
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);        
    }

    fallback() external payable {
        emit Deposit(msg.sender, msg.value, address(this).balance);        
    }

    modifier onlyOwner() {
        require(isOwner[msg.sender], "Not an owner");
        _;
    }

    modifier txExists(uint _idx) {
        require(_idx < transactions.length, "invalid tx #");
        _;
    }

    modifier notConfirmed(uint _idx) {
        require(!isConfirmed[_idx][msg.sender], "tx already confirmed");
        _;
    }

    modifier notExecuted(uint _idx) {
        require(!transactions[_idx].executed, "tx already executed");
        _;
    }

    function submitTransaction(address _to, uint _value, bytes memory _data) public onlyOwner {
        uint txIndex = transactions.length;

        transactions.push(
            Transaction({
                to: _to,
                value: _value,
                data: _data,
                executed: false,
                numConfirmations: 0
            })
        );
        emit SubmitTransaction(msg.sender, txIndex, _to, _value, _data);
    }

    function confirmTransaction(uint _txIndex) public 
    onlyOwner
    txExists(_txIndex)
    notConfirmed(_txIndex)
    notExecuted(_txIndex)
    {
        transactions[_txIndex].numConfirmations += 1;
        isConfirmed[_txIndex][msg.sender] = true;

        emit ConfirmTransaction(msg.sender, _txIndex);
    }

    function executeTransaction(uint _txIndex) public 
    onlyOwner
    txExists(_txIndex)
    notExecuted(_txIndex)
    {
        Transaction storage transaction = transactions[_txIndex];

        transaction.executed = true;

        require(transaction.numConfirmations >= numConfirmationsRequired, "Not enough confirmations");
        
        (bool ok, ) = payable(transaction.to).call{value:transaction.value}(transaction.data);
        require(ok, "transaction failed");

        emit ExecuteTransaction(msg.sender, _txIndex);
    }

    function revokeTransaction(uint _txIndex) public
    onlyOwner
    txExists(_txIndex)
    notExecuted(_txIndex)
    {
        require(isConfirmed[_txIndex][msg.sender], "tx wasn't confirmed");

        Transaction storage transaction = transactions[_txIndex];


        transaction.numConfirmations-=1;
        isConfirmed[_txIndex][msg.sender] = false;

        emit RevokeTransaction(msg.sender, _txIndex);


    }

    function getOwners() view public returns(address[] memory) {
        return owners;
    }

    function getTransactionsCount() view public returns(uint) {
        return transactions.length;
    }

    function getTrasaction(uint _txIndex) public view txExists(_txIndex)  returns(
        address to,
        uint value,
        bytes memory data,
        bool executed,
        uint numConfirmations
    ) 
    {
        Transaction storage transaction = transactions[_txIndex];
        return (
            transaction.to,
            transaction.value,
            transaction.data,
            transaction.executed,
            transaction.numConfirmations
        );
    }
}

