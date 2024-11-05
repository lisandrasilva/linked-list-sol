// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract AuctionList {

  address public constant NULL_NODE = address(0);

  type Timestamp is uint256;

  struct AuctionNode{
    uint256 end;
    address next;
  }

  address public head;
  mapping (address => AuctionNode) public auctions;

  constructor(){}

  // Sorted by auction address
  function insertSorted(address auction, uint256 end) public {
    address current = head;
    address previous = current;

    if (current == NULL_NODE) {
        head = auction;
        auctions[auction].end = end;
        auctions[auction].next = NULL_NODE;
    }

    while (current != NULL_NODE) {
        // Already on the list
        if (current == auction)
            break;

        if (auction < current) {
            // Insert the auction
            if (current == head) {
                // The auction is the head of the list
                head = auction;
            }
            else {
                auctions[previous].next = auction;
            }
            auctions[auction].next = current;
            auctions[auction].end = end;
            break;
        }

        previous = current;
        current = auctions[current].next;
    }
  }

  // Removes from the list all auctions that have been completed
  function removeCompleted() public {
    address current = head;
    address previous = current;

    while(current != NULL_NODE) {
      address next = auctions[current].next;

      if (block.timestamp > auctions[current].end) {
        // Remove the completed auction
        if (current == head) {
          head = next;
        }
        else {
          auctions[previous].next = next;
        }
        delete auctions[current];
      }

      previous = current;
      current = next;
    }
  }
}