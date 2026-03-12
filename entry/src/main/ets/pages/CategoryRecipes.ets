import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { CustomButton } from '../view/CustomButton';
import { RecipeService } from '../service/RecipeService';
import { Recipe, RecipeCategory } from '../model/RecipeModel';
import { CoffeeConstants } from '../common/Constants';
import { BackButton } from '../view/BackButton';

@Builder
function header(title: string) {
  Text(title.toUpperCase())
    .fontSize(15)
    .fontWeight(FontWeight.Bold)
    .textAlign(TextAlign.Center)
    .margin({ top: 16, bottom: 12 })
    .fontColor(CoffeeConstants.TEXT_COLOR)
}

@Component
export struct CategoryRecipes {
  @Prop category: RecipeCategory;
  watchSize: string = CoffeeConstants.WATCH_SIZE
  context: UIContext = this.getUIContext()
  @Consume('pathStack') pathStack: NavPathStack;
  recipes: Recipe[] = [];

  aboutToAppear() {
    this.recipes = RecipeService.getInstance().getRecipesByCategory(this.category);
  }

  build() {
    NavDestination() {
      Flex() {
        BackButton()
        ArcList({
          header: new ComponentContent(this.context, wrapBuilder(header), this.category as string)
        }) {
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
      .width(this.watchSize)
      .height(this.watchSize)
      .backgroundColor(CoffeeConstants.PRIMARY_COLOR)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
  }
}
