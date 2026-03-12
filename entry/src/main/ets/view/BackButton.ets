import { ArcButton, ArcButtonOptions, ArcButtonPosition, ArcButtonStyleMode, ArcButtonStatus } from '@kit.ArkUI';

@Component
export struct BackButton {
  @Consume('pathStack') pathStack: NavPathStack;

  build() {
    ArcButton({
      options: {
        label: 'Back',
        position: ArcButtonPosition.TOP_EDGE,
        styleMode: ArcButtonStyleMode.EMPHASIZED_LIGHT,
        status: ArcButtonStatus.NORMAL,
        backgroundBlurStyle: BlurStyle.NONE
      }
    })
      .onClick(() => {
        this.pathStack.pop();
      })
  }
}
