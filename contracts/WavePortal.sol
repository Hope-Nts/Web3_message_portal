// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "hardhat/console.sol";

contract WavePortal {
    uint totalWaves;
    uint private seed;


    // A struct here named wave
    // a struct is basically a custom datatype where we can customize what
    // we want to hold inside it
    struct Wave {
      string message; // the message the user sent
      address wave; // the address of the ser who waved
      uint timestamp; // the timestamp when the user waved
    }

    // I declare a variable waes tat lets me store an array of structs
    // This is what lets me hold all the waes anyone ever sends to me!
    Wave[] waves;

    //A little magic, Google what events are in Solidity
    event NewWave(address indexed  from, uint timestamp, string messsage);

    // This is an address => uint mapping, meaning I can associate
    // an address with  a number in this case, I'll be storing the
    // addres w/ the last time the user waved at us
    mapping(address => uint) public lastWavedAt;

    constructor() payable {
      console.log(" We have been constructed!");
    }

    // You'll notice I changed the wave function a little as well and
    // now it requires a strin called message. This is the mess our
    // user sends us from the frontend!
    function wave(string memory _message) public {
      // We need to make sure the current timestamp is at least
      // 15 minutes bigger than the last timestamp we stored
      require(lastWavedAt[msg.sender] + 30 seconds < block.timestamp, "Wait 15m");

      //Update the current timestamp we have for the user.
      lastWavedAt[msg.sender] = block.timestamp;

      totalWaves += 1;
      console.log("%s waved w/ message %s", msg.sender, _message);
      console.log("Got message %s", _message);
      //This is where I actually store the wave data in the array
      waves.push(Wave(_message,msg.sender,  block.timestamp));

      //Genrate a PSEUDO random number in the range 100.
      uint randomNumber = (block.difficulty + block.timestamp + seed) % 100;
      console.log("Random # generated: %s", randomNumber);

      //set the generated number as the seed for the next wave
      seed = randomNumber;

      if(randomNumber < 50){
        console.log("%s won", msg.sender);
        //the same code we had before to send the prize
        uint prizeAmount = 0.0001 ether;
        require(prizeAmount <= address(this).balance, "Trying to withdraw more money than the contract has. ");
        (bool success,) = (msg.sender).call{value: prizeAmount}("");
        require(success, "Failed to withdraw money from contract. ");
      }

      // I added some fanciness here, Google it and try to figure
      // out what it is! Let me know what you learn inn the #course-chat
      emit NewWave(msg.sender,block.timestamp, _message);
      
      
    }

    // I added a function getAllWaves which will return 
    // the struct array waves to us. This will make it easy to retrieve
    // the waves from our website!
    function getAllWaves() view public returns (Wave[] memory){
      return waves;
    }

    function getTotalWaves() view public returns (uint){
      return totalWaves;
    }
}