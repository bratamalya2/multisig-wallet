pragma solidity ^0.5.0;

contact MultiSigWallet{
    address private _owner;
    mapping (address => uint8) private _users; //existing users
    event DepositFunds(address from,uint amount);
    event WithdrawFunds(address to,uint amount);

    constructor(){
        _owner=msg.sender;
    }

    modifier isOwner(){
        require(msg.sender==_owner,"You are not authorised!");
        _;
    }

    modifier isUser(){
        require(msg.sender==_owner || _users[msg.sender]==1,"User doesn't exist!");
    }

    function addOwner(address newOwner) public isOwner {
        _users[newOwner]=1;
    }

    function removeOwner(address exisitingOwner) public isUser{
        _users[exisitingOwner]=0;
    }

    function () public isUser{
        DepositFunds(msg.sender,msg.value);
    }

    function withdraw(uint amount) public isUser{
        require(address(this).balance >= amount,"Insufficient funds!");
        msg.sender.transfer(amount);
    }
}