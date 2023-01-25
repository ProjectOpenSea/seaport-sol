// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import { OrderType, BasicOrderType, ItemType, Side } from "seaport/lib/ConsiderationEnums.sol";

/**
 * @notice OpenSea API returns order data as a JSON object under the "protocol_data" field,
 *         which includes all fields for both OrderParameters and OrderComponents. When
 *         "consideration" is truncated to length totalOriginalConsiderationItems, it
 *         includes all information necessary to re-construct the order hash.
 */
struct ProtocolDataJson {
    bytes32 conduitKey;
    ConsiderationItemJson[] consideration;
    uint256 counter;
    uint256 endTime;
    OfferItemJson[] offer;
    address offerer;
    OrderType orderType;
    uint256 salt;
    uint256 startTime;
    uint256 totalOriginalConsiderationItems;
    address zone;
    bytes32 zoneHash;
}

struct OrderComponentsJson {
    bytes32 conduitKey;
    ConsiderationItemJson[] consideration;
    uint256 counter;
    uint256 endTime;
    OfferItemJson[] offer;
    address offerer;
    OrderType orderType;
    uint256 salt;
    uint256 startTime;
    address zone;
    bytes32 zoneHash;
}

struct OfferItemJson {
    uint256 endAmount;
    uint256 identifierOrCriteria;
    ItemType itemType;
    uint256 startAmount;
    address token;
}

struct ConsiderationItemJson {
    uint256 endAmount;
    uint256 identifierOrCriteria;
    ItemType itemType;
    address payable recipient;
    uint256 startAmount;
    address token;
}

struct SpentItemJson {
    uint256 amount;
    uint256 identifier;
    ItemType itemType;
    address token;
}

struct ReceivedItemJson {
    uint256 amount;
    uint256 identifier;
    ItemType itemType;
    address payable recipient;
    address token;
}

struct BasicOrderParametersJson {
    AdditionalRecipientJson[] additionalRecipients;
    BasicOrderType basicOrderType;
    uint256 considerationAmount;
    uint256 considerationIdentifier;
    address considerationToken;
    uint256 endTime;
    bytes32 fulfillerConduitKey;
    uint256 offerAmount;
    uint256 offerIdentifier;
    address offerToken;
    address payable offerer;
    bytes32 offererConduitKey;
    uint256 salt;
    bytes signature;
    uint256 startTime;
    uint256 totalOriginalAdditionalRecipients;
    address zone;
    bytes32 zoneHash;
}

struct AdditionalRecipientJson {
    uint256 amount;
    address payable recipient;
}

struct OrderParametersJson {
    bytes32 conduitKey;
    ConsiderationItemJson[] consideration;
    uint256 endTime;
    OfferItemJson[] offer;
    address offerer;
    OrderType orderType;
    uint256 salt;
    uint256 startTime;
    uint256 totalOriginalConsiderationItems;
    address zone;
    bytes32 zoneHash;
}

struct OrderJson {
    OrderParametersJson parameters;
    bytes signature;
}

struct AdvancedOrderJson {
    uint120 denominator;
    bytes extraData;
    uint120 numerator;
    OrderParametersJson parameters;
    bytes signature;
}

struct OrderStatusJson {
    uint120 denominator;
    bool isCancelled;
    bool isValidated;
    uint120 numerator;
}

struct CriteriaResolverJson {
    bytes32[] criteriaProof;
    uint256 identifier;
    uint256 index;
    uint256 orderIndex;
    Side side;
}

struct FulfillmentJson {
    FulfillmentComponentJson[] considerationComponents;
    FulfillmentComponentJson[] offerComponents;
}

struct FulfillmentComponentJson {
    uint256 itemIndex;
    uint256 orderIndex;
}

struct ExecutionJson {
    bytes32 conduitKey;
    ReceivedItemJson item;
    address offerer;
}
