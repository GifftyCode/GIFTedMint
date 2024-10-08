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


    constructor()
        ERC721("GIFTedMint", "GFT")
        Ownable(msg.sender)
    {}

    function _baseURI() internal pure override returns (string memory) {
        return "ipfs://QmXdrziGPZ9TFLNT6UQab5p3oVVC4VdTLv5Xu9nZ6c8kQS";
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
        require(allowList[msg.sender], 'You are not on the allow list');
        require(msg.value == 0.001 ether, 'Not enough funds');

        internalMint();
    }


    // Add payment
    // Add limiting of supply
    function publicMint() public payable {
        require(publicMintOpen, 'Public Mint is closed');
        require(msg.value == 0.01 ether, 'Not enough funds');
        
        internalMint();
    }

      // Withdraw function
    function withdraw(address _addr) external onlyOwner {
        // Get the balance
        uint256 balance = address(this).balance;
        payable(_addr).transfer(balance);
    }

      // Cleaning up our code

    function internalMint() internal {
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
