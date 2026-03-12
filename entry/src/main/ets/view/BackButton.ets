import { CoffeeConstants } from '../common/Constants';

@Component
export struct BackButton {
  @Consume('pathStack') pathStack: NavPathStack;

  build() {
    Button('<')
      .backgroundColor(CoffeeConstants.ACCENT_COLOR)
      .fontColor(CoffeeConstants.PRIMARY_COLOR)
      .borderRadius(40)
      .width(80)
      .height(80)
      .fontSize(30)
      .fontWeight(FontWeight.Bold)
      .position({ x: 10, y: 10 }) // Moved slightly more to the corner
      .onClick(() => {
        if (this.pathStack) {
          this.pathStack.pop();
        }
      })
  }
}
