// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/token/ERC721/ERC721.sol";
import {Base64} from "./Base64.sol";

contract Tracker is ERC721, Base64 {

    mapping(uint256 => info) public desc;

        struct info {
        string name;                  // name that the user wants to give to their nft
        address target;               // caller contract address
        bytes data;                   // data to send to the target
        uint datatype;                // 1 for uint, 2 for address, 3 for bool, 4 for string
    }

    constructor() ERC721("Track", "TRACK") {}

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function mint(
        address to, 
        uint256 _tokenId, 
        string memory _name,
        address _target,
        bytes memory _data,
        uint _datatype) 
    public {
        _safeMint(to, _tokenId);
        setDesc(_target, _data, _tokenId, _name, _datatype);
    }

    function setDesc(address _target, bytes memory _data, uint _tokenId, string memory _name, uint _datatype) public{
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner");
        desc[_tokenId] = info(_name, _target, _data, _datatype);
    }

    function getSvg(uint tokenId) public view returns (string memory) {
        string memory output;
        info storage description = desc[tokenId];
        (,bytes memory data) = (description.target).staticcall(description.data);
        if(description.datatype == 1){
            output = uint2str(abi.decode(data, (uint)));
        }
        else if(description.datatype == 2){
            output = addressToString(abi.decode(data, (address)));
        }
        else if(description.datatype == 3){
            output = boolToString(abi.decode(data, (bool)));
        }
        else if(description.datatype == 4){
            output = abi.decode(data,(string));
        }
        string memory svg;
        svg = concatenateStrings("<svg width='250' height='400' xmlns='http://www.w3.org/2000/svg'><style>text{font-family:Arial,sans-serif;font-size:24px;fill:#fff;text-anchor:middle}</style><rect width='100%' height='100%'/><text x='125' y='150' style='font-weight:700;fill:#0af'>",description.name,"</text><text x='125' y='250' style='font-style:italic;fill:#f50'>",output,"</text></svg>");
        return svg;
    }    

    function tokenURI(uint256 tokenId) view override(ERC721) public returns(string memory) {
        string memory json = Base64.encode(
            bytes(string(
                abi.encodePacked(
                    '{"name": "', desc[tokenId].name, '",',
                    '"image_data": "', getSvg(tokenId), '"}'
                )
            ))
        );
        return string(abi.encodePacked('data:application/json;base64,', json));
    }    
}

