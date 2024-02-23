// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract bernfhisry {
    address owner;

    mapping (address => uint) balancesOf;
    mapping (address => uint) benfhsiar;

    event Success(address indexed from, address to);


    constructor() {
        owner = msg.sender;
    }

    function depets(uint _reciever) external payable {
        require(msg.sender != address(0), "address ZERO not valid");
        require(msg.value > 0, "must be greater than ZERO");

        balancesOf[msg.sender] += msg.value;
        benfhsiar[msg.sender] = _reciever;

    } 

    function genrat(uint _reciever) external {
       require(balancesOf[msg.sender] > 0, "you cant send any token");
        benfhsiar[msg.sender] = _reciever;

    }
}