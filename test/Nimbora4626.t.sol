// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import {Test, console2} from "forge-std/Test.sol";
import {Nimbora4626} from "../src/Nimbora4626.sol";

contract Nimbora4626Test is Test {
    uint256 goerliFork;
    Nimbora4626 public nimbora4626;

    function setUp() public {
        vm.createFork(vm.envString("RPC_URL_GOERLI"));
        vm.selectFork(goerliFork);

        // this is just a tests with sDai on goerli
        nimbora4626 =
        new Nimbora4626(0x7064a5072969aeDD517cb1B2ded6A266636c01a3, 0x11fE4B6AE13d2a6055C8D9cF65c55bac32B5d844, 0x9Fe0DCcA65378208ac8C46A3A2397e530859748f, 0xaB00D7EE6cFE37cCCAd006cEC4Db6253D7ED3a22);
    }

    function test_addressToApprove() public {
        console2.log(nimbora4626.addressToApprove());
    }
}
