// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

contract TicketMinter is ERC721, ERC721Enumerable, ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;
    uint256 _tokenId = 1;

    using SafeMath for uint256;

    uint256 public constant mintPrice = (1 ether / 10);

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
        internal
        override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    constructor() ERC721("Flex", "MNT") {
        _tokenIdCounter.increment();
    }

    function mint(string[] memory uri) public payable {
        require(msg.value >= mintPrice, "Not Enough Ether");

        for (uint8 i = 0; i < uri.length; i++) {
            _tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, _tokenId);
            _setTokenURI(_tokenId, uri[i]);
        }
    }

    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    function withdrawMoneyTo(address payable _to) public {
        _to.transfer(getBalance());
    }
}
