// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract Vault {
    uint256 private id;

    struct Grant {
        string name;
        uint256 amount;
        uint256 duration;
        uint256 id;
    }

    mapping(address => uint256) public grantIdCount;
    mapping(address => mapping(uint256 => Grant)) public individualGrantToBeneficiary;
    mapping(address => bool) public hasGrant;
    address[] public beneficiaries;

    function noZeroAddr() private view {
        if (msg.sender == address(0)) {
            revert("no zero address");
        }
    }

    function storeBeneficiary(address _recipient) private {
        if (!hasGrant[_recipient]) {
            beneficiaries.push(_recipient);
            hasGrant[_recipient] = true;
        }
    }

    function giveGrant(address _recipient, string memory _grantName, uint256 _duration) external payable {
        noZeroAddr();

        uint256 _id = id + 1;

        payable(address(this)).transfer(msg.value);

        Grant memory grant = Grant(_grantName, msg.value, _duration, _id);
        individualGrantToBeneficiary[_recipient][_id] = grant;

        grantIdCount[_recipient] = grantIdCount[_recipient] + 1;
        storeBeneficiary(_recipient);
        id = _id;
    }

    function claimGrant(uint _id) external payable {
        noZeroAddr();

        Grant memory grant = individualGrantToBeneficiary[msg.sender][_id];
        require(block.timestamp >= grant.duration, "wait first");

        uint256 amount = grant.amount;
        grant.amount = 0;
        payable(msg.sender).transfer(amount);

        grantIdCount[msg.sender] = grantIdCount[msg.sender] - 1;
    }

    receive() external payable {}

    fallback() external payable {}
}
