import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { CustomButton } from '../view/CustomButton';
import { RecipeService } from '../service/RecipeService';
import { Recipe } from '../model/RecipeModel';
import { CoffeeConstants } from '../common/Constants';
import { BackButton } from '../view/BackButton';

@Builder
function header(): void {
  Text('FAVORITE RECIPES')
    .fontSize(15)
    .fontWeight(FontWeight.Bold)
    .textAlign(TextAlign.Center)
    .margin({ top: 16, bottom: 12 })
    .fontColor(CoffeeConstants.TEXT_COLOR)
}

@Component
export struct FavoritesList {
  @State favoriteRecipes: Recipe[] = [];
  context: UIContext = this.getUIContext();
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header));
  @Consume('pathStack') pathStack: NavPathStack;

  async aboutToAppear() {
    await this.loadFavorites();
  }

  async loadFavorites() {
    const favoriteIds = await RecipeService.getInstance().getFavorites();
    const allRecipes = RecipeService.getInstance().getAllRecipes();
    this.favoriteRecipes = allRecipes.filter(r => favoriteIds.includes(r.id));
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Flex() {
          ArcList({ header: this.header }) {
            if (this.favoriteRecipes.length === 0) {
              ArcListItem() {
                Text('No favorites yet')
                  .fontColor(Color.White)
                  .textAlign(TextAlign.Center)
                  .width('100%')
                  .margin({ top: 20 })
              }
            }
            ForEach(this.favoriteRecipes, (recipe: Recipe) => {
              ArcListItem() {
                CustomButton({ title: recipe.name })
                  .onClick(() => {
                    this.pathStack.pushPathByName('RecipeDetail', recipe.id)
                  })
              }
            }, (recipe: Recipe) => recipe.id)
          }
        }
        .width('100%')
        .height('100%')

        BackButton()
          .margin({ top: 20, left: 20 })
      }
      .width(CoffeeConstants.WATCH_SIZE)
      .height(CoffeeConstants.WATCH_SIZE)
      .backgroundColor(CoffeeConstants.PRIMARY_COLOR)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
