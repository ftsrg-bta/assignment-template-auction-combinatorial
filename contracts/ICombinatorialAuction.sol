// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.x;

/**
 * @title Combinatorial auction interface
 * @author FTSRG
 * @notice Interface for a sealed-bid combinatorial auction where bidders can bid on combinations of items
 * @dev Please do not modify this interface!
 */
interface ICombinatorialAuction {
    /** @notice Represents information about the auction
     * @param initialized Whether the auction has been initialized
     * @param commitmentPhaseEndTime Block timestamp when the commitment phase ends (exclusive)
     * @param revealPhaseEndTime Block timestamp when the reveal phase ends (exclusive)
     * @param numItems Number of items being auctioned
     * @param numBids Number of bids submitted so far
     * @param solved Whether this auction has been solved and the winners determined
     */
    struct AuctionInfo {
        bool initialized;
        uint256 commitmentPhaseEndTime;
        uint256 revealPhaseEndTime;
        uint256 numItems;
        uint256 numBids;
        bool solved;
    }

    /**
     * @notice Represents an item being auctioned
     * @param id Unique identifier for the item
     * @param description Arbitrary textual description for the item
     * @param minBid Minimum bid required for this item individually
     * @param owner Current owner of this item (the contract's address or a bidder's address if they won the item)
     * @dev In a full implementation, this struct would include the details of an token such as an NFT; now we just track the owner of an abstract item
     */
    struct AuctionItem {
        uint256 id;
        string description;
        uint256 minBid;
        address owner;
    }

    /**
     * @notice Represents a bid on a bundle of items
     * @param commitmentHash Keccak256 hash of (bidder address, item IDs, bid amount, nonce)
     * @param itemIds List of (unique) item IDs included in this bundle (hidden until revelation)
     * @param depositAmount Amount deposited with the bid (always known)
     * @param bidAmount Real bid amount (hidden until revelation)
     * @param revealed Whether this bid has been revelaed yet
     * @param withdrawn Whether this bid has been withdrawn by the bidder
     */
    struct BundleBid {
        bytes32 commitmentHash;
        uint256[] itemIds;
        uint256 depositAmount;
        uint256 bidAmount;
        bool revealed;
        bool withdrawn;
    }

    /**
     * @notice Represents the result of the auction after winners have been deteremined
     * @param winningBidders Addressess of bidders whose bids won
     * @param totalRevenue Sum of all winning bid amounts
     */
    struct AllocationResult {
        address[] winningBidders;
        uint256 totalRevenue;
    }

    /**
     * @notice Emitted when an auction is initialized and ready to receive bid commitments
     * @param itemIds Unique item IDs being auctioned
     * @param numItems Number of items being auctioned
     * @param commitmentPhaseEndTime Block timestamp when the commitment phase ends (exclusive)
     * @param revealPhaseEndTime Block timestamp when the reveal phase ends (exclusive)
     */
    event AuctionStarted(
        uint256[] itemIds,
        uint256 numItems,
        uint256 commitmentPhaseEndTime,
        uint256 revealPhaseEndTime
    );

    /**
     * @notice Emitted when a bid is for an item bundle
     * @param bidder Who committed the bid
     * @param commitmentHash Keccak256 hash of (bidder address, item IDs, bid amount, nonce)
     * @param depositAmount How much deposit the bidder has attached to the bid
     */
    event BidCommitted(
        address indexed bidder,
        bytes32 commitmentHash,
        uint256 depositAmount
    );

    /**
     * @notice Emitted when a bidder reveals their bid
     * @param bidder Who revealed the bid
     * @param itemIds Unique IDs of items the bidder included in their bundle
     * @param bidAmount Real bid amount
     */
    event BidRevealed(
        address indexed bidder,
        uint256[] itemIds,
        uint256 bidAmount
    );

    /**
     * @notice Emitted when a bidder withdraws their bid before the reveal phase
     * @param bidder Who withdrew their bid
     */
    event BidWithdrawn(
        address indexed bidder
    );

    /**
     * @notice Emitted when an auction ends and the winners are determined
     * @param winningBidders Addresses of those bidders that won in the auction
     * @param totalRevenue Sum of all winning bid amounts
     */
    event AuctionEnded(
        address[] winningBidders,
        uint256 totalRevenue
    );

