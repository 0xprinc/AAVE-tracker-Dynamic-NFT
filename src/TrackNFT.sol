// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;

import "@openzeppelin/token/ERC721/ERC721.sol";
import "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/access/Ownable.sol";
import {Base64} from "./Base64.sol";

contract Tracker is ERC721, Base64 {

    mapping(uint256 => info) public desc;

        struct info {
        string nameOfContract;                  // name that the user wants to give to their nft
        address target;                         // address of the contract to interact with
        bytes data;                             // calldata to send
    }

    constructor() ERC721("Track", "TRACK") {}

    // convert uint to string so as to concatenate with other strings

    function _burn(uint256 tokenId) internal override(ERC721) {
        super._burn(tokenId);
    }

    function mint(
        address to, 
        uint256 tokenId, 
        string memory _nameOfContract, 
        address _target,
        bytes memory _data ) 
    public {
        _safeMint(to, tokenId);
        desc[tokenId] = info(_nameOfContract, _target, _data);
    }

    function getSvg(uint tokenId) public returns (string memory) {

        (, bytes memory _output) = desc[tokenId].target.call(desc[tokenId].data);
        uint output = abi.decode(_output,(uint));

        string memory svg;
        svg = concatenateStrings("<svg width='250' height='400' xmlns='http://www.w3.org/2000/svg'><style>text{font-family:Arial,sans-serif;font-size:24px;fill:#fff;text-anchor:middle}</style><rect width='100%' height='100%'/><text x='125' y='150' style='font-weight:700;fill:#0af'>",desc[tokenId].nameOfContract,"</text><text x='125' y='250' style='font-style:italic;fill:#f50'>",uint2str(output),"</text></svg>");
        return svg;
    }    

    function tokenURI(uint256 tokenId) override(ERC721) public nonpayable returns (string memory) {
        string memory json = Base64.encode(
            bytes(string(
                abi.encodePacked(
                    '{"name": "', desc[tokenId].nameOfContract, '",',
                    '"image_data": "', getSvg(tokenId), '"}'
                )
            ))
        );
        return string(abi.encodePacked('data:application/json;base64,', json));
    }    
}

