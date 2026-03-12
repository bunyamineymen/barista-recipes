import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { CustomButton } from '../view/CustomButton';
import { RecipeService } from '../service/RecipeService';
import { Recipe, RecipeCategory } from '../model/RecipeModel';
import { CoffeeConstants } from '../common/Constants';
import { BackButton } from '../view/BackButton';

@Builder
function header(): void {
  Text('DAIRY-FREE RECIPES')
    .fontSize(15)
    .fontWeight(FontWeight.Bold)
    .textAlign(TextAlign.Center)
    .margin({ top: 16, bottom: 12 })
    .fontColor(CoffeeConstants.TEXT_COLOR)
}

@Component
export struct DairyFreeRecipes {
  watchSize: string = CoffeeConstants.WATCH_SIZE
  context: UIContext = this.getUIContext()
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header))
  @Consume('pathStack') pathStack: NavPathStack;
  recipes: Recipe[] = RecipeService.getInstance().getRecipesByCategory(RecipeCategory.DAIRY_FREE);

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Flex() {
          ArcList({ header: this.header }) {
            ForEach(this.recipes, (recipe: Recipe) => {
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
          .margin({ top: 40, left: 40 })
      }
      .width(this.watchSize)
      .height(this.watchSize)
      .backgroundColor(CoffeeConstants.PRIMARY_COLOR)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
