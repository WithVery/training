// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

interface IERC20 {
    function transfer(address, uint) external returns(bool);
    function transferFrom(address, address, uint) external;
}

contract Crowdfunding {
    uint32 constant MAX_DURATION = 90 days;

    event Launch(uint id, address indexed creator, uint goal, uint32 startAt, uint32 endAt);
    event Cancel(uint id);
    event Pledge(uint indexed id, address indexed caller, uint amount);
    event Unpledge(uint indexed id, address indexed caller, uint amount);
    event Claim(uint id);
    event Refund(uint indexed id, address indexed caller, uint amount);

    struct Campaign {
        address creator;
        uint goal;
        uint pledged;
        uint32 startAt;
        uint32 endAt;
        bool claimed;
    }

    IERC20 public immutable token;
    uint public count;
    mapping(uint=>Campaign) campaigns;
    mapping(uint=>mapping(address=>uint)) pledgedAmounts;

    constructor(address _token) {
        token = IERC20(_token);
    }

    function launch(uint _goal, uint32 _startsAt, uint32 _endsAt) external {
        require(0 < _goal, "zero goal");
        require(block.timestamp < _startsAt, "starts < now");
        require(_startsAt < _endsAt, "0 duration");
        require(_endsAt < _startsAt + MAX_DURATION, "too long");

        count += 1;
        campaigns[count] = Campaign({
            creator : msg.sender,
            goal : _goal,
            pledged : 0,
            startAt : _startsAt,
            endAt  : _endsAt,
            claimed : false
        });

        emit Launch(count, msg.sender, _goal, _startsAt, _endsAt);
    }

    function pledge(uint _campaignId, uint _amount) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt,   "ended");

        campaign.pledged += _amount;
        pledgedAmounts[_campaignId][msg.sender] += _amount;
        token.transferFrom(msg.sender, address(this), _amount);

        emit Pledge(_campaignId, msg.sender, _amount);
    }

    function unpledge(uint _campaignId, uint _amount) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(block.timestamp >= campaign.startAt, "not started");
        require(block.timestamp <= campaign.endAt,   "ended");

        campaign.pledged -= _amount;
        pledgedAmounts[_campaignId][msg.sender] -= _amount;
        token.transfer(msg.sender, _amount);

        emit Unpledge(_campaignId, msg.sender, _amount);
    }

    function claim(uint _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.creator == msg.sender, "not a creator");
        require(campaign.endAt < block.timestamp, "not finished");
        require(campaign.goal <= campaign.pledged, "campaign failed");
        require(!campaign.claimed, "already claimed");

        campaign.claimed = true;
        token.transfer(msg.sender, campaign.pledged);

        emit Claim(_campaignId);
    }

    function refund(uint _campaignId) external {
        Campaign storage campaign = campaigns[_campaignId];
        require(campaign.endAt < block.timestamp, "not ended");

        uint bal = pledgedAmounts[_campaignId][msg.sender];
        pledgedAmounts[_campaignId][msg.sender] = 0;
        token.transfer(msg.sender, bal);

        emit Refund(_campaignId, msg.sender, bal);

    }



}