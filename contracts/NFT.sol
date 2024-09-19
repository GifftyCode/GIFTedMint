// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract GIFTedMint is ERC721, ERC721Enumerable, ERC721Pausable, Ownable {
    uint256 private _nextTokenId;
    uint256 maxSupply = 1000;


    bool public publicMintOpen = false;
    bool public allowListMintOpen = false;

    mapping(address => bool) public allowList;


    constructor(address initialOwner)
        ERC721("GIFTedMint", "GFT")
        Ownable(initialOwner)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmdkWxrdGR4xKDUobn3UpoWr7tHkabNU38AGThHy4AMn4s";
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

       // Modify the mint windows
    function editMint(
        bool _allowListMintOpen,
        bool _publicMintOpen
    ) external onlyOwner{
        allowListMintOpen = _allowListMintOpen;
        publicMintOpen = _publicMintOpen;
        
    }


       function allowMint() public payable  {
        require(allowListMintOpen, 'Allow list Mint is closed');
        require(msg.value == 0.001 ether, 'Not enough funds');
        require(totalSupply() < maxSupply, 'We are sold out');
        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }


    // Add payment
    // Add limiting of supply
    function publicMint() public payable {
        require(publicMintOpen, 'Public Mint is closed');
        require(msg.value == 0.01 ether, 'Not enough funds');
        require(totalSupply() < maxSupply, 'We are sold out');

        uint256 tokenId = _nextTokenId++;
        _safeMint(msg.sender, tokenId);
    }

      // Populate the allow list
    function setAllowList(address[] calldata addresses) external onlyOwner {
        for (uint256 i = 0; i < addresses.length; i++) 
        {
            allowList[addresses[i]] = true;
        }
    }

    // The following functions are overrides required by Solidity.

    function _update(address to, uint256 tokenId, address auth)
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value)
        internal
        override(ERC721, ERC721Enumerable)
    {
        super._increaseBalance(account, value);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
