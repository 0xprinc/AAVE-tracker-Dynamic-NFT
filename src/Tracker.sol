// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/token/ERC721/ERC721.sol";
import "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/access/Ownable.sol";
import {Base64} from "./Base64.sol";

contract Caller{
    function get() public view returns(uint){}
}

contract Tracker is ERC721, Base64 {

    mapping(uint256 => info) public desc;

        struct info {
        string name;                  // name that the user wants to give to their nft
        Caller caller;               // caller contract address
    }

    constructor() ERC721("Track", "TRACK") {}

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function create2deploy(bytes memory _bytecode, uint _salt) internal returns(address callerAddress){
        bytes memory initCode = abi.encodePacked(_bytecode);
        assembly {
            callerAddress :=
                create2(0, add(initCode, 0x20), mload(initCode), _salt)
            if iszero(extcodesize(callerAddress)) { revert(0, 0) }
        }
        return address(callerAddress);
    }
    function mint(
        address to, 
        uint256 _tokenId, 
        string memory _name,
        bytes memory _bytecode,
        uint _salt) 
    public {
        _safeMint(to, _tokenId);
        setDesc(_bytecode, _salt, _tokenId, _name);
    }

    function setDesc(bytes memory _bytecode, uint _salt, uint _tokenId, string memory _name) public{
        require(ownerOf(_tokenId) == msg.sender, "You are not the owner");
        Caller c = Caller(create2deploy(_bytecode, _salt));
        desc[_tokenId] = info(_name, c);

        // uint output = c.get()
    }

    function getSvg(uint tokenId) public view returns (string memory) {
        uint output = (desc[tokenId].caller).get();
        string memory svg;
        svg = concatenateStrings("<svg width='250' height='400' xmlns='http://www.w3.org/2000/svg'><style>text{font-family:Arial,sans-serif;font-size:24px;fill:#fff;text-anchor:middle}</style><rect width='100%' height='100%'/><text x='125' y='150' style='font-weight:700;fill:#0af'>",desc[tokenId].name,"</text><text x='125' y='250' style='font-style:italic;fill:#f50'>",uint2str(output),"</text></svg>");
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

