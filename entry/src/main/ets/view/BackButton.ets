import { CoffeeConstants } from '../common/Constants';

@Component
export struct BackButton {
  @Consume('pathStack') pathStack: NavPathStack;

  build() {
    Button(' < ')
      .backgroundColor(CoffeeConstants.ACCENT_COLOR)
      .fontColor(CoffeeConstants.PRIMARY_COLOR)
      .borderRadius(20)
      .width(40)
      .height(40)
      .position({ x: 20, y: 20 })
      .onClick(() => {
        this.pathStack.pop();
      })
  }
}
