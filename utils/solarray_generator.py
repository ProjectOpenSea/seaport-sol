base = """// SPDX-License-Identifier: MIT

library Solarray {{
    {}
}}
"""

func = """
    function {0}{4}s({1}) internal pure returns ({0}[] memory) {{
        {0}[] memory arr = new {0}[]({2});
{3}
        return arr;
    }}
"""
types = [
    "Order memory",
    "AdvancedOrder memory",
    "OrderComponents memory",
    "OrderParameters memory",
    "OfferItem memory",
    "ConsiderationItem memory",
    "SpentItem memory",
    "ReceivedItem memory",
    "FulfillmentComponent memory",
    "FulfillmentComponent[] memory",
    "CriteriaResolver memory",
    "AdditionalRecipient memory",
    "BasicOrderParameters memory",
    "Fulfillment memory",
]

length = 8
variable = "a"

functions = []

for type in types:
    for i in range(1, length):
        arguments = ",".join([f"{type} {chr(ord('a') + j)}" for j in range(i)])
        copying = "\n".join([f"\t\tarr[{j}] = {chr(ord('a') + j)};" for j in range(i)])
        formatted = func.format(
            type.split()[0], arguments, i, copying, "e" if type == "address" else ""
        )
        functions.append(formatted)

print(base.format("\n".join(functions)))
