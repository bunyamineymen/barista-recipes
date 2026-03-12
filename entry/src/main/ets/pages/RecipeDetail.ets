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

  async aboutToAppear() {
    this.recipe = RecipeService.getInstance().getRecipeById(this.recipeId);
    this.isFavorite = await RecipeService.getInstance().isFavorite(this.recipeId);
  }

  async toggleFavorite() {
    try {
      await RecipeService.getInstance().toggleFavorite(this.recipeId);
      this.isFavorite = !this.isFavorite;
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
    if (!this.recipe) return $r('app.media.coffee');
    // Using coffee icon for all as minimalist SVGs are not available,
    // but in a real app, we'd use tarife ozel icons.
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

                SymbolIcon($r('sys.symbol.heart_fill'))
                  .fontSize(24)
                  .fontColor(this.isFavorite ? Color.Red : CoffeeConstants.WHITE)
                  .margin({ left: 10 })
                  .onClick(() => this.toggleFavorite())
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
