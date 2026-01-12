import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { CustomButton } from '../view/CustomButton';
import { CurrentCoffeeRecipe } from './CurrentCoffeeRecipe';
import { DairyFreeRecipes } from './DairyFreeRecipes';
import { MilkRecipes } from './MilkRecipes';
import { ReadyCoffee } from './ReadyCoffee';

@Builder
function header() {
    Text('BARISTA RECIPES')
      .fontSize(20)
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Center)
      .margin({ top: 16, bottom: 12 })
      .fontColor('#C6A575')
}


@Entry
@Component
struct Index {
  watchSize: string = '466px'
  context: UIContext = this.getUIContext()
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header))
  @Provide('pathStack') pathStack: NavPathStack = new NavPathStack()

  @Builder
  PageMap(name: string) {
    if (name === 'MilkRecipes') {
      MilkRecipes()
    } else if (name === 'DairyFreeRecipes') {
      DairyFreeRecipes()
    }
    else if (name === 'CurrentCoffeeRecipe') {
      CurrentCoffeeRecipe()
    }
    else if (name === 'ReadyCoffee') {
      ReadyCoffee()
    }
  }


build() {
  Navigation(this.pathStack) {
    Flex(){
    ArcList({ header: this.header }) {
      ArcListItem() {
        CustomButton({ title: 'Dairy-Free Recipes' })
          .onClick(() => {
            this.pathStack.pushPathByName('DairyFreeRecipes', null)
          })
      }

      ArcListItem() {
        CustomButton({ title: 'Milk Recipes' })
          .onClick(() => {
            this.pathStack.pushPathByName('MilkRecipes', null)
          })
      }
    }
  }
    .width(this.watchSize)
    .height(this.watchSize)
    .backgroundColor('#5B3A1F')
  }
  .hideTitleBar(true)
  .hideBackButton(true)
  .navDestination(this.PageMap)
  .mode(NavigationMode.Stack)
}
}