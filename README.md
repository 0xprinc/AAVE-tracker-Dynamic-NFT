# Dynamic-NFT
This repo contains the code of the Dynamic Tracker NFT with Onchain Metadata.<br>
__The NFT interacts onchain with other contracts so as to send and receive data as per set by the holder of that NFT.__
Example uses can be:
- Tracking the price of an asset by interacting with oracle
- Tracking the user data in any DeFi protocol
- Tracking balance of a user related to any token
- ...
- ...
- ...
- Basically any data provided gasless by any protocol onchain can be catched inside this NFT :)

### Overview of the NFT Contract
The Holder can change the following three fields related to the NFT:
+ The name of the NFT so as to recognize it among others
+ The contract to which the NFT will interact with
+ The data to send to the contract to interact with

### To-Do
- [x] Implement the Contract with onchain metadata
- [x] Add external call mechanism and plug it into Metadata
- [x] Reading the data as unsigned Integer datatype
- [x] Reading the data as an address datatype
- [ ] Reading the data as a general datatype and plug it into the NFT
- [ ] Make an AAVE `pool.sol/getUserData()` reading NFT Contract

