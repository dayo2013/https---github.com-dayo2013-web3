// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Verify { 
    function verifyProof( uint[2] memory, uint[2] memory, uint[2][2] memory, uint[2] memory, uint[2] memory, uint[2] memory, uint[2] memory, uint[2] memory, uint[7] memory) external pure returns (bool){} 
}

contract Voting {
     struct Votes{
        bytes[] president;
        bytes[] senator;
        bytes[] stateGovernor;
        bytes32 counter;//it keeps tract of number of voter set.
     }
     struct DYPUMPINGVoter {
        address DYAddress;
        bytes pubKeyToRecover;// The public key that can be used to recover the DY voter's 
        bytes32 _opMarker;//A bytes32 value that is used to mark the DY voter's operation.
        bool canVote;//individaual that can vote
        bool voted;//person voted
     }

         struct RealVoter{
        address realVoterAddress;
        uint[2] a;//An array of two uint values that stores the values of a.
        uint[2] a_p;//An array of two uint values that stores the previous values of a.
        uint[2][2] b;//An array of two uint values that stores the values of b
        uint[2] b_p;//
        uint[2] c;
        uint[2] c_p;
        uint[2] h;
        uint[2] k;
        uint[7] input;//An array of seven uint values that stores the input values.
        bool voted; // A boolean value that indicates whether the real voter has already voted.
    }
     struct Result{
        uint[] president;//An array of uint values that stores the votes for president.
        uint[] senator;
        uint[] stateGovernor;
        bytes32[] encryptedResult;//An array of bytes32 values that stores the encrypted results of the election.
        bytes32[] proof;//An array of bytes32 values that stores the proofs of the encrypted results

    }
    
     DYPUMPINGVoter[] public DYVoterArray;//ay stores the information about all of the dypumping voters in the election. 
    Votes[] voteArray;
    RealVoter[] realVoterArray;

     mapping(address => uint) public DYPUMPINGVoters;
    mapping(address => uint) public votes;
    mapping(address => uint) public realVoters;
    
     address  owner; 
    address    zkVerifier;// This contract is responsible for verifying the proofs of the encrypted votes.
    bytes32  ballotIdentifier;
    bytes  encryptionPublicKey; // better if converted to hex
    uint  votersCount;
    uint  votesCount;
    uint  voteProofs;


     constructor (
        bytes32  _ballotIdentifier, 
        bytes memory _encryptionPublicKey, 
        address _zkVerifier
        ) public {
        owner = msg.sender;
        ballotIdentifier = _ballotIdentifier;
        encryptionPublicKey = _encryptionPublicKey;
        zkVerifier = _zkVerifier;
    }

    
        function addEphemeralVoter(
        address _address, 
        bytes memory _pubKeyToRecover, 
        bytes32 _opMarker
        ) public returns(bool){
        
        // DYVoterArray.length++; 
        DYVoterArray[DYVoterArray.length-1].DYAddress = _address;
        DYVoterArray[DYVoterArray.length-1].pubKeyToRecover = _pubKeyToRecover;
        DYVoterArray[DYVoterArray.length-1]._opMarker = _opMarker;
        DYVoterArray[DYVoterArray.length-1].canVote = true;
        
        DYPUMPINGVoters[_address] = DYVoterArray.length-1;
        
        votersCount+=1;
        return(true);
    }

      function addVote(
        bytes[] memory _president, 
        bytes[] memory _senator, 
        bytes[] memory _stateGovernor,
        bytes32 _counter
        ) public returns(bool){
        
        //EphemeralVoter storage sender = ephemeralVoters[msg.sender];
        DYPUMPINGVoter storage sender = DYVoterArray[DYPUMPINGVoters[msg.sender]];
        if (sender.voted || !sender.canVote) return(false);
        
        // voteArray.length++;
        voteArray[voteArray.length-1].president = _president;
        voteArray[voteArray.length-1].senator = _senator;
        voteArray[voteArray.length-1].stateGovernor = _stateGovernor;
        voteArray[voteArray.length-1].counter = _counter;
        
        votes[msg.sender] = voteArray.length-1;
        
        votesCount+=1;
        
        sender.voted = true;
        sender.canVote = false;
        return(true);
    }

     function registerVoteProof(
        uint[2] memory _a,
        uint[2] memory _a_p,
        uint[2][2] memory _b,
        uint[2] memory _b_p,
        uint[2] memory _c,
        uint[2] memory _c_p,
        uint[2] memory _h,
        uint[2] memory _k,
        uint[7] memory _input
        ) public returns (bool){
        
        RealVoter storage sender = realVoterArray[realVoters[msg.sender]];
        if (sender.voted) return(false);
        
        Verify verifier = Verify(zkVerifier);
        if (!verifier.verifyProof(_a, _a_p, _b, _b_p, _c, _c_p, _h, _k, _input)) return (false);
        
       // realVoterArray.length++;
        
        realVoterArray[realVoterArray.length-1].realVoterAddress = msg.sender;
        realVoterArray[realVoterArray.length-1].a = _a;
        realVoterArray[realVoterArray.length-1].a_p = _a_p;
        realVoterArray[realVoterArray.length-1].b = _b;
        realVoterArray[realVoterArray.length-1].b_p = _b_p;
        realVoterArray[realVoterArray.length-1].c = _c;
        realVoterArray[realVoterArray.length-1].c_p = _c_p;
        realVoterArray[realVoterArray.length-1].h = _h;
        realVoterArray[realVoterArray.length-1].k = _k;
        realVoterArray[realVoterArray.length-1].input = _input;
        realVoterArray[realVoterArray.length-1].voted = true;
        
        realVoters[msg.sender] = realVoterArray.length-1;
        
        voteProofs+=1;
        return(true);
    }
        
    function getEphemeralWallets(uint _index) view public returns(address, bytes memory, bytes32){
        return(
            DYVoterArray[_index].DYAddress, 
            DYVoterArray[_index].pubKeyToRecover, 
            DYVoterArray[_index]._opMarker
            );
    }
    
    function getVotes(uint _index) view public returns(bytes[] memory, bytes[] memory, bytes[] memory){
        return(
            voteArray[_index].president, 
            voteArray[_index].senator, 
            voteArray[_index].stateGovernor
            );
    }
    
}

        



