> **Note:** To access all shared projects, get information about environment setup, and view other guides, please visit [Explore-In-HMOS-Wearable Index](https://github.com/Explore-In-HMOS-Wearable/hmos-index).

# BaristaRecipes

BaristaRecipes is a demo app that helps users brew delicious coffee at home. It includes **milk-based** and **non-dairy** recipes and guides you step‑by‑step through preparation. Using **Sensor Kit**, assist with mixing and timing for a more consistent brew.

# Preview

<div>
  <img src="screenshots/c1.PNG" width="24%">
  <img src="screenshots/c3.PNG" width="24%">
  <img src="screenshots/c2.PNG" width="24%">
  <img src="screenshots/coffeeoutput.png" width="24%">
</div>

# Use Cases

BaristaRecipes lets users:

* **Browse 15+ curated recipes** across 5 categories: **Milk**, **Dairy-Free**, **Cold**, **Special**, and **Tea-Based**.
* **View detailed recipe profiles** including **Ingredients**, **Brewing Time**, and **Difficulty Level**.
* **Follow precise step-by-step instructions** with integrated **Step Timers** and dynamic **Progress Rings**.
* **Interact with hardware sensors**:
    * **Haptic Feedback**: Receive unique vibration patterns for step changes and timer completion.
    * **Accelerometer**: Track "Mixing" progress in real-time by shaking your device.
* **Personalize the experience**:
    * **Favorites**: Save your most-loved recipes for quick access.
    * **Brew History**: Automatically track and review your 20 most recent brewing sessions.
* **Navigate effortlessly** on circular wearable displays using an optimized UI, dedicated **BackButton**, and **Swipe-to-go-back** gestures.

# Tech Stack

Languages: ArkTS
Frameworks: HarmonyOS NEXT SDK 5.1.0(18)
Tools: DevEco Studio Vers 5.1.0.820
Libraries: `@kit.ArkUI`, `@kit.SensorServiceKit`, `@kit.ArkData` (Preferences)

# Directory Structure

```
  entry/src/main/ets/
  |---common
  |   |---Constants.ets                    // App-wide theme and constant definitions
  |---entryability
  |   |---EntryAbility.ets                 // Lifecycle management and service init
  |---model
  |   |---RecipeModel.ets                  // Data structures and interfaces
  |---pages
  |   |---BrewHistory.ets                  // Persisted brewing session history
  |   |---CategoryRecipes.ets              // Dynamic category listing
  |   |---CurrentCoffeeRecipe.ets          // Timed brewing guide with haptics
  |   |---FavoritesList.ets                // User's bookmarked recipes
  |   |---Index.ets                        // Main menu and Navigation root
  |   |---ReadyCoffee.ets                  // Final stage with Mixing Detection
  |   |---RecipeDetail.ets                 // Detailed ingredients and metadata
  |---service
  |   |---RecipeService.ets                // Recipe management and local storage (Preferences)
  |---view
  |   |---BackButton.ets                   // Wearable-optimized navigation button
  |   |---CustomButton.ets                 // Reusable menu button component
```

# Constraints and Restrictions
## Supported Devices
Huawei Watch 5

# License

BaristaRecipes is distributed under the terms of the MIT License.  
See the [LICENSE](/LICENSE) for more information.
