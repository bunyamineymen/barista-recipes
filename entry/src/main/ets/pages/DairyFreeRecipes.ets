import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { CustomButton } from '../view/CustomButton';

@Builder
function header() {
    Text('DAIRY-FREE RECIPES')
      .fontSize(15)
      .fontWeight(FontWeight.Bold)
      .textAlign(TextAlign.Center)
      .margin({ top: 16, bottom: 12 })
      .fontColor('#C6A575')
}

@Component
export struct DairyFreeRecipes {
  watchSize: string = '466px'
  context: UIContext = this.getUIContext()
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header))
  @Consume('pathStack') pathStack: NavPathStack;


  build() {
    NavDestination() {
      Flex() {
        ArcList({ header: this.header }) {
          ArcListItem() {
            CustomButton({ title: 'Americano'})
              .onClick(() => {
                this.pathStack.pushPathByName('CurrentCoffeeRecipe', null)
              })

          }

          ArcListItem() {
            CustomButton({ title: 'Aerocano'})
              .onClick(() => {
                this.pathStack.pushPathByName('CurrentCoffeeRecipe', null)
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
  }
}
