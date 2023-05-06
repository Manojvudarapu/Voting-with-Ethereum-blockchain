// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

contract Voting {
    address public contractOwner;
    address[] public candidatesList;
    mapping (address => uint8) public votesReceived;
    address public winner;
    uint public winnerVotes;
    enum VotingStatus {NotStarted, Running, Completed}
    VotingStatus public status;
     
    constructor() {
        contractOwner = msg.sender;
        status = VotingStatus.NotStarted;
    }

    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Only the contract owner can perform this action");
        _;
    }

    function setStatus(VotingStatus _status) onlyOwner public {
        require(_status != status, "The new status should be different from the current status");
        require(_status != VotingStatus.NotStarted, "Cannot set the status to NotStarted");
        status = _status;
    }

    function registerCandidate(address _candidate) onlyOwner public {
        require(!validateCandidate(_candidate), "Candidate already registered");
        candidatesList.push(_candidate);
    }

    function vote(address _candidate) public {
        require(validateCandidate(_candidate), "Not a valid candidate");
        require(status == VotingStatus.Running, "Election is not active");
        votesReceived[_candidate]++;
    }

    function validateCandidate(address _candidate) view public returns(bool) {
        for(uint i = 0; i < candidatesList.length; i++){
            if (candidatesList[i] == _candidate) {
                return true;
            }
        }
        return false;
    }

    function votesCount(address _candidate) public view returns(uint){
        require(validateCandidate(_candidate), 'Not a valid Candidate');
        require(status == VotingStatus.Completed, "Cannot get vote count before the end of the election");
        return votesReceived[_candidate];
    }

    function  result() public onlyOwner {
        require(status == VotingStatus.Completed, "Cannot get the result before the end of the election");
        for(uint i =0; i < candidatesList.length; i++){
            if (votesReceived[candidatesList[i]] > winnerVotes){
                winnerVotes = votesReceived[candidatesList[i]];
                winner = candidatesList[i]; 
            }
        }
    }
}
