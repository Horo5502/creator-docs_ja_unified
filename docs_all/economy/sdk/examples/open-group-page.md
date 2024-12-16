---
description: "Opens your group or group store."
sidebar_position: 1
sidebar_custom_props:
    customIcon: 🔗
---

# Open Group Page

import SellerNotification from '/docs/economy/_sellers-notification.mdx';

<SellerNotification/>

OpenGroupPage is a prefab that makes it easier for users to access purchasable CE listings. Use it to create buttons that open group pages or specific listings.

import HowToImportExample from '/docs/economy/_ce-how-to-import.mdx';

<HowToImportExample/>

## Prefabs included
* **OpenGroupPagePrefab**: Includes a button that opens a group page. Also includes a text description.
* **OpenGroupPageSimplePrefab**: Includes a button that opens a group page. Does not include a text description.

![OpenGroupPrefab](/img/economy/examples/Comparison-OpenGroupPage.png "Compares group prefabs.")

## How to Use

For each prefab, you'll need to replace any ID with the ID of your own group.

1. Select the chosen prefab in your Unity scene.
2. Set the ID of the group that owns the product in the `Group ID` field in the inspector window.
    -   Find your group ID by opening your group [on the website](https://vrchat.com/home/groups) and copying the ID in the address bar of your browser. For example: `grp_a4f791af-a167-4c91-b849-2e37e37f509a`. Any short code (i.e. `EXAMPL.9920`) will **not** work.

![DragGroupID](/img/economy/examples/Group-Id-Copying.png "Where to put the group ID.")

3. Toggle the **OpenToStorePage** toggle on the prefab if you want to open to your store page directly. If unchecked, the button will open to your group page instead of directly to your store.
4. For **OpenListing/OpenListingSimple:** Set the ID of the listing in the `Listing ID` field in the inspector window.
    - Find your listing ID by [opening the listing section](https://vrchat.com/b/monetization/home/marketplace/storefront/listings) of your store and copying its ID. 

![DragListingID](/img/economy/examples/Listing-Id-Copying.png "Where to put the listing ID.")

5. Toggle the **OpenToStorePage** toggle on the prefab if you want to open to your store page directly. If unchecked, the button will open to your group page instead of directly to your store.

![IDPasting](/img/economy/examples/Group-versus-Store-links.png "Instructions on finding and pasting IDs.")

6. Run Build & Test!

## Inspector Parameters

#### OpenGroupPage 
* `Group ID` - The group ID of the group you want to open.
* `Open To Store Page` - If true, will open the store page for the group instead of the group info page.
