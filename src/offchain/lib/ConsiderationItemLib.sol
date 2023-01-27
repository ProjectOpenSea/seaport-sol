// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { ConsiderationItem, ReceivedItem } from "seaport/lib/ConsiderationStructs.sol";
import { ItemType } from "seaport/lib/ConsiderationEnums.sol";

library ConsiderationItemLib {
    bytes32 private constant CONSIDERATION_ITEM_MAP_POSITION = keccak256("seaport.ConsiderationItemDefaults");

    /**
     * @notice clears a default ConsiderationItem from storage
     * @param defaultName the name of the default to clear
     */
    function clear(string memory defaultName) internal {
        mapping(string => ConsiderationItem) storage considerationItemMap = _considerationItemMap();
        ConsiderationItem storage item = considerationItemMap[defaultName];
        // clear all fields
        item.itemType = ItemType.NATIVE;
        item.token = address(0);
        item.identifierOrCriteria = 0;
        item.startAmount = 0;
        item.endAmount = 0;
        item.recipient = payable(address(0));
    }

    /**
     * @notice gets a default ConsiderationItem from storage
     * @param defaultName the name of the default for retrieval
     */
    function fromDefault(string memory defaultName) internal view returns (ConsiderationItem memory item) {
        mapping(string => ConsiderationItem) storage considerationItemMap = _considerationItemMap();
        item = considerationItemMap[defaultName];
    }

    /**
     * @notice saves an ConsiderationItem as a named default
     * @param considerationItem the ConsiderationItem to save as a default
     * @param defaultName the name of the default for retrieval
     */
    function saveDefault(ConsiderationItem memory considerationItem, string memory defaultName) internal {
        mapping(string => ConsiderationItem) storage considerationItemMap = _considerationItemMap();
        considerationItemMap[defaultName] = considerationItem;
    }

    /**
     * @notice makes a copy of an ConsiderationItem in-memory
     * @param item the ConsiderationItem to make a copy of in-memory
     */
    function copy(ConsiderationItem memory item) internal pure returns (ConsiderationItem memory) {
        return ConsiderationItem({
            itemType: item.itemType,
            token: item.token,
            identifierOrCriteria: item.identifierOrCriteria,
            startAmount: item.startAmount,
            endAmount: item.endAmount,
            recipient: item.recipient
        });
    }

    /**
     * @notice gets the storage position of the default ConsiderationItem map
     */
    function _considerationItemMap()
        private
        pure
        returns (mapping(string => ConsiderationItem) storage considerationItemMap)
    {
        bytes32 position = CONSIDERATION_ITEM_MAP_POSITION;
        assembly {
            considerationItemMap.slot := position
        }
    }

    // methods for configuring a single of each of an ConsiderationItem's fields, which modifies the ConsiderationItem
    // in-place and
    // returns it

    /**
     * @notice sets the item type
     * @param item the ConsiderationItem to modify
     * @param itemType the item type to set
     * @return the modified ConsiderationItem
     */
    function withItemType(
        ConsiderationItem memory item,
        ItemType itemType
    )
        internal
        pure
        returns (ConsiderationItem memory)
    {
        item.itemType = itemType;
        return item;
    }

    /**
     * @notice sets the token address
     * @param item the ConsiderationItem to modify
     * @param token the token address to set
     * @return the modified ConsiderationItem
     */
    function withToken(ConsiderationItem memory item, address token) internal pure returns (ConsiderationItem memory) {
        item.token = token;
        return item;
    }

    /**
     * @notice sets the identifier or criteria
     * @param item the ConsiderationItem to modify
     * @param identifierOrCriteria the identifier or criteria to set
     * @return the modified ConsiderationItem
     */
    function withIdentifierOrCriteria(
        ConsiderationItem memory item,
        uint256 identifierOrCriteria
    )
        internal
        pure
        returns (ConsiderationItem memory)
    {
        item.identifierOrCriteria = identifierOrCriteria;
        return item;
    }

    /**
     * @notice sets the start amount
     * @param item the ConsiderationItem to modify
     * @param startAmount the start amount to set
     * @return the modified ConsiderationItem
     */
    function withStartAmount(
        ConsiderationItem memory item,
        uint256 startAmount
    )
        internal
        pure
        returns (ConsiderationItem memory)
    {
        item.startAmount = startAmount;
        return item;
    }

    /**
     * @notice sets the end amount
     * @param item the ConsiderationItem to modify
     * @param endAmount the end amount to set
     * @return the modified ConsiderationItem
     */
    function withEndAmount(
        ConsiderationItem memory item,
        uint256 endAmount
    )
        internal
        pure
        returns (ConsiderationItem memory)
    {
        item.endAmount = endAmount;
        return item;
    }

    /**
     * @notice sets the recipient
     * @param item the ConsiderationItem to modify
     * @param recipient the recipient to set
     * @return the modified ConsiderationItem
     */
    function withRecipient(
        ConsiderationItem memory item,
        address recipient
    )
        internal
        pure
        returns (ConsiderationItem memory)
    {
        item.recipient = payable(recipient);
        return item;
    }

    function toReceivedItem(ConsiderationItem memory item) internal pure returns (ReceivedItem memory) {
        return ReceivedItem({
            itemType: item.itemType,
            token: item.token,
            identifier: item.identifierOrCriteria,
            amount: item.startAmount,
            recipient: item.recipient
        });
    }
}