    /**
     * @notice Initialize an auction
     * @param items Array of items for auction
     * @param commitmentPhaseDurationSeconds Duration of the commitment phase in seconds
     * @param revealPhaseDurationSeconds Duration of the reveal phase in seconds
     * @dev Can only be called once
     * @dev After this function is called, the contract is ready to receive bid commitments
     */
    function initialize(
        AuctionItem[] calldata items,
        uint256 commitmentPhaseDurationSeconds,
        uint256 revealPhaseDurationSeconds
    ) external;

    /**
     * @notice Commit a sealed bid
     * @param commitmentHash Keccak256 hash of (bidder address, item IDs, bid amount, nonce)
     * @dev Can only be called in the commitment phase
     * @dev There must be at least one item included in the bundle
     * @dev The deposited amount cannot be zero
     * @dev The deposited amount must be equal to or exceed the bid amount
     * @dev Each address can only place one bid
     */
    function commitBid(bytes32 commitmentHash) external payable;

    /**
     * @notice Reveal a previously committed bid
     * @param itemIds Unique item IDs that were included in the bundle
     * @param bidAmount Real bid amount
     * @param nonce Nonce value used in commitment
     * @dev Can only be called in the reveal phase
     * @dev Only committed and non-withdrawn bids can be revealed
     * @dev There must be at least one item included in the bundle
     * @dev The previously deposited amount must be equal to or exceed the bid amount
     * @dev The bid amount must exceed the sum of minimum bid amounts for the items included in the bundle
     * @dev The keccak256 hash formed from (message sender address, itemIds, bidAmount, nonce) must match the previously submitted commitment
     */
    function revealBid(
        uint256[] calldata itemIds,
        uint256 bidAmount,
        uint256 nonce
    ) external;

    /**
     * @notice Withdraw a previously committed bid before the reveal phase
     * @dev Can only be called in the commitment phase
     * @dev Only committed and non-withdrawn bids can be withdrawn
     * @dev A bidder can only withraw their own bid
     * @dev The bidder is refunded immediately and cannot make any more bids in this auction
     * @dev Withdrawn bids are ignored for the rest of the auction protocol
     */
    function withdrawBid() external;

    /**
     * @notice Close the auction and determine the winners
     * @return winners Addresses of those bidders who won in the auction
     * @return totalRevenue Sum of all winning bid amounts
     * @dev Can only be called after the reveal phase ends
     * @dev Can only be called once
     * @dev This function only determines winners and does not transfer any funds
     */
    function solveWinnerDetermination()
        external
        returns (address[] memory winners, uint256 totalRevenue);

    /**
     * @notice Refund the deposit of a bidder whose bid did not win
     * @param bidder Address whose deposit
     * @dev Can only be called after the auction was solved and the winners were determined
     * @dev Only non-winning, revealed, and non-withdrawn bids can be refunded
     */
    function refundLosingBid(address bidder) external;

    /**
     * @notice Retrieve information about this auction
     * @return Details about this auction
     * @dev Can only be called after initialization
     */
    function getAuctionInfo() external view returns (AuctionInfo memory);

    /**
     * @notice Retrieve information about the items being auctioned
     * @return Details about the items being auctioned
     * @dev Can only be called after initialization
     */
    function getItems() external view returns (AuctionItem[] memory);

    /**
     * @notice Retrieve information about a single item by its unique ID
     * @param itemId Unique identifier of the item to query
     * @return Details about the item
     * @dev Can only be called after initialization
     * @dev Must revert if the item does not exist
     */
    function getItem(uint256 itemId) external view returns (AuctionItem memory);

    /**
     * @notice Retrieve information about a bid
     * @param bidder Address whose bid to retrieve
     * @return Details about the bidder's bid
     * @dev Can only be called after initialization
     * @dev Must revert if the bid does not exist
     */
    function getBid(address bidder) external view returns (BundleBid memory);

    /**
     * @notice Retrieve the results of the auction
     * @return Details about the auction results
     * @dev Can only be called after the auction was solved and the winners were determined
     */
    function getResult() external view returns (AllocationResult memory);

    /**
     * @notice Retrieve information about which bid won an item identified by its ID
     * @return Bid that won the item queried
     * @dev Can only be called after the auction was solved and the winners were determined
     * @dev Must revert if the item was not allocated
     */
    function getWinningBidOfItem(uint256 itemId) external view returns (BundleBid memory);
}
