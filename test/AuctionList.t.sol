// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "kontrol-cheatcodes/KontrolCheats.sol";

import "src/AuctionList.sol";

contract AuctionListTest is AuctionList, Test, KontrolCheats { 

    function setUp() public {
        kevm.symbolicStorage(address(this));
        _initializeList();
    }

    // Initializes an arbitrary list
    function _initializeList() public {
        address previous = NULL_NODE;

        while (kevm.freshBool() != false) {
            // Create a new auction
            address auction = kevm.freshAddress();
            vm.assume(auction != address(0));
            vm.assume(auction > previous);
            Timestamp end = Timestamp.wrap(freshUInt256());

            if (previous == NULL_NODE)
                head = auction;
            else
                auctions[previous].next = auction;
            
            auctions[auction].end = end;

            previous = auction;
        }

        if (previous == NULL_NODE)
            head = NULL_NODE;
        else
            auctions[previous].next = NULL_NODE; 
    }

    // Asserts that a list is sorted by auction address
    function _assertSorted() public view {
        address current = head;

        while(current != NULL_NODE) {
            address next = auctions[current].next;
            if (next != NULL_NODE)
                assert(current < next);
            current = next;
        }
    }

    function _assertNoCompletedAuctions() public view {
        address current = head;

        while(current != NULL_NODE) {
            assert(block.timestamp < Timestamp.unwrap(auctions[current].end));
            current = auctions[current].next;
        }
    }

    // Test that the insert function preserves the sortdness of the list
    function testInsertSorted(address auction, Timestamp end) public {
        _assertSorted();

        vm.assume(auction != address(0));
        insertSorted(auction, end);

        _assertSorted();
    }

    function testRemoveCompleted() public {
        _assertSorted();

        removeCompleted();

        _assertSorted();
        // Now this property should hold
        _assertNoCompletedAuctions();
    }

}