import { CoffeeConstants } from '../common/Constants';

@Component
export struct BackButton {
  @Consume('pathStack') pathStack: NavPathStack;

  build() {
    Button('<')
      .backgroundColor(CoffeeConstants.ACCENT_COLOR)
      .fontColor(CoffeeConstants.PRIMARY_COLOR)
      .borderRadius(16)
      .width(32)
      .height(32)
      .fontSize(16)
      .fontWeight(FontWeight.Bold)
      .padding(0)
      .onClick(() => {
        if (this.pathStack) {
          this.pathStack.pop();
        }
      })
      .hitTestBehavior(HitTestMode.Block)
  }
}
