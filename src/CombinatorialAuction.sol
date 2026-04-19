// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.*;

import "./ICombinatorialAuction.sol";

/**
 * @title Combinatorial auction implementation
 * @author Anonymous Student
 * @notice Implementation a sealed-bid combinatorial auction with a value density heuristic
 */
contract CombinatorialAuction is ICombinatorialAuction {
    function initialize(
        AuctionItem[] calldata _items,
        uint256 _commitmentPhaseDurationSeconds,
        uint256 _revealPhaseDurationSeconds
    ) external override {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function commitBid(bytes32 _commitmentHash) external payable override {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function revealBid(uint256[] calldata _itemIds, uint256 _bidAmount, uint256 _nonce) external override {
        // TODO Your implementation ...
        // For hasing, use
        // keccak256(abi.encode(...))
        revert("Missing implementation");
    }

    function withdrawBid() external override {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function solveWinnerDetermination() external override returns (address[] memory, uint256) {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function refundLosingBid(address _bidder) external override {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function getAuctionInfo() external view override returns (AuctionInfo memory) {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function getItems() external view override returns (AuctionItem[] memory) {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function getItem(uint256 _itemId) external view override returns (AuctionItem memory) {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function getBid(address _bidder) external view override returns (BundleBid memory) {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function getResult() external view override returns (AllocationResult memory) {
        // TODO Your implementation ...
        revert("Missing implementation");
    }

    function getWinningBidOfItem(uint256 _itemId) external view override returns (BundleBid memory) {
        // TODO Your implementation ...
        revert("Missing implementation");
    }
}
