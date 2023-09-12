// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

contract Voting {
    uint public participantId;
    uint public voterNumber;

    address public voteOrganiser;

    struct Participant {
        uint gender;
        uint participantId;
        uint age;
        string name;
        uint voteCount;
        address _participantAddress;
    }

     address[] public votedVoters;
   
    event participantCreate (uint gender,uint participantId,uint age,string name,
    uint voteCount,address participantAddress);

    address[] public participantAddress;
    mapping (address => Participant) public participants;

   

    struct Voters {
         string name;
        uint votes;
        uint id;
        uint voterAllowed;
        address voterAddress;
        bool voterVoted;
    }

    event VoterCreate (uint id,string name,address voterAddress,
    uint voterAllowed, bool voterVoted, uint votes);

    mapping (address => Voters) public voteData;

    constructor () {
        voteOrganiser = msg.sender;
    }
    function createParticipant(uint _gender, uint _age,
    string memory _name, address _participantAddress) 
    public {
        require(voteOrganiser == msg.sender,"Only voteOrganizer are allowed to create vote participant");
        participantId++;
        Participant storage participant =participants[_participantAddress];
        participant.gender = _gender;
        participant.age = _age;
        participant.name = _name;
        participant.voteCount = 0;
        participant._participantAddress = _participantAddress;
        participantAddress.push(_participantAddress);
        emit participantCreate (_gender, participantId,_age,_name,participant.voteCount, _participantAddress);
    }

     function getParticipantData(address _participantAddress)
      public view returns ( uint, string memory, uint, uint, address)  {
        return (

            participants[_participantAddress].participantId,
            participants[_participantAddress].name,
            participants[_participantAddress].age,
            participants[_participantAddress].voteCount,
            participants[_participantAddress]._participantAddress
        );
    } 


    function getParticipantLength() public view returns (uint) {
        return participantAddress.length;
    }

    
     function getParticipant() public view returns (address[] memory) {
        return participantAddress;
    }

     function vote(address _participantAddress,uint _participantVotersId) public {
        Voters storage voters = voteData[msg.sender];
        require(!voters.voterVoted,"You have  voted");
        require(voters.voterAllowed != 0,"Sorry you are not eligible to vote");
        voters.voterVoted = true;
        voters.votes = _participantVotersId;
        votedVoters.push(_participantAddress);
        participants[_participantAddress].voteCount += voters.voterAllowed;
    }

     function getVoterData(address _participantAddress) public view returns (uint,string memory,address,uint,uint,bool) {
        return (
            voteData[_participantAddress].id,
            voteData[_participantAddress].name,
            voteData[_participantAddress].voterAddress,
            voteData[_participantAddress].voterAllowed,
            voteData[_participantAddress].votes,
            voteData[_participantAddress].voterVoted
        );
    } 

    function getVoterLength() public view returns (uint) {
        return votedVoters.length;
    }   


}