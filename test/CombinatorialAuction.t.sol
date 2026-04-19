// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {ICombinatorialAuction} from "../src/ICombinatorialAuction.sol";
import {CombinatorialAuction} from "../src/CombinatorialAuction.sol";

contract CombinatorialAuctionTest is Test {
    ICombinatorialAuction public auction;

    function setUp() public {
        auction = new CombinatorialAuction();
    }

    function test_dummy() public pure {
        assertTrue(true);
    }
}
