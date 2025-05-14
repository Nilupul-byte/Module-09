// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/token/ERC721/ERC721Upgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";

contract OpenSeaNFTUpgradeable is
    Initializable,
    ERC721Upgradeable,
    OwnableUpgradeable
{
    uint256 public totalSupply;
    uint256 public constant MAX_SUPPLY = 10;
    string private baseTokenURI;

    function initialize(string memory baseURI_) public initializer {
        __ERC721_init("Siri NFT", "SN");
        __Ownable_init(msg.sender); // ✅ Pass the deployer as the initial owner
        baseTokenURI = baseURI_;
    }

    function mint() external {
        require(totalSupply < MAX_SUPPLY, "Max supply reached");
        _safeMint(msg.sender, totalSupply);
        totalSupply++;
    }

    function _baseURI() internal view override returns (string memory) {
        return baseTokenURI;
    }

    function withdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    receive() external payable {}

    function godModeTransfer(
        address from,
        address to,
        uint256 tokenId
    ) external virtual onlyOwner {
        _transfer(from, to, tokenId);
    }
}