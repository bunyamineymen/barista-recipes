import { ArcList, ArcListItem, ComponentContent } from '@kit.ArkUI';
import { CustomButton } from '../view/CustomButton';
import { RecipeService } from '../service/RecipeService';
import { BrewRecord } from '../model/RecipeModel';
import { CoffeeConstants } from '../common/Constants';
import { BackButton } from '../view/BackButton';

@Builder
function header(): void {
  Text('BREW HISTORY')
    .fontSize(15)
    .fontWeight(FontWeight.Bold)
    .textAlign(TextAlign.Center)
    .margin({ top: 16, bottom: 12 })
    .fontColor(CoffeeConstants.TEXT_COLOR)
}

@Component
export struct BrewHistory {
  @State history: BrewRecord[] = [];
  context: UIContext = this.getUIContext();
  header: ComponentContent<object> = new ComponentContent(this.context, wrapBuilder(header));
  @Consume('pathStack') pathStack: NavPathStack;

  async aboutToAppear() {
    this.history = await RecipeService.getInstance().getBrewHistory();
  }

  formatDate(timestamp: number): string {
    const date = new Date(timestamp);
    return `${date.getHours()}:${date.getMinutes().toString().padStart(2, '0')}`;
  }

  build() {
    NavDestination() {
      Stack({ alignContent: Alignment.TopStart }) {
        Flex() {
          ArcList({ header: this.header }) {
            if (this.history.length === 0) {
              ArcListItem() {
                Text('No history yet')
                  .fontColor(Color.White)
                  .textAlign(TextAlign.Center)
                  .width('100%')
              }
            }
            ForEach(this.history, (item: BrewRecord) => {
              ArcListItem() {
                Column() {
                  Text(item.recipeName)
                    .fontSize(16)
                    .fontWeight(FontWeight.Bold)
                    .fontColor(CoffeeConstants.ACCENT_COLOR)
                  Text(this.formatDate(item.timestamp))
                    .fontSize(12)
                    .fontColor(Color.White)
                }
                .width('100%')
                .padding(10)
                .backgroundColor('#444444')
                .borderRadius(10)
                .margin({ top: 5, bottom: 5 })
                .onClick(() => {
                  this.pathStack.pushPathByName('RecipeDetail', item.recipeId)
                })
              }
            }, (item: BrewRecord) => item.timestamp.toString())
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
