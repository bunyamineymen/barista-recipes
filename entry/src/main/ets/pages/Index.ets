import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { CustomButton } from '../view/CustomButton';
import { CurrentCoffeeRecipe } from './CurrentCoffeeRecipe';
import { DairyFreeRecipes } from './DairyFreeRecipes';
import { MilkRecipes } from './MilkRecipes';
import { ReadyCoffee } from './ReadyCoffee';
import { CategoryRecipes } from './CategoryRecipes';
import { RecipeDetail } from './RecipeDetail';
import { FavoritesList } from './FavoritesList';
import { BrewHistory } from './BrewHistory';
import { CoffeeConstants } from '../common/Constants';
import { RecipeCategory } from '../model/RecipeModel';
import { promptAction } from '@kit.ArkUI';

@Builder
function header() {
  Text('BARISTA RECIPES')
    .fontSize(20)
    .fontWeight(FontWeight.Bold)
    .textAlign(TextAlign.Center)
    .margin({ top: 16, bottom: 12 })
    .fontColor(CoffeeConstants.TEXT_COLOR)
}

@Entry
@Component
struct Index {
  watchSize: string = CoffeeConstants.WATCH_SIZE
  context: UIContext = this.getUIContext()
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header))
  @Provide('pathStack') pathStack: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string, param: object) {
    if (name === 'MilkRecipes') {
      MilkRecipes()
    } else if (name === 'DairyFreeRecipes') {
      DairyFreeRecipes()
    } else if (name === 'ColdRecipes') {
      CategoryRecipes({ category: RecipeCategory.COLD })
    } else if (name === 'SpecialRecipes') {
      CategoryRecipes({ category: RecipeCategory.SPECIAL })
    } else if (name === 'TeaRecipes') {
      CategoryRecipes({ category: RecipeCategory.TEA })
    } else if (name === 'RecipeDetail') {
      RecipeDetail({ recipeId: param as unknown as string })
    } else if (name === 'CurrentCoffeeRecipe') {
      CurrentCoffeeRecipe({ recipeId: param as unknown as string })
    } else if (name === 'ReadyCoffee') {
      ReadyCoffee({ recipeId: param as unknown as string })
    } else if (name === 'Favorites') {
      FavoritesList()
    } else if (name === 'History') {
      BrewHistory()
    }
  }

  build() {
    Navigation(this.pathStack) {
      Flex() {
        ArcList({ header: this.header }) {
          ArcListItem() {
            CustomButton({ title: 'Milk Recipes' })
              .onClick(() => {
                this.pathStack.pushPathByName('MilkRecipes', null)
              })
          }

          ArcListItem() {
            CustomButton({ title: 'Dairy-Free Recipes' })
              .onClick(() => {
                this.pathStack.pushPathByName('DairyFreeRecipes', null)
              })
          }

          ArcListItem() {
            CustomButton({ title: 'Cold Coffees' })
              .onClick(() => {
                this.pathStack.pushPathByName('ColdRecipes', null)
              })
          }

          ArcListItem() {
            CustomButton({ title: 'Special Recipes' })
              .onClick(() => {
                this.pathStack.pushPathByName('SpecialRecipes', null)
              })
          }

          ArcListItem() {
            CustomButton({ title: 'Tea-Based' })
              .onClick(() => {
                this.pathStack.pushPathByName('TeaRecipes', null)
              })
          }
          ArcListItem() {
            CustomButton({ title: 'Favorites' })
              .onClick(() => {
                this.pathStack.pushPathByName('Favorites', null)
              })
          }

          ArcListItem() {
            CustomButton({ title: 'History' })
              .onClick(() => {
                this.pathStack.pushPathByName('History', null)
              })
          }
        }
      }
      .width(this.watchSize)
      .height(this.watchSize)
      .backgroundColor(CoffeeConstants.PRIMARY_COLOR)
    }
    .hideTitleBar(true)
    .hideBackButton(true)
    .navDestination(this.PageMap)
    .mode(NavigationMode.Stack)
  }
}
