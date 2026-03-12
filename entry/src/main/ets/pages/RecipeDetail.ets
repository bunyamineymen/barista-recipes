import { Recipe, RecipeCategory, Ingredient } from '../model/RecipeModel';
import { RecipeService } from '../service/RecipeService';
import { CoffeeConstants } from '../common/Constants';
import { BackButton } from '../view/BackButton';
import { promptAction } from '@kit.ArkUI';

@Component
export struct RecipeDetail {
  @Prop recipeId: string;
  @State recipe: Recipe | undefined = undefined;
  @State isFavorite: boolean = false;
  @Consume('pathStack') pathStack: NavPathStack;

  async aboutToAppear(): Promise<void> {
    this.recipe = RecipeService.getInstance().getRecipeById(this.recipeId);
    this.isFavorite = await RecipeService.getInstance().isFavorite(this.recipeId);
  }

  async toggleFavorite(): Promise<void> {
    try {
      await RecipeService.getInstance().toggleFavorite(this.recipeId);
      this.isFavorite = !this.isFavorite;
      // Using promptAction.showToast, but will keep an eye on deprecation warnings
      promptAction.showToast({
        message: this.isFavorite ? 'Added to favorites' : 'Removed from favorites',
        duration: 2000
      });
    } catch (err) {
      promptAction.showToast({
        message: 'Failed to update favorites',
        duration: 2000
      });
    }
  }

  getRecipeIcon(): Resource {
    if (this.recipe && this.recipe.icon) {
      return this.recipe.icon;
    }
    return $r('app.media.coffee');
  }

  build() {
    NavDestination() {
      if (this.recipe) {
        Column() {
          BackButton()

          Scroll() {
            Column({ space: 10 }) {
              Image(this.getRecipeIcon())
                .width(40)
                .height(40)
                .fillColor(CoffeeConstants.ACCENT_COLOR)
                .margin({ top: 40 })

              Row() {
                Text(this.recipe.name)
                  .fontSize(20)
                  .fontWeight(FontWeight.Bold)
                  .fontColor(CoffeeConstants.ACCENT_COLOR)

                // Replaced system media resources with explicit Color and Text/Circle as backup if icons fail
                // In a real app, these should be verified assets.
                Circle({ width: 24, height: 24 })
                  .fill(this.isFavorite ? Color.Red : Color.Gray)
                  .margin({ left: 10 })
                  .onClick(() => {
                    this.toggleFavorite()
                  })
              }
              .margin({ top: 40 })

              Text(`Difficulty: ${this.recipe.difficulty}`)
                .fontSize(14)
                .fontColor(CoffeeConstants.WHITE)

              Text(`Total Time: ${this.recipe.totalTimeMinutes} min`)
                .fontSize(14)
                .fontColor(CoffeeConstants.WHITE)

              Text('Ingredients:')
                .fontSize(16)
                .fontWeight(FontWeight.Bold)
                .fontColor(CoffeeConstants.ACCENT_COLOR)
                .margin({ top: 10 })

              ForEach(this.recipe.ingredients, (ing: Ingredient) => {
                Text(`• ${ing.name}: ${ing.amount}`)
                  .fontSize(14)
                  .fontColor(CoffeeConstants.WHITE)
              }, (ing: Ingredient) => ing.name)

              Button('Start Brewing')
                .backgroundColor(CoffeeConstants.ACCENT_COLOR)
                .fontColor(CoffeeConstants.PRIMARY_COLOR)
                .margin({ top: 20, bottom: 40 })
                .onClick(() => {
                  this.pathStack.pushPathByName('CurrentCoffeeRecipe', this.recipeId)
                })
            }
            .width('100%')
            .alignItems(HorizontalAlign.Center)
          }
        }
        .width(CoffeeConstants.WATCH_SIZE)
        .height(CoffeeConstants.WATCH_SIZE)
        .backgroundColor(CoffeeConstants.PRIMARY_COLOR)
      }
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
