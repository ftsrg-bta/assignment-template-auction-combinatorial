// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {ICombinatorialAuction} from "../src/ICombinatorialAuction.sol";
import {CombinatorialAuction} from "../src/CombinatorialAuction.sol";

contract CombinatorialAuctionScript is Script {
    ICombinatorialAuction public auction;

    function run() public {
        vm.startBroadcast();

        auction = new CombinatorialAuction();

        vm.stopBroadcast();
    }
}
