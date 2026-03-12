import { CoffeeConstants } from '../common/Constants';

@Component
export struct BackButton {
  @Consume('pathStack') pathStack: NavPathStack;

  build() {
    Button('<')
      .backgroundColor(CoffeeConstants.ACCENT_COLOR)
      .fontColor(CoffeeConstants.PRIMARY_COLOR)
      .borderRadius(20)
      .width(40)
      .height(40)
      .fontSize(24) // Slightly smaller than 30 to ensure it fits comfortably in 40x40
      .fontWeight(FontWeight.Bold)
      .padding(0)
      .onClick(() => {
        if (this.pathStack) {
          this.pathStack.pop();
        }
      })
      // Using a higher hitTestPriority or ensuring it's on top
      .hitTestBehavior(HitTestMode.Block)
  }
}
