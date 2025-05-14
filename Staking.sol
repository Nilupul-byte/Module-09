// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract NFTStakingUpgradeable is Initializable, OwnableUpgradeable {
    IERC20 public token;
    IERC721 public nft;
    mapping(uint256 => address) public stakedBy;
    mapping(uint256 => uint256) public lastClaim;
    uint256 public rewardPerDay;
    uint256 public stakingTime;

    function initialize(IERC20 _token, IERC721 _nft) public initializer {
    __Ownable_init(msg.sender);
    token = _token;
    nft = _nft;
    rewardPerDay = 10 * 10 ** 18;
    stakingTime = 1 minutes;
    }


    function stakeNFT(uint256 tokenId) public {
        require(nft.ownerOf(tokenId) == msg.sender, "Not the owner");
        require(stakedBy[tokenId] == address(0), "Already staked");
        nft.transferFrom(msg.sender, address(this), tokenId);
        stakedBy[tokenId] = msg.sender;
        lastClaim[tokenId] = block.timestamp;
    }

    function claimRewards(uint256 tokenId) public {
        require(stakedBy[tokenId] == msg.sender, "Not staked by you");
        require(
            block.timestamp >= lastClaim[tokenId] + stakingTime,
            "Too soon to claim"
        );
        token.transfer(msg.sender, rewardPerDay);
        lastClaim[tokenId] = block.timestamp;
    }

    function unstakeNFT(uint256 tokenId) public {
        require(stakedBy[tokenId] == msg.sender, "Not staked by you");
        nft.transferFrom(address(this), msg.sender, tokenId);
        delete stakedBy[tokenId];
        delete lastClaim[tokenId];
    }
}